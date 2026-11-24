package com.finwisely.config;

import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.assertNotNull;

class DatabaseConnectionTest {

    @Test
    void shouldEstablishDatabaseConnection() throws SQLException {

        try (Connection connection = DatabaseConnection.getConnection()) {

            assertNotNull(connection);

            DatabaseMetaData metadata = connection.getMetaData();

            System.out.println("Connected successfully!");
            System.out.println("Database: " + connection.getCatalog());
            System.out.println("Database product: " +
                    metadata.getDatabaseProductName());
            System.out.println("Database version: " +
                    metadata.getDatabaseProductVersion());
            System.out.println("Connected user: " +
                    metadata.getUserName());
        }
    }
}