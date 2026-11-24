package com.finwisely.security;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SecurityUtilsTest {

    @Test
    void shouldHashPasswordSuccessfully() {
        String password = "FinWisely@123";

        String hashedPassword =
                SecurityUtils.hashPassword(password);

        assertNotNull(hashedPassword);
        assertNotEquals(password, hashedPassword);
    }

    @Test
    void shouldVerifyCorrectPassword() {
        String password = "FinWisely@123";
        String hashedPassword =
                SecurityUtils.hashPassword(password);

        assertTrue(SecurityUtils.verifyPassword(
                password, hashedPassword));
    }

    @Test
    void shouldRejectIncorrectPassword() {
        String hashedPassword =
                SecurityUtils.hashPassword("FinWisely@123");

        assertFalse(SecurityUtils.verifyPassword(
                "WrongPassword123", hashedPassword));
    }

    @Test
    void shouldGenerateDifferentHashesForSamePassword() {
        String password = "FinWisely@123";

        String firstHash =
                SecurityUtils.hashPassword(password);
        String secondHash =
                SecurityUtils.hashPassword(password);

        assertNotEquals(firstHash, secondHash);
    }

    @Test
    void shouldRejectEmptyPassword() {
        assertThrows(
                IllegalArgumentException.class,
                () -> SecurityUtils.hashPassword("")
        );
    }
}