package com.proteingallery.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {

    private static HikariDataSource dataSource;

    static {
        try {
            // ✅ Fallbacks for local development
            String DB_URL = System.getenv("DB_URL") != null ? 
                            System.getenv("DB_URL") : 
                            "jdbc:mysql://localhost:3306/protein_gallery"
                           + "?useSSL=false"
                           + "&allowPublicKeyRetrieval=true"
                           + "&useUnicode=true"
                           + "&characterEncoding=UTF-8"
                           + "&autoReconnect=true"
                           + "&useJDBCCompliantTimezoneShift=true"
                           + "&useLegacyDatetimeCode=false"
                           + "&serverTimezone=UTC";

            String DB_USER = System.getenv("DB_USER") != null ? 
                             System.getenv("DB_USER") : "root";
                             
            String DB_PASS = System.getenv("DB_PASS") != null ? 
                             System.getenv("DB_PASS") : "root"; // ← REPLACE THIS WITH YOUR MYSQL PASSWORD

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(DB_URL);
            config.setUsername(DB_USER);
            config.setPassword(DB_PASS);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            // Pool settings
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setConnectionTimeout(30000);
            config.setIdleTimeout(600000);
            config.setMaxLifetime(1800000);

            // Performance
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);
            System.out.println("✅ Database connected successfully!");

        } catch (Exception e) {
            System.err.println("❌ DB Connection Failed: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Database Initialization Failed", e);
        }
    }

    /**
     * Gets a connection from the HikariCP pool.
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource is null. Initialization failed.");
        }
        return dataSource.getConnection();
    }
    
    /**
     * Closes the data source pool (usually called on application shutdown).
     */
    public static void closePool() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            System.out.println("HikariCP pool closed.");
        }
    }
}
