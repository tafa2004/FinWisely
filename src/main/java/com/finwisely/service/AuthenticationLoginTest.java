package com.finwisely.service;

import com.finwisely.model.User;
import java.sql.SQLException;

public class AuthenticationLoginTest {

    public static void main(String[] args) throws SQLException {

        AuthenticationService auth = new AuthenticationService();

        // Test with a username that does not exist
        User user = auth.login("unknown_user", "DemoPass@123");

        if (user != null) {
            System.out.println("LOGIN SUCCESSFUL!");
        } else {
            System.out.println("LOGIN FAILED!");
            System.out.println("User does not exist or credentials are invalid.");
        }
    }
}