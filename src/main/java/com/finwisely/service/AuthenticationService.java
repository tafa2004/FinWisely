package com.finwisely.service;

import com.finwisely.config.DatabaseConnection;
import com.finwisely.dao.UserDAO;
import com.finwisely.model.User;
import com.finwisely.security.SecurityUtils;

import java.sql.Connection;
import java.sql.SQLException;

public class AuthenticationService {

    private final UserDAO userDAO;

    public AuthenticationService() {
        this.userDAO = new UserDAO();
    }

    public User login(String username, String password)
            throws SQLException {

        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {
            return null;
        }

        try (Connection connection =
                     DatabaseConnection.getConnection()) {

            User user = userDAO.getUserByUsername(
                    connection, username.trim());

            if (user == null) {
                return null;
            }

            if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
                return null;
            }

            boolean passwordMatches =
                    SecurityUtils.verifyPassword(
                            password, user.getPasswordHash());

            if (!passwordMatches) {
                return null;
            }

            return user;
        }
    }
}