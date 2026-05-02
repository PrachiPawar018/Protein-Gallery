package com.proteingallery.test;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.proteingallery.util.DBConnection;

public class DatabaseTest {
    public static void main(String[] args) {
        System.out.println("🔍 Testing Database Connection...");

        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("✅ Connection established successfully!");

            // Test basic query
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT VERSION() as version");

            if (rs.next()) {
                System.out.println("📊 MySQL Version: " + rs.getString("version"));
            }

            // Check if database exists
            rs = stmt.executeQuery("SHOW DATABASES LIKE 'protein_gallery'");
            if (rs.next()) {
                System.out.println("✅ Database 'protein_gallery' exists!");
            } else {
                System.out.println("❌ Database 'protein_gallery' does not exist!");
            }

            // Check tables
            rs = stmt.executeQuery("SHOW TABLES FROM protein_gallery");
            System.out.println("📋 Tables in protein_gallery:");
            boolean hasTables = false;
            while (rs.next()) {
                hasTables = true;
                System.out.println("  - " + rs.getString(1));
            }

            if (!hasTables) {
                System.out.println("  No tables found. Database might not be initialized.");
            }

            // Test user count
            try {
                rs = stmt.executeQuery("SELECT COUNT(*) as user_count FROM protein_gallery.users");
                if (rs.next()) {
                    int userCount = rs.getInt("user_count");
                    System.out.println("👥 Users in database: " + userCount);
                }
            } catch (Exception e) {
                System.out.println("❌ Error checking users table: " + e.getMessage());
            }

            // Test product count
            try {
                rs = stmt.executeQuery("SELECT COUNT(*) as product_count FROM protein_gallery.products");
                if (rs.next()) {
                    int productCount = rs.getInt("product_count");
                    System.out.println("📦 Products in database: " + productCount);
                }
            } catch (Exception e) {
                System.out.println("❌ Error checking products table: " + e.getMessage());
            }

            rs.close();
            stmt.close();

            System.out.println("✅ Database test completed successfully!");

        } catch (Exception e) {
            System.err.println("❌ Database test failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}