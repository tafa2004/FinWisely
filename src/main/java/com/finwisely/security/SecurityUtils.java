package com.finwisely.security;

import org.mindrot.jbcrypt.BCrypt;

public final class SecurityUtils {

    // Prevent object creation
    private SecurityUtils() {
    }

    // Hash a plain-text password
    public static String hashPassword(String plainPassword) {

        if (plainPassword == null || plainPassword.isBlank()) {
            throw new IllegalArgumentException(
                    "Password cannot be empty."
            );
        }

        return BCrypt.hashpw(
                plainPassword,
                BCrypt.gensalt(12)
        );
    }

    // Verify a password against its stored hash
    public static boolean verifyPassword(
            String plainPassword,
            String hashedPassword) {

        if (plainPassword == null || hashedPassword == null) {
            return false;
        }

        try {
            return BCrypt.checkpw(
                    plainPassword,
                    hashedPassword
            );
        } catch (IllegalArgumentException exception) {
            return false;
        }
    }
}