package com.finwisely.service;

import com.finwisely.model.User;
import java.sql.SQLException;

public class AuthenticationLoginTest {

    public static void main(String[] args) throws SQLException {

        AuthenticationService auth = new AuthenticationService();

        // Test SQL injection prevention
        String maliciousUsername = "' OR '1'='1' --";

        User user = auth.login(maliciousUsername, "anything");

        if (user != null) {
            System.out.println("LOGIN SUCCESSFUL!");
            System.out.println("SQL INJECTION TEST FAILED!");
        } else {
            System.out.println("LOGIN FAILED!");
            System.out.println("SQL INJECTION ATTEMPT REJECTED!");
        }
    }
}