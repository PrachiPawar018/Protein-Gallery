package com.proteingallery.dao;

import com.proteingallery.model.Product;
import com.proteingallery.util.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> findAll(String search, String category, String goal, BigDecimal minPrice, BigDecimal maxPrice) {
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE is_active = TRUE");
        List<Object> params = new ArrayList<>();

        if (search != null && !search.isBlank()) {
            sql.append(" AND (name LIKE ? OR brand LIKE ? OR category LIKE ?)");
            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (category != null && !category.isBlank()) {
            sql.append(" AND category = ?");
            params.add(category);
        }
        if (goal != null && !goal.isBlank()) {
            sql.append(" AND goal_tag = ?");
            params.add(goal);
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }
        sql.append(" ORDER BY created_at DESC");

        List<Product> products = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapProduct(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return products;
    }

    public List<Product> findFeatured() {
        String sql = "SELECT * FROM products WHERE is_active = TRUE AND featured = TRUE ORDER BY created_at DESC LIMIT 8";
        List<Product> products = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                products.add(mapProduct(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return products;
    }

    public Product findById(int productId) {
        String sql = "SELECT * FROM products WHERE id = ? AND is_active = TRUE";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapProduct(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public boolean updateStock(int productId, int newStock) {
        String sql = "UPDATE products SET stock = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, newStock);
            stmt.setInt(2, productId);
            return stmt.executeUpdate() == 1;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private Product mapProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setDescription(rs.getString("description"));
        product.setCategory(rs.getString("category"));
        product.setGoalTag(rs.getString("goal_tag"));
        product.setPrice(rs.getBigDecimal("price"));
        product.setImageUrl(rs.getString("image_url"));
        product.setStock(rs.getInt("stock"));
        product.setFeatured(rs.getBoolean("featured"));
        return product;
    }
}
