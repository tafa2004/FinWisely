package com.finwisely.dao;

import com.finwisely.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public User getUserByUsername(
            Connection connection, String username)
            throws SQLException {

        String sql = "SELECT user_id, username, password_hash, " +
                     "role, status FROM app_users " +
                     "WHERE username = ?";

        try (PreparedStatement statement =
                     connection.prepareStatement(sql)) {

            statement.setString(1, username);

            try (ResultSet result = statement.executeQuery()) {

                if (result.next()) {
                    return new User(
                            result.getInt("user_id"),
                            result.getString("username"),
                            result.getString("password_hash"),
                            result.getString("role"),
                            result.getString("status")
                    );
                }
            }
        }

        return null;
    }
}