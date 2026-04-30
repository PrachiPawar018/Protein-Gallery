package com.proteingallery.controller;

import com.proteingallery.dao.OrderDAO;
import com.proteingallery.util.AppConfig;
import com.proteingallery.util.DBConnection;
import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;
import org.json.JSONObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(urlPatterns = {"/payment/init", "/payment/verify"})
public class PaymentServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/payment/init".equals(path)) {
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr == null) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);
            BigDecimal amount = getOrderAmount(orderId);
            if (amount == null) {
                response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=Invalid+Order");
                return;
            }

            try {
                String rzpKey = AppConfig.RAZORPAY_KEY_ID;
                String rzpSecret = AppConfig.RAZORPAY_KEY_SECRET;

                RazorpayClient razorpay = new RazorpayClient(rzpKey, rzpSecret);
                
                JSONObject orderRequest = new JSONObject();
                orderRequest.put("amount", amount.multiply(new BigDecimal("100")).intValue());
                orderRequest.put("currency", "INR");
                orderRequest.put("receipt", "txn_" + orderId);
                
                Order rzpOrder = razorpay.orders.create(orderRequest);
                
                request.setAttribute("rzpOrderId", rzpOrder.get("id"));
                request.setAttribute("amount", amount.multiply(new BigDecimal("100")).intValue());
                request.setAttribute("dbOrderId", orderId);
                request.setAttribute("rzpKey", rzpKey);
                
                request.getRequestDispatcher("/razorpay-checkout.jsp").forward(request, response);
                
            } catch (RazorpayException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=Payment+Initialization+Failed");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        
        if ("/payment/verify".equals(path)) {
            String razorpayPaymentId = request.getParameter("razorpay_payment_id");
            String razorpayOrderId = request.getParameter("razorpay_order_id");
            String razorpaySignature = request.getParameter("razorpay_signature");
            int dbOrderId = Integer.parseInt(request.getParameter("dbOrderId"));

            String rzpSecret = AppConfig.RAZORPAY_KEY_SECRET;

            try {
                JSONObject options = new JSONObject();
                options.put("razorpay_payment_id", razorpayPaymentId);
                options.put("razorpay_order_id", razorpayOrderId);
                options.put("razorpay_signature", razorpaySignature);

                boolean status = Utils.verifyPaymentSignature(options, rzpSecret);

                if (status) {
                    orderDAO.updateOrderStatus(dbOrderId, "CONFIRMED");
                    insertPaymentRecord(dbOrderId, razorpayPaymentId, "SUCCESS");
                    deductStockForOrder(dbOrderId);
                    sendConfirmationEmail(dbOrderId);
                    response.sendRedirect(request.getContextPath() + "/order-success.jsp?orderId=" + dbOrderId);
                } else {
                    orderDAO.updateOrderStatus(dbOrderId, "FAILED");
                    insertPaymentRecord(dbOrderId, razorpayPaymentId, "FAILED");
                    response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=Payment+Verification+Failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/checkout.jsp?error=Server+Error+during+verification");
            }
        }
    }

    private BigDecimal getOrderAmount(int orderId) {
        String sql = "SELECT total_amount FROM orders WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal("total_amount");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private void insertPaymentRecord(int orderId, String rzpPaymentId, String status) {
        String sql = "INSERT INTO payments (order_id, payment_method, transaction_id, status) VALUES (?, 'RAZORPAY', ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            stmt.setString(2, rzpPaymentId);
            stmt.setString(3, status);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void deductStockForOrder(int orderId) {
        String sqlSelect = "SELECT product_id, quantity FROM order_items WHERE order_id = ?";
        String sqlUpdate = "UPDATE products SET stock = stock - ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement selectStmt = conn.prepareStatement(sqlSelect);
             PreparedStatement updateStmt = conn.prepareStatement(sqlUpdate)) {
             
            selectStmt.setInt(1, orderId);
            try (ResultSet rs = selectStmt.executeQuery()) {
                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    int quantity = rs.getInt("quantity");
                    
                    updateStmt.setInt(1, quantity);
                    updateStmt.setInt(2, productId);
                    updateStmt.executeUpdate();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void sendConfirmationEmail(int orderId) {
        String sql = "SELECT o.total_amount, o.shipping_address, u.email FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String totalAmount = rs.getBigDecimal("total_amount").toString();
                    String address = rs.getString("shipping_address");
                    String email = rs.getString("email");
                    
                    new Thread(() -> {
                        com.proteingallery.util.EmailUtil.sendOrderConfirmation(email, orderId, totalAmount, address);
                    }).start();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
