package com.proteingallery.dao;

import com.proteingallery.model.Order;
import com.proteingallery.model.OrderItem;
import com.proteingallery.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class OrderDAO {

    public int createOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, total_amount, discount_amount, coupon_code, status, shipping_address, payment_method) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, order.getUserId());
            stmt.setBigDecimal(2, order.getTotalAmount());
            stmt.setBigDecimal(3, order.getDiscountAmount());
            stmt.setString(4, order.getCouponCode());
            stmt.setString(5, order.getStatus() != null ? order.getStatus() : "PENDING");
            stmt.setString(6, order.getShippingAddress());
            stmt.setString(7, order.getPaymentMethod());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);
                        insertOrderItems(orderId, order.getItems(), conn);
                        return orderId;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    private void insertOrderItems(int orderId, java.util.List<OrderItem> items, Connection conn) throws SQLException {
        if (items == null || items.isEmpty()) return;
        
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (OrderItem item : items) {
                stmt.setInt(1, orderId);
                stmt.setInt(2, item.getProductId());
                stmt.setInt(3, item.getQuantity());
                stmt.setBigDecimal(4, item.getPrice());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
    
    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
