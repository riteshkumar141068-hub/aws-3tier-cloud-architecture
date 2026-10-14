package com.dpt.demo.service;

import java.lang.management.ManagementFactory;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.PostConstruct;
import javax.sql.DataSource;

import com.dpt.demo.model.UserInfo;
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

    private static final String ADMIN_USER = "ritesh@soft";
    private static final String ADMIN_PASS = "Ritesh@admin121";
    private final long appStartTime = System.currentTimeMillis();

    @PostConstruct
    public void initDatabaseAndAdmin() {
        try (Connection con = dataSource.getConnection();
             Statement st = con.createStatement()) {

            // Ensure role column exists in Employee
            try {
                st.execute("ALTER TABLE Employee ADD COLUMN role VARCHAR(50) DEFAULT 'ROLE_USER'");
                log.info("Added 'role' column to Employee table.");
            } catch (SQLException ignored) {
                // Column already exists
            }

            // Ensure login_audit table exists
            st.execute("CREATE TABLE IF NOT EXISTS login_audit (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(100) NOT NULL, " +
                    "status VARCHAR(20) NOT NULL, " +
                    "ip_address VARCHAR(100), " +
                    "device VARCHAR(100), " +
                    "browser VARCHAR(100), " +
                    "login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "duration_minutes INT DEFAULT 1)");

            // Check and seed/update Admin user ritesh@soft
            seedAdminUser(con);

        } catch (SQLException e) {
            log.warn("Database initialization notice: {}", e.getMessage());
        }
    }

    private void seedAdminUser(Connection con) {
        String checkSql = "SELECT id FROM Employee WHERE username = ?";
        try (PreparedStatement checkPs = con.prepareStatement(checkSql)) {
            checkPs.setString(1, ADMIN_USER);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next()) {
                    // Update password and ensure role is ROLE_ADMIN
                    String updateSql = "UPDATE Employee SET password = ?, role = 'ROLE_ADMIN' WHERE username = ?";
                    try (PreparedStatement updatePs = con.prepareStatement(updateSql)) {
                        updatePs.setString(1, passwordEncoder.encode(ADMIN_PASS));
                        updatePs.setString(2, ADMIN_USER);
                        updatePs.executeUpdate();
                        log.info("Admin user '{}' verified and updated with ROLE_ADMIN.", ADMIN_USER);
                    }
                } else {
                    // Insert new admin user
                    String insertSql = "INSERT INTO Employee (first_name, last_name, email, username, password, role, regdate) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                        insertPs.setString(1, "Ritesh");
                        insertPs.setString(2, "Kumar");
                        insertPs.setString(3, "ritesh.kumar141068@gmail.com");
                        insertPs.setString(4, ADMIN_USER);
                        insertPs.setString(5, passwordEncoder.encode(ADMIN_PASS));
                        insertPs.setString(6, "ROLE_ADMIN");
                        insertPs.setDate(7, Date.valueOf(LocalDate.now()));
                        insertPs.executeUpdate();
                        log.info("Admin user '{}' seeded successfully with ROLE_ADMIN.", ADMIN_USER);
                    }
                }
            }
        } catch (SQLException e) {
            log.error("Failed to seed admin user: {}", e.getMessage());
        }
    }

    public boolean registerUser(String firstName, String lastName, String email, String username, String plainPassword) {
        if (username == null || username.trim().isEmpty() || plainPassword == null || plainPassword.trim().isEmpty()) {
            return false;
        }

        String hashedPassword = passwordEncoder.encode(plainPassword);
        String sql = "INSERT INTO Employee (first_name, last_name, email, username, password, role, regdate) VALUES (?, ?, ?, ?, ?, 'ROLE_USER', ?)";

        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, firstName != null ? firstName.trim() : "");
            ps.setString(2, lastName != null ? lastName.trim() : "");
            ps.setString(3, email != null ? email.trim() : "");
            ps.setString(4, username.trim());
            ps.setString(5, hashedPassword);
            ps.setDate(6, Date.valueOf(LocalDate.now()));

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            log.error("Registration error for user '{}': {}", username, e.getMessage());
            return false;
        }
    }

    public String authenticate(String username, String plainPassword) {
        UserInfo user = authenticate(username, plainPassword, "127.0.0.1", "Test-Suite");
        return user != null ? user.getUsername() : null;
    }

    public UserInfo authenticate(String username, String plainPassword, String ipAddress, String userAgent) {
        if (username == null || username.trim().isEmpty() || plainPassword == null || plainPassword.isEmpty()) {
            recordAudit(username != null ? username : "anonymous", "FAILED", ipAddress, userAgent);
            return null;
        }

        String sql = "SELECT id, first_name, last_name, email, username, password, role FROM Employee WHERE username = ?";

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
                        passwordMatches = true;
                        upgradePasswordHash(dbUsername, plainPassword);
                    }

                    if (passwordMatches) {
                        recordAudit(dbUsername, "SUCCESS", ipAddress, userAgent);
                        return new UserInfo(
                                rs.getInt("id"),
                                rs.getString("first_name"),
                                rs.getString("last_name"),
                                rs.getString("email"),
                                rs.getString("username"),
                                rs.getString("role") != null ? rs.getString("role") : "ROLE_USER"
                        );
                    }
                }
            }
        } catch (SQLException e) {
            log.error("Authentication DB error: {}", e.getMessage());
        }

        recordAudit(username.trim(), "FAILED", ipAddress, userAgent);
        return null;
    }

    public void recordAudit(String username, String status, String ip, String userAgent) {
        String device = parseDevice(userAgent);
        String browser = parseBrowser(userAgent);
        String sql = "INSERT INTO login_audit (username, status, ip_address, device, browser, login_time, last_active, duration_minutes) " +
                "VALUES (?, ?, ?, ?, ?, NOW(), NOW(), 1)";

        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, status);
            ps.setString(3, ip != null ? ip : "127.0.0.1");
            ps.setString(4, device);
            ps.setString(5, browser);
            ps.executeUpdate();
        } catch (SQLException e) {
            log.warn("Could not insert login audit: {}", e.getMessage());
        }
    }

    public void updateHeartbeat(String username) {
        String sql = "UPDATE login_audit SET last_active = NOW(), " +
                "duration_minutes = GREATEST(1, TIMESTAMPDIFF(MINUTE, login_time, NOW())) " +
                "WHERE username = ? ORDER BY id DESC LIMIT 1";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.executeUpdate();
        } catch (SQLException ignored) {}
    }

    public List<Map<String, Object>> getRecentAuditLogs(int limit) {
        List<Map<String, Object>> logs = new ArrayList<>();
        String sql = "SELECT id, username, status, ip_address, device, browser, login_time, duration_minutes " +
                "FROM login_audit ORDER BY id DESC LIMIT ?";

        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("id", rs.getInt("id"));
                    row.put("username", rs.getString("username"));
                    row.put("status", rs.getString("status"));
                    row.put("ip", rs.getString("ip_address"));
                    row.put("device", rs.getString("device"));
                    row.put("browser", rs.getString("browser"));
                    row.put("time", rs.getTimestamp("login_time"));
                    row.put("duration", rs.getInt("duration_minutes"));
                    logs.add(row);
                }
            }
        } catch (SQLException e) {
            log.error("Error reading audit logs: {}", e.getMessage());
        }
        return logs;
    }

    public List<Map<String, Object>> getAllUsers() {
        List<Map<String, Object>> users = new ArrayList<>();
        String sql = "SELECT id, first_name, last_name, email, username, role, regdate FROM Employee ORDER BY id DESC";

        try (Connection con = dataSource.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> u = new HashMap<>();
                u.put("id", rs.getInt("id"));
                u.put("name", rs.getString("first_name") + " " + rs.getString("last_name"));
                u.put("email", rs.getString("email"));
                u.put("username", rs.getString("username"));
                u.put("role", rs.getString("role"));
                u.put("regdate", rs.getDate("regdate"));
                users.add(u);
            }
        } catch (SQLException e) {
            log.error("Error fetching users: {}", e.getMessage());
        }
        return users;
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM Employee WHERE id = ? AND username != ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setString(2, ADMIN_USER);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            log.error("Error deleting user {}: {}", id, e.getMessage());
            return false;
        }
    }

    public Map<String, Object> getSystemMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        Runtime rt = Runtime.getRuntime();

        long usedMem = (rt.totalMemory() - rt.freeMemory()) / (1024 * 1024);
        long maxMem = rt.maxMemory() / (1024 * 1024);
        long freeMem = rt.freeMemory() / (1024 * 1024);

        metrics.put("usedMemMB", usedMem);
        metrics.put("maxMemMB", maxMem);
        metrics.put("freeMemMB", freeMem);
        metrics.put("memPercent", maxMem > 0 ? (usedMem * 100 / maxMem) : 0);
        metrics.put("activeThreads", Thread.activeCount());

        long uptimeMillis = ManagementFactory.getRuntimeMXBean().getUptime();
        long hours = uptimeMillis / (1000 * 60 * 60);
        long minutes = (uptimeMillis / (1000 * 60)) % 60;
        metrics.put("uptime", hours + "h " + minutes + "m");

        try (Connection con = dataSource.getConnection();
             Statement st = con.createStatement()) {

            try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM Employee")) {
                if (rs.next()) metrics.put("totalUsers", rs.getInt(1));
            }
            try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM login_audit WHERE status = 'SUCCESS'")) {
                if (rs.next()) metrics.put("successfulLogins", rs.getInt(1));
            }
            try (ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM login_audit WHERE status = 'FAILED'")) {
                if (rs.next()) metrics.put("failedLogins", rs.getInt(1));
            }

        } catch (SQLException ignored) {}

        return metrics;
    }

    private void upgradePasswordHash(String username, String plainPassword) {
        String sql = "UPDATE Employee SET password = ? WHERE username = ?";
        try (Connection con = dataSource.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, passwordEncoder.encode(plainPassword));
            ps.setString(2, username);
            ps.executeUpdate();
        } catch (SQLException ignored) {}
    }

    private String parseDevice(String userAgent) {
        if (userAgent == null) return "Unknown";
        if (userAgent.contains("Windows")) return "Windows PC";
        if (userAgent.contains("Macintosh") || userAgent.contains("Mac OS")) return "macOS";
        if (userAgent.contains("iPhone")) return "iPhone";
        if (userAgent.contains("Android")) return "Android";
        if (userAgent.contains("Linux")) return "Linux";
        return "Web Device";
    }

    private String parseBrowser(String userAgent) {
        if (userAgent == null) return "Unknown";
        if (userAgent.contains("Edg/")) return "Microsoft Edge";
        if (userAgent.contains("Chrome/")) return "Google Chrome";
        if (userAgent.contains("Safari/") && !userAgent.contains("Chrome")) return "Safari";
        if (userAgent.contains("Firefox/")) return "Mozilla Firefox";
        return "Browser";
    }
}
