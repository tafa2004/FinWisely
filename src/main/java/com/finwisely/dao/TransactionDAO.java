package com.finwisely.dao;

import com.finwisely.model.Transaction;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class TransactionDAO {

    // Save a transaction record into the database
    public void saveTransaction(Connection connection,
                                Transaction transaction)
                                throws SQLException {

        String sql = "INSERT INTO transactions " +
                "(account_id, transaction_type, amount, " +
                "transaction_date, performed_by) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setInt(1, transaction.getAccountId());
            statement.setString(2, transaction.getTransactionType());
            statement.setBigDecimal(3, transaction.getAmount());
            statement.setTimestamp(
                    4,
                    java.sql.Timestamp.valueOf(
                            transaction.getTransactionDate()
                    )
            );
            statement.setString(5, transaction.getPerformedBy());

            statement.executeUpdate();
        }
    }
}