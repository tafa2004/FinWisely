package com.finwisely;

import com.finwisely.config.DatabaseConnection;
import com.finwisely.model.User;
import com.finwisely.service.AuthenticationService;
import com.finwisely.service.BankingService;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Main {

    private static final Scanner scanner = new Scanner(System.in);

    private static final AuthenticationService authenticationService =
            new AuthenticationService();

    private static final BankingService bankingService =
            new BankingService();

    public static void main(String[] args) {

        System.out.println("====================================");
        System.out.println("          FINWISELY BANKING");
        System.out.println("   Secure Transaction Management");
        System.out.println("====================================");

        try {
            // Verify database connectivity
            try (Connection connection = DatabaseConnection.getConnection()) {
                System.out.println("Database connection successful.");
            }

            // Authenticate application user
            System.out.println("\nPlease log in.");
            System.out.print("Username: ");
            String username = scanner.nextLine().trim();

            System.out.print("Password: ");
            String password = scanner.nextLine();

            User user = authenticationService.login(username, password);

            if (user == null) {
                System.out.println("Login failed. Invalid credentials or inactive account.");
                return;
            }

            System.out.println("\nWelcome, " + user.getUsername() + ".");
            System.out.println("Role: " + user.getRole());

            // This prototype exposes banking operations to tellers only.
            if (!"TELLER".equalsIgnoreCase(user.getRole())) {
                System.out.println("This demonstration currently supports teller operations only.");
                return;
            }

            showMenu(user.getUsername());

        } catch (SQLException e) {
            System.out.println("A database error occurred: " + e.getMessage());
        } finally {
            scanner.close();
        }
    }

    private static void showMenu(String performedBy) {

        boolean running = true;

        while (running) {
            System.out.println("\n========== MAIN MENU ==========");
            System.out.println("1. View account balance");
            System.out.println("2. Deposit");
            System.out.println("3. Withdraw");
            System.out.println("4. Exit");
            System.out.print("Choose an option: ");

            String choice = scanner.nextLine().trim();

            switch (choice) {
                case "1":
                    viewBalance();
                    break;

                case "2":
                    processDeposit(performedBy);
                    break;

                case "3":
                    processWithdrawal(performedBy);
                    break;

                case "4":
                    running = false;
                    System.out.println("Thank you for using FinWisely.");
                    break;

                default:
                    System.out.println("Invalid option. Please choose 1 to 4.");
            }
        }
    }

    private static void viewBalance() {

        try {
            int accountId = readAccountId();

            String sql = "SELECT balance, status FROM accounts WHERE account_id = ?";

            try (Connection connection = DatabaseConnection.getConnection();
                 PreparedStatement statement = connection.prepareStatement(sql)) {

                statement.setInt(1, accountId);

                try (ResultSet result = statement.executeQuery()) {

                    if (result.next()) {
                        System.out.println("\nAccount ID: " + accountId);
                        System.out.println("Balance: K" + result.getBigDecimal("balance"));
                        System.out.println("Status: " + result.getString("status"));
                    } else {
                        System.out.println("Account not found.");
                    }
                }
            }

        } catch (NumberFormatException e) {
            System.out.println("Please enter a valid account number.");
        } catch (SQLException e) {
            System.out.println("Could not retrieve account balance: " + e.getMessage());
        }
    }

    private static void processDeposit(String performedBy) {

        try {
            int accountId = readAccountId();
            BigDecimal amount = readAmount();

            try (Connection connection = DatabaseConnection.getConnection()) {
                bankingService.deposit(connection, accountId, amount, performedBy);
            }

            System.out.println("Deposit completed successfully.");

        } catch (NumberFormatException e) {
            System.out.println("Please enter valid numeric values.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            System.out.println("Transaction rejected: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Deposit failed: " + e.getMessage());
        }
    }

    private static void processWithdrawal(String performedBy) {

        try {
            int accountId = readAccountId();
            BigDecimal amount = readAmount();

            try (Connection connection = DatabaseConnection.getConnection()) {
                bankingService.withdraw(connection, accountId, amount, performedBy);
            }

            System.out.println("Withdrawal completed successfully.");

        } catch (NumberFormatException e) {
            System.out.println("Please enter valid numeric values.");
        } catch (IllegalArgumentException | IllegalStateException e) {
            System.out.println("Transaction rejected: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("Withdrawal failed: " + e.getMessage());
        }
    }

    private static int readAccountId() {
        System.out.print("Enter account ID: ");
        return Integer.parseInt(scanner.nextLine().trim());
    }

    private static BigDecimal readAmount() {
        System.out.print("Enter amount: K");
        return new BigDecimal(scanner.nextLine().trim());
    }
}