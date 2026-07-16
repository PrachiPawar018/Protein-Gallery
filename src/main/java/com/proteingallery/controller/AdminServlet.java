package com.proteingallery.controller;

import com.proteingallery.dao.ProductDAO;
import com.proteingallery.dao.UserDAO;
import com.proteingallery.model.Product;
import com.proteingallery.model.User;
import com.proteingallery.util.DBUtil;
import com.proteingallery.util.JsonUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        String path = request.getPathInfo();
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            if ("/stats".equals(path)) {
                out.print(getStatsJson());
            } else if ("/users".equals(path)) {
                List<User> users = userDAO.findAll();
                out.print(JsonUtil.array(users.stream().map(this::userJson).toArray(String[]::new)));
            } else if ("/products".equals(path)) {
                List<Product> products = productDAO.findAll(null, null, null, null, null);
                out.print(JsonUtil.array(products.stream().map(this::productJson).toArray(String[]::new)));
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        }
    }

    private String getStatsJson() {
        try (Connection conn = DBUtil.getConnection()) {
            int users = count(conn, "SELECT COUNT(*) FROM users");
            int products = count(conn, "SELECT COUNT(*) FROM products WHERE is_active = TRUE");
            int orders = count(conn, "SELECT COUNT(*) FROM orders");
            return JsonUtil.object(
                    "users:" + users,
                    "products:" + products,
                    "orders:" + orders
            );
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private int count(Connection conn, String sql) throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private String userJson(User user) {
        return JsonUtil.object(
                "id:" + user.getId(),
                "name:" + JsonUtil.quote(user.getName()),
                "email:" + JsonUtil.quote(user.getEmail()),
                "role:" + JsonUtil.quote(user.getRole())
        );
    }

    private String productJson(Product product) {
        return JsonUtil.object(
                "id:" + product.getId(),
                "name:" + JsonUtil.quote(product.getName()),
                "category:" + JsonUtil.quote(product.getCategory()),
                "goalTag:" + JsonUtil.quote(product.getGoalTag()),
                "price:" + product.getPrice(),
                "stock:" + product.getStock()
        );
    }
}
