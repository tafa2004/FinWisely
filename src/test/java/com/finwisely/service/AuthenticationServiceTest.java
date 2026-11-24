package com.finwisely.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertNull;

class AuthenticationServiceTest {

    private final AuthenticationService authenticationService =
            new AuthenticationService();

    @Test
    void shouldRejectEmptyUsername() throws Exception {
        assertNull(authenticationService.login("", "Password@123"));
    }

    @Test
    void shouldRejectEmptyPassword() throws Exception {
        assertNull(authenticationService.login("tatenda", ""));
    }

    @Test
    void shouldRejectNullCredentials() throws Exception {
        assertNull(authenticationService.login(null, null));
    }
}