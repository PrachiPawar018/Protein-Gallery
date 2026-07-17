package com.proteingallery.util;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws SQLException {
        return DBUtil.getConnection();
    }

    public static void closeQuietly(AutoCloseable resource) {
        DBUtil.closeQuietly(resource);
    }
}
