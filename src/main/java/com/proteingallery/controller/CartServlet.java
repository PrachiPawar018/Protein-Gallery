package com.proteingallery.controller;

import com.proteingallery.dao.CartDAO;
import com.proteingallery.model.CartItem;
import com.proteingallery.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        int userId = (Integer) session.getAttribute("userId");
        List<CartItem> items = cartDAO.getCartItems(userId);
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            out.print(JsonUtil.array(items.stream().map(this::cartItemJson).toArray(String[]::new)));
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
            if ("/add".equals(path)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                boolean success = cartDAO.addOrUpdateCartItem(userId, productId, Math.max(quantity, 1));
                out.print(JsonUtil.object("success:" + success));
            } else if ("/update".equals(path)) {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                boolean success = cartDAO.updateQuantity(cartId, Math.max(quantity, 1));
                out.print(JsonUtil.object("success:" + success));
            } else if ("/remove".equals(path)) {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                boolean success = cartDAO.removeCartItem(cartId);
                out.print(JsonUtil.object("success:" + success));
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    private String cartItemJson(CartItem item) {
        return JsonUtil.object(
                "id:" + item.getId(),
                "productId:" + item.getProduct().getId(),
                "productName:" + JsonUtil.quote(item.getProduct().getName()),
                "imageUrl:" + JsonUtil.quote(item.getProduct().getImageUrl()),
                "unitPrice:" + item.getProduct().getPrice(),
                "quantity:" + item.getQuantity(),
                "totalPrice:" + item.getTotalPrice()
        );
    }
}
