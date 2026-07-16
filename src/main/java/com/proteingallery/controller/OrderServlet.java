package com.proteingallery.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import com.proteingallery.dao.CartDAO;
import com.proteingallery.dao.OrderDAO;
import com.proteingallery.model.CartItem;
import com.proteingallery.model.Order;
import com.proteingallery.model.OrderItem;
import com.proteingallery.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class OrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        String path = request.getPathInfo();
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            if ("/history".equals(path)) {
                List<Order> orders = orderDAO.findByUserId(userId);
                out.print(JsonUtil.array(orders.stream().map(this::orderJson).toArray(String[]::new)));
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        String path = request.getPathInfo();
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            switch (path) {
                case "/checkout" -> processCheckout(request, out, userId);
                default -> response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    private void processCheckout(HttpServletRequest request, PrintWriter out, int userId) {
        String shippingAddress = request.getParameter("shippingAddress");
        if (shippingAddress == null || shippingAddress.isBlank()) {
            out.print(JsonUtil.object("success:false", "message:" + JsonUtil.quote("Please enter a shipping address.")));
            return;
        }
        List<CartItem> cartItems = cartDAO.getCartItems(userId);
        if (cartItems.isEmpty()) {
            out.print(JsonUtil.object("success:false", "message:" + JsonUtil.quote("Your cart is empty.")));
            return;
        }
        BigDecimal total = cartItems.stream()
                .map(CartItem::getTotalPrice)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        Order order = new Order();
        order.setUserId(userId);
        order.setCreatedAt(LocalDateTime.now());
        order.setStatus("Pending");
        order.setTotalAmount(total);
        order.setPaymentId("");
        order.setPaymentStatus("Pending");
        for (CartItem item : cartItems) {
            OrderItem orderItem = new OrderItem();
            orderItem.setProduct(item.getProduct());
            orderItem.setQuantity(item.getQuantity());
            orderItem.setUnitPrice(item.getProduct().getPrice());
            order.getItems().add(orderItem);
        }
        int orderId = orderDAO.createOrder(order);
        cartDAO.clearCart(userId);
        out.print(JsonUtil.object(
                "success:true",
                "message:" + JsonUtil.quote("Order placed successfully."),
                "orderId:" + orderId,
                "total:" + total
        ));
    }

    private String orderJson(Order order) {
        return JsonUtil.object(
                "id:" + order.getId(),
                "status:" + JsonUtil.quote(order.getStatus()),
                "totalAmount:" + order.getTotalAmount(),
                "paymentStatus:" + JsonUtil.quote(order.getPaymentStatus()),
                "createdAt:" + JsonUtil.quote(order.getCreatedAt().toString()),
                "items:" + JsonUtil.array(order.getItems().stream().map(this::orderItemJson).toArray(String[]::new))
        );
    }

    private String orderItemJson(OrderItem item) {
        return JsonUtil.object(
                "productId:" + item.getProduct().getId(),
                "productName:" + JsonUtil.quote(item.getProduct().getName()),
                "quantity:" + item.getQuantity(),
                "unitPrice:" + item.getUnitPrice()
        );
    }
}
