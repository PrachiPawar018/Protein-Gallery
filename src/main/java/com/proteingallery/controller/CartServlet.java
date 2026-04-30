package com.proteingallery.controller;

import com.proteingallery.dao.CartDAO;
import com.proteingallery.model.User;
import com.proteingallery.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(urlPatterns = {"/cart/add", "/cart/update", "/cart/remove", "/cart/count"})
public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;

    @Override
    public void init() {
        cartDAO = new CartDAO();
    }

    private User getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (User) session.getAttribute("user") : null;
    }

    private void sendJsonResponse(HttpServletResponse response, String json) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        User user = getSessionUser(request);
        
        if (user == null) {
            sendJsonResponse(response, "{\"count\": 0}");
            return;
        }

        if ("/cart/count".equals(path)) {
            int count = cartDAO.getCartItemCount(user.getId());
            sendJsonResponse(response, "{\"count\": " + count + "}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        User user = getSessionUser(request);
        
        if (user == null) {
            if (isAjax(request)) {
                sendJsonResponse(response, "{\"success\": false, \"error\": \"Not logged in\"}");
                return;
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        }

        try {
            if ("/cart/add".equals(path)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                
                // Optional parameter depending on the form
                String qtyParam = request.getParameter("quantity");
                int quantity = (qtyParam != null && !qtyParam.trim().isEmpty()) ? Integer.parseInt(qtyParam) : 1;
                
                boolean success = cartDAO.addOrUpdateCartItem(user.getId(), productId, quantity);
                if (isAjax(request)) {
                    int count = cartDAO.getCartItemCount(user.getId());
                    sendJsonResponse(response, "{\"success\": " + success + ", \"cartCount\": " + count + "}");
                } else {
                    response.sendRedirect(request.getContextPath() + "/cart.jsp");
                }
            } 
            else if ("/cart/update".equals(path)) {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                
                boolean success = cartDAO.updateCartQuantity(cartId, quantity);
                
                BigDecimal newTotal = BigDecimal.ZERO;
                List<CartItem> items = cartDAO.getCartItemsByUserId(user.getId());
                for (CartItem item : items) {
                    newTotal = newTotal.add(item.getTotalPrice());
                }
                
                sendJsonResponse(response, "{\"success\": " + success + ", \"newTotal\": " + newTotal.doubleValue() + "}");
            } 
            else if ("/cart/remove".equals(path)) {
                int cartId = Integer.parseInt(request.getParameter("cartId"));
                boolean success = cartDAO.removeCartItem(cartId);
                int count = cartDAO.getCartItemCount(user.getId());
                
                BigDecimal newTotal = BigDecimal.ZERO;
                List<CartItem> items = cartDAO.getCartItemsByUserId(user.getId());
                for (CartItem item : items) {
                    newTotal = newTotal.add(item.getTotalPrice());
                }

                sendJsonResponse(response, "{\"success\": " + success + ", \"cartCount\": " + count + ", \"newTotal\": " + newTotal.doubleValue() + "}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (isAjax(request)) {
                sendJsonResponse(response, "{\"success\": false, \"error\": \"Server error\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/cart.jsp?error=Operation+Failed");
            }
        }
    }

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
    }
}
