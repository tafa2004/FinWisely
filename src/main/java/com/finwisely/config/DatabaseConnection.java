package com.finwisely.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DatabaseConnection {

    private DatabaseConnection() {
        // Prevent creating objects of this utility class.
    }

    public static Connection getConnection() throws SQLException {

        String url = System.getenv("FINWISELY_DB_URL");
        String username = System.getenv("FINWISELY_DB_USER");
        String password = System.getenv("FINWISELY_DB_PASSWORD");

        if (isBlank(url) || isBlank(username) || isBlank(password)) {
            throw new SQLException(
                "Database configuration is missing. Check your environment variables."
            );
        }

        return DriverManager.getConnection(url, username, password);
    }

    private static boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}