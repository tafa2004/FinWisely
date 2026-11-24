package com.finwisely.service;

import com.finwisely.dao.AccountDAO;
import com.finwisely.dao.TransactionDAO;
import com.finwisely.model.Account;
import com.finwisely.model.Transaction;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class BankingService {

    private final AccountDAO accountDAO = new AccountDAO();
    private final TransactionDAO transactionDAO = new TransactionDAO();

    // Deposit money into an account
    public void deposit(Connection connection,
                        int accountId,
                        BigDecimal amount,
                        String performedBy) throws SQLException {

        validateDeposit(amount);

        processTransaction(
                connection, accountId, amount, performedBy, "DEPOSIT"
        );
    }

    // Withdraw money from an account
    public void withdraw(Connection connection,
                         int accountId,
                         BigDecimal amount,
                         String performedBy) throws SQLException {

        validateDeposit(amount);

        processTransaction(
                connection, accountId, amount, performedBy, "WITHDRAWAL"
        );
    }

    // Validate the transaction amount
    private void validateDeposit(BigDecimal amount) {

        if (amount == null ||
            amount.compareTo(BigDecimal.ZERO) <= 0) {

            throw new IllegalArgumentException(
                    "Amount must be greater than zero."
            );
        }
    }

    // Process the transaction safely
    private void processTransaction(Connection connection,
                                    int accountId,
                                    BigDecimal amount,
                                    String performedBy,
                                    String transactionType)
                                    throws SQLException {

        boolean originalAutoCommit = connection.getAutoCommit();

        try {
            connection.setAutoCommit(false);

            Account account =
                    accountDAO.getAccountById(connection, accountId);

            if (account == null) {
                throw new IllegalArgumentException(
                        "Account not found."
                );
            }

            if (!"ACTIVE".equalsIgnoreCase(account.getStatus())) {
                throw new IllegalStateException(
                        "Account is not active."
                );
            }

            BigDecimal newBalance;

            if ("DEPOSIT".equals(transactionType)) {
                newBalance = account.getBalance().add(amount);
            } else {
                if (amount.compareTo(account.getBalance()) > 0) {
                    throw new IllegalArgumentException(
                            "Insufficient funds."
                    );
                }

                newBalance = account.getBalance().subtract(amount);
            }

            // Update the account balance
            accountDAO.updateBalance(
                    connection, accountId, newBalance
            );

            // Create the transaction record
            Transaction transaction = new Transaction(
                    0,
                    accountId,
                    transactionType,
                    amount,
                    LocalDateTime.now(),
                    performedBy
            );

            // Save the transaction record
            transactionDAO.saveTransaction(
                    connection, transaction
            );

            // Save both database changes together
            connection.commit();

        } catch (SQLException | RuntimeException e) {

            connection.rollback();
            throw e;

        } finally {
            connection.setAutoCommit(originalAutoCommit);
        }
    }
}