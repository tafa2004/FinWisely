package com.finwisely.dao;

import com.finwisely.model.Account;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AccountDAO {

    // Retrieve an account using its ID
    public Account getAccountById(Connection connection, int accountId)
            throws SQLException {

        String sql = "SELECT * FROM accounts WHERE account_id = ? FOR UPDATE";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, accountId);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {
                    return new Account(
                            result.getInt("account_id"),
                            result.getInt("customer_id"),
                            result.getString("account_type"),
                            result.getBigDecimal("balance"),
                            result.getString("status")
                    );
                }
            }
        }

        return null;
    }
    // Update an account's balance
    public void updateBalance(Connection connection,
                              int accountId,
                              BigDecimal newBalance)
                              throws SQLException {

        String sql = "UPDATE accounts SET balance = ? " +
                     "WHERE account_id = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setBigDecimal(1, newBalance);
            statement.setInt(2, accountId);

            int rowsUpdated = statement.executeUpdate();

            if (rowsUpdated != 1) {
                throw new SQLException(
                        "Account balance could not be updated."
                );
            }
        }
    }
}