package com.proteingallery.controller.admin;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.proteingallery.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int totalOrders = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        int totalProducts = 0;
        int totalUsers = 0;

        try (Connection conn = DBConnection.getConnection()) {
            // Orders
            try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*), SUM(total_amount) FROM orders WHERE status != 'FAILED'")) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    totalOrders = rs.getInt(1);
                    totalRevenue = rs.getBigDecimal(2) != null ? rs.getBigDecimal(2) : BigDecimal.ZERO;
                }
            }
            // Products
            try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM products")) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) totalProducts = rs.getInt(1);
            }
            // Users
            try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE role = 'USER'")) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) totalUsers = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalUsers", totalUsers);

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }
}
