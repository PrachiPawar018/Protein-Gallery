package com.proteingallery.controller;

import com.proteingallery.dao.CartDAO;
import com.proteingallery.dao.CouponDAO;
import com.proteingallery.dao.OrderDAO;
import com.proteingallery.model.CartItem;
import com.proteingallery.model.Coupon;
import com.proteingallery.model.Order;
import com.proteingallery.model.OrderItem;
import com.proteingallery.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/checkout", "/checkout/apply-coupon", "/checkout/process"})
public class OrderServlet extends HttpServlet {

    private CartDAO cartDAO;
    private CouponDAO couponDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        cartDAO = new CartDAO();
        couponDAO = new CouponDAO();
        orderDAO = new OrderDAO();
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        User user = getSessionUser(request);

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if ("/checkout".equals(path)) {
            List<CartItem> cartItems = cartDAO.getCartItemsByUserId(user.getId());
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart.jsp?error=Cart+is+empty");
                return;
            }

            BigDecimal subtotal = BigDecimal.ZERO;
            for (CartItem item : cartItems) {
                if (item.getTotalPrice() != null) {
                    subtotal = subtotal.add(item.getTotalPrice());
                }
            }

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        User user = getSessionUser(request);

        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User not logged in");
            return;
        }

        if ("/checkout/apply-coupon".equals(path)) {
            String code = request.getParameter("code");
            Coupon coupon = couponDAO.getCouponByCode(code);
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            
            if (coupon != null) {
                out.print("{\"success\": true, \"discountPercent\": " + coupon.getDiscountPercent() + ", \"minOrder\": " + coupon.getMinOrderAmount() + "}");
            } else {
                out.print("{\"success\": false, \"error\": \"Invalid or expired coupon\"}");
            }
            out.flush();
            return;
        }

        if ("/checkout/process".equals(path)) {
            String address = request.getParameter("address");
            String city = request.getParameter("city");
            String zip = request.getParameter("zip");
            String paymentMethod = request.getParameter("payment_method");
            String couponCode = request.getParameter("coupon_code");

            List<CartItem> cartItems = cartDAO.getCartItemsByUserId(user.getId());
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart.jsp?error=Cart+is+empty");
                return;
            }

            BigDecimal subtotal = BigDecimal.ZERO;
            List<OrderItem> orderItems = new ArrayList<>();
            for (CartItem ci : cartItems) {
                subtotal = subtotal.add(ci.getTotalPrice());
                
                OrderItem oi = new OrderItem();
                oi.setProductId(ci.getProductId());
                oi.setQuantity(ci.getQuantity());
                oi.setPrice(ci.getFinalPrice());
                orderItems.add(oi);
            }

            BigDecimal discountAmount = BigDecimal.ZERO;
            if (couponCode != null && !couponCode.trim().isEmpty()) {
                Coupon coupon = couponDAO.getCouponByCode(couponCode);
                if (coupon != null && subtotal.compareTo(coupon.getMinOrderAmount()) >= 0) {
                    discountAmount = subtotal.multiply(BigDecimal.valueOf(coupon.getDiscountPercent())).divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
                } else {
                    couponCode = null; // invalid coupon
                }
            }

            BigDecimal totalAmount = subtotal.subtract(discountAmount);
            String fullAddress = address + ", " + city + " - " + zip;

            Order order = new Order();
            order.setUserId(user.getId());
            order.setTotalAmount(totalAmount);
            order.setDiscountAmount(discountAmount);
            order.setCouponCode(couponCode);
            order.setShippingAddress(fullAddress);
            order.setPaymentMethod(paymentMethod);
            order.setStatus("PENDING");
            order.setItems(orderItems);

            int orderId = orderDAO.createOrder(order);

            if (orderId > 0) {
                cartDAO.clearCart(user.getId());
                
                if ("RAZORPAY".equalsIgnoreCase(paymentMethod)) {
                    response.sendRedirect(request.getContextPath() + "/payment/init?orderId=" + orderId);
                } else {
                    orderDAO.updateOrderStatus(orderId, "CONFIRMED");
                    PaymentServlet.deductStockForOrder(orderId);
                    PaymentServlet.sendConfirmationEmail(orderId);
                    response.sendRedirect(request.getContextPath() + "/order-success.jsp?orderId=" + orderId);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/checkout?error=Failed+to+create+order");
            }
        }
    }
}
