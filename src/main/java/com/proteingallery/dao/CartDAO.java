package com.proteingallery.dao;

import com.proteingallery.model.CartItem;
import com.proteingallery.model.Product;
import com.proteingallery.util.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<CartItem> getCartItems(int userId) {
        String sql = "SELECT c.id AS cart_id, c.quantity, p.* " +
                "FROM cart c JOIN products p ON c.product_id = p.id " +
                "WHERE c.user_id = ?";
        List<CartItem> cart = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("cart_id"));
                    item.setUserId(userId);
                    item.setQuantity(rs.getInt("quantity"));
                    Product product = new Product();
                    product.setId(rs.getInt("id"));
                    product.setName(rs.getString("name"));
                    product.setDescription(rs.getString("description"));
                    product.setCategory(rs.getString("category"));
                    product.setGoalTag(rs.getString("goal_tag"));
                    product.setPrice(rs.getBigDecimal("price"));
                    product.setImageUrl(rs.getString("image_url"));
                    product.setStock(rs.getInt("stock"));
                    item.setProduct(product);
                    item.setTotalPrice(product.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                    cart.add(item);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return cart;
    }

    public boolean addOrUpdateCartItem(int userId, int productId, int quantity) {
        String select = "SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement check = conn.prepareStatement(select)) {
            check.setInt(1, userId);
            check.setInt(2, productId);
            try (ResultSet rs = check.executeQuery()) {
                if (rs.next()) {
                    int cartId = rs.getInt("id");
                    int existing = rs.getInt("quantity");
                    String update = "UPDATE cart SET quantity = ? WHERE id = ?";
                    try (PreparedStatement stmt = conn.prepareStatement(update)) {
                        stmt.setInt(1, existing + quantity);
                        stmt.setInt(2, cartId);
                        return stmt.executeUpdate() == 1;
                    }
                }
            }
            String insert = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insert)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, productId);
                stmt.setInt(3, quantity);
                return stmt.executeUpdate() == 1;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean updateQuantity(int cartId, int quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, cartId);
            return stmt.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean removeCartItem(int cartId) {
        String sql = "DELETE FROM cart WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            return stmt.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
