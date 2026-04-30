package com.proteingallery.dao;

import com.proteingallery.model.Coupon;
import com.proteingallery.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CouponDAO {
    
    public Coupon getCouponByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = ? AND is_active = TRUE AND (expiry_date >= CURDATE() OR expiry_date IS NULL)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, code);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Coupon coupon = new Coupon();
                    coupon.setId(rs.getInt("id"));
                    coupon.setCode(rs.getString("code"));
                    coupon.setDiscountPercent(rs.getInt("discount_percent"));
                    coupon.setMinOrderAmount(rs.getBigDecimal("min_order_amount"));
                    coupon.setExpiryDate(rs.getDate("expiry_date"));
                    coupon.setActive(rs.getBoolean("is_active"));
                    return coupon;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
