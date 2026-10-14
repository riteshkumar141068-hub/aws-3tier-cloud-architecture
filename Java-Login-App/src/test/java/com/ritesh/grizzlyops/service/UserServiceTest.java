package com.ritesh.grizzlyops.service;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;

@SpringBootTest
@TestPropertySource(locations = "classpath:application-test.properties")
public class UserServiceTest {

    @Autowired
    private UserService userService;

    @Test
    void testRegisterAndAuthenticateUser() {
        String testUser = "grizzly_user_" + System.currentTimeMillis();
        String testPass = "GrizzlyPass123!";

        // Register user
        boolean registered = userService.registerUser("Grizzly", "Tester", testUser + "@grizzlyops.io", testUser, testPass);
        assertTrue(registered, "User should register successfully");

        // Authenticate with correct credentials
        String authenticatedUser = userService.authenticate(testUser, testPass);
        assertEquals(testUser, authenticatedUser, "User should authenticate successfully");

        // Authenticate with incorrect credentials
        String failedAuth = userService.authenticate(testUser, "WrongPassword");
        assertNull(failedAuth, "Authentication should fail with wrong password");
    }

    @Test
    void testRegisterWithEmptyCredentialsShouldFail() {
        boolean result = userService.registerUser("Test", "User", "test@example.com", "", "");
        assertFalse(result, "Registration should fail when username or password is empty");
    }
}
