package com.proteingallery.controller.admin;

import com.proteingallery.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, Object>> orders = new ArrayList<>();
        
        String sql = "SELECT o.id, u.email, o.total_amount, o.status, o.payment_method, o.created_at " +
                     "FROM orders o JOIN users u ON o.user_id = u.id ORDER BY o.created_at DESC LIMIT 50";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> order = new HashMap<>();
                order.put("id", rs.getInt("id"));
                order.put("email", rs.getString("email"));
                order.put("total", rs.getBigDecimal("total_amount"));
                order.put("status", rs.getString("status"));
                order.put("payment_method", rs.getString("payment_method"));
                order.put("created_at", rs.getTimestamp("created_at"));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin-orders.jsp").forward(request, response);
    }
}
