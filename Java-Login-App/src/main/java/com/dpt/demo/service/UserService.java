package com.dpt.demo.service;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private DataSource dataSource;

    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Registers a new employee user with a BCrypt hashed password.
     */
    public boolean registerUser(String firstName, String lastName, String email, String username, String plainPassword) {
        if (username == null || username.trim().isEmpty() || plainPassword == null || plainPassword.trim().isEmpty()) {
            log.warn("Registration rejected: Username or password was empty.");
            return false;
        }

        String hashedPassword = passwordEncoder.encode(plainPassword);
        String sql = "INSERT INTO Employee (first_name, last_name, email, username, password, regdate) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, firstName != null ? firstName.trim() : "");
            ps.setString(2, lastName != null ? lastName.trim() : "");
            ps.setString(3, email != null ? email.trim() : "");
            ps.setString(4, username.trim());
            ps.setString(5, hashedPassword);
            ps.setDate(6, Date.valueOf(LocalDate.now()));

            int rows = ps.executeUpdate();
            log.info("User registered successfully: {}", username.trim());
            return rows > 0;
        } catch (SQLException e) {
            log.error("Database error during registration for user '{}': {}", username, e.getMessage());
            return false;
        }
    }

    /**
     * Authenticates a user using secure parameterized query and BCrypt password comparison.
     * Returns the username if authentication succeeds, null otherwise.
     */
    public String authenticate(String username, String plainPassword) {
        if (username == null || username.trim().isEmpty() || plainPassword == null || plainPassword.isEmpty()) {
            return null;
        }

        String sql = "SELECT username, password FROM Employee WHERE username = ?";

        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPassword = rs.getString("password");
                    String dbUsername = rs.getString("username");

                    boolean passwordMatches = false;
                    if (storedPassword != null && storedPassword.startsWith("$2a$")) {
                        passwordMatches = passwordEncoder.matches(plainPassword, storedPassword);
                    } else if (storedPassword != null && storedPassword.equals(plainPassword)) {
                        // Support legacy plaintext password and seamlessly upgrade to BCrypt
                        passwordMatches = true;
                        upgradePasswordHash(dbUsername, plainPassword);
                    }

                    if (passwordMatches) {
                        log.info("User authenticated successfully: {}", dbUsername);
                        return dbUsername;
                    }
                }
            }
        } catch (SQLException e) {
            log.error("Database error during authentication for user '{}': {}", username, e.getMessage());
        }
        return null;
    }

    private void upgradePasswordHash(String username, String plainPassword) {
        String sql = "UPDATE Employee SET password = ? WHERE username = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, passwordEncoder.encode(plainPassword));
            ps.setString(2, username);
            ps.executeUpdate();
            log.info("Upgraded password to BCrypt hash for user: {}", username);
        } catch (SQLException e) {
            log.warn("Could not upgrade password hash for user '{}': {}", username, e.getMessage());
        }
    }
}
