package com.proteingallery.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.proteingallery.model.Order;
import com.proteingallery.model.OrderItem;
import com.proteingallery.model.Product;
import com.proteingallery.util.DBUtil;

public class OrderDAO {

    public int createOrder(Order order) {
        String insertOrder = "INSERT INTO orders (user_id, total_amount, status, payment_id, payment_status) VALUES (?, ?, ?, ?, ?)";
        String insertItem = "INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement orderStmt = conn.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                orderStmt.setInt(1, order.getUserId());
                orderStmt.setBigDecimal(2, order.getTotalAmount());
                orderStmt.setString(3, order.getStatus());
                orderStmt.setString(4, order.getPaymentId());
                orderStmt.setString(5, order.getPaymentStatus());
                int result = orderStmt.executeUpdate();
                if (result == 0) {
                    conn.rollback();
                    throw new SQLException("Failed to create order");
                }
                try (ResultSet keys = orderStmt.getGeneratedKeys()) {
                    if (keys.next()) {
                        order.setId(keys.getInt(1));
                    }
                }
            }
            try (PreparedStatement itemStmt = conn.prepareStatement(insertItem)) {
                for (OrderItem item : order.getItems()) {
                    itemStmt.setInt(1, order.getId());
                    itemStmt.setInt(2, item.getProduct().getId());
                    itemStmt.setInt(3, item.getQuantity());
                    itemStmt.setBigDecimal(4, item.getUnitPrice());
                    itemStmt.addBatch();
                }
                itemStmt.executeBatch();
            }
            conn.commit();
            return order.getId();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public List<Order> findByUserId(int userId) {
        String sql = "SELECT o.id, o.total_amount, o.status, o.payment_id, o.payment_status, o.created_at, oi.id AS item_id, oi.quantity, oi.unit_price, p.id AS product_id, p.name, p.image_url " +
                "FROM orders o " +
                "LEFT JOIN order_items oi ON o.id = oi.order_id " +
                "LEFT JOIN products p ON oi.product_id = p.id " +
                "WHERE o.user_id = ? ORDER BY o.created_at DESC";

        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                Order current = null;
                while (rs.next()) {
                    int orderId = rs.getInt("id");
                    if (current == null || current.getId() != orderId) {
                        current = new Order();
                        current.setId(orderId);
                        current.setUserId(userId);
                        current.setTotalAmount(rs.getBigDecimal("total_amount"));
                        current.setStatus(rs.getString("status"));
                        current.setPaymentId(rs.getString("payment_id"));
                        current.setPaymentStatus(rs.getString("payment_status"));
                        current.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                        orders.add(current);
                    }
                    if (rs.getInt("item_id") > 0) {
                        Product product = new Product();
                        product.setId(rs.getInt("product_id"));
                        product.setName(rs.getString("name"));
                        product.setImageUrl(rs.getString("image_url"));
                        OrderItem item = new OrderItem();
                        item.setId(rs.getInt("item_id"));
                        item.setProduct(product);
                        item.setQuantity(rs.getInt("quantity"));
                        item.setUnitPrice(rs.getBigDecimal("unit_price"));
                        current.getItems().add(item);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return orders;
    }
}
