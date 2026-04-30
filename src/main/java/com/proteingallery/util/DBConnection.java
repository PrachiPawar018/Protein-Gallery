package com.proteingallery.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {

    private static HikariDataSource dataSource;

    static {
        try {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(AppConfig.DB_URL);
            config.setUsername(AppConfig.DB_USER);
            config.setPassword(AppConfig.DB_PASSWORD);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");
            
            // Optimization settings for HikariCP
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(30000); // 30 seconds
            config.setMaxLifetime(1800000); // 30 minutes
            config.setConnectionTimeout(30000); // 30 seconds

            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            System.err.println("Failed to initialize HikariCP Database Connection Pool");
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
        }
    }
}
