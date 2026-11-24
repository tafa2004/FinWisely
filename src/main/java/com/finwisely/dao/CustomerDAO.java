package com.finwisely.dao;

import com.finwisely.model.Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CustomerDAO {

    // Retrieve a customer using their ID
    public Customer getCustomerById(Connection connection, int customerId)
            throws SQLException {

        String sql = "SELECT customer_id, first_name, last_name, " +
                     "email, phone, national_id, date_created " +
                     "FROM customers WHERE customer_id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, customerId);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {
                    return new Customer(
                            result.getInt("customer_id"),
                            result.getString("first_name"),
                            result.getString("last_name"),
                            result.getString("email"),
                            result.getString("phone"),
                            result.getString("national_id"),
                            result.getTimestamp("date_created")
                                  .toLocalDateTime()
                    );
                }
            }
        }

        return null;
    }
}