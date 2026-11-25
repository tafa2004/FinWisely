package com.finwisely.service;

import com.finwisely.config.DatabaseConnection;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static org.junit.jupiter.api.Assertions.*;

class BankingServiceIntegrationTest {

    private static final int TEST_ACCOUNT_ID = 9001;

    private final BankingService bankingService = new BankingService();

    private BigDecimal getBalance() throws SQLException {
        String sql = "SELECT balance FROM accounts WHERE account_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, TEST_ACCOUNT_ID);

            try (ResultSet result = statement.executeQuery()) {
                assertTrue(result.next(), "Test account must exist");
                return result.getBigDecimal("balance");
            }
        }
    }

    private int getTransactionCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM transactions WHERE account_id = ?";

        try (Connection connection = DatabaseConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, TEST_ACCOUNT_ID);

            try (ResultSet result = statement.executeQuery()) {
                assertTrue(result.next());
                return result.getInt(1);
            }
        }
    }

    @Test
    void depositShouldIncreaseBalanceAndRecordTransaction() throws SQLException {
        BigDecimal before = getBalance();
        int transactionsBefore = getTransactionCount();

        try (Connection connection = DatabaseConnection.getConnection()) {
            bankingService.deposit(
                    connection,
                    TEST_ACCOUNT_ID,
                    new BigDecimal("100.00"),
                    "integration_teller"
            );

            assertTrue(connection.getAutoCommit());
        }

        assertEquals(
                before.add(new BigDecimal("100.00")),
                getBalance()
        );

        assertEquals(transactionsBefore + 1, getTransactionCount());
    }

    @Test
    void withdrawalShouldDecreaseBalanceAndRecordTransaction() throws SQLException {
        BigDecimal before = getBalance();
        int transactionsBefore = getTransactionCount();

        try (Connection connection = DatabaseConnection.getConnection()) {
            bankingService.withdraw(
                    connection,
                    TEST_ACCOUNT_ID,
                    new BigDecimal("40.00"),
                    "integration_teller"
            );

            assertTrue(connection.getAutoCommit());
        }

        assertEquals(
                before.subtract(new BigDecimal("40.00")),
                getBalance()
        );

        assertEquals(transactionsBefore + 1, getTransactionCount());
    }

    @Test
    void insufficientFundsShouldNotChangeBalance() throws SQLException {
        BigDecimal before = getBalance();
        int transactionsBefore = getTransactionCount();

        try (Connection connection = DatabaseConnection.getConnection()) {
            assertThrows(
                    IllegalArgumentException.class,
                    () -> bankingService.withdraw(
                            connection,
                            TEST_ACCOUNT_ID,
                            new BigDecimal("999999.00"),
                            "integration_teller"
                    )
            );

            assertTrue(connection.getAutoCommit());
        }

        assertEquals(before, getBalance());
        assertEquals(transactionsBefore, getTransactionCount());
    }

    @Test
    void blankUsernameShouldBeRejected() throws SQLException {
        BigDecimal before = getBalance();
        int transactionsBefore = getTransactionCount();

        try (Connection connection = DatabaseConnection.getConnection()) {
            assertThrows(
                    IllegalArgumentException.class,
                    () -> bankingService.deposit(
                            connection,
                            TEST_ACCOUNT_ID,
                            new BigDecimal("25.00"),
                            " "
                    )
            );
        }

        assertEquals(before, getBalance());
        assertEquals(transactionsBefore, getTransactionCount());
    }

    @Test
    void failedTransactionInsertShouldRollbackBalanceUpdate() throws SQLException {
        BigDecimal before = getBalance();
        int transactionsBefore = getTransactionCount();

        String usernameTooLong = "x".repeat(51);

        try (Connection connection = DatabaseConnection.getConnection()) {
            assertThrows(
                    SQLException.class,
                    () -> bankingService.deposit(
                            connection,
                            TEST_ACCOUNT_ID,
                            new BigDecimal("25.00"),
                            usernameTooLong
                    )
            );

            assertTrue(connection.getAutoCommit());
        }

        assertEquals(before, getBalance());
        assertEquals(transactionsBefore, getTransactionCount());
    }
}