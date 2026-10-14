<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrizzlyOps Admin Console // Ritesh Kumar</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="icon" type="image/png" href="/images/logo.png">
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500;600&family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-deep: #050811;
            --bg-card: rgba(13, 20, 36, 0.75);
            --border-glow: rgba(0, 240, 255, 0.25);
            --cyan-glow: #00f0ff;
            --violet-glow: #8a2be2;
            --emerald-glow: #00ff88;
            --rose-glow: #ff3366;
            --amber-glow: #ffb800;
            --text-main: #f0f4fc;
            --text-muted: #8b9bb4;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            cursor: none;
        }

        body {
            background-color: var(--bg-deep);
            color: var(--text-main);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        .ambient-orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(140px);
            opacity: 0.3;
            z-index: 0;
            pointer-events: none;
        }
        .orb-1 { width: 550px; height: 550px; background: radial-gradient(circle, var(--cyan-glow), transparent 70%); top: -100px; left: -100px; }
        .orb-2 { width: 600px; height: 600px; background: radial-gradient(circle, var(--rose-glow), transparent 70%); bottom: -150px; right: -100px; }

        #particle-canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 1;
            pointer-events: none;
        }

        .custom-cursor-dot {
            width: 8px;
            height: 8px;
            background: var(--cyan-glow);
            box-shadow: 0 0 12px var(--cyan-glow);
            border-radius: 50%;
            position: fixed;
            pointer-events: none;
            z-index: 9999;
            transform: translate(-50%, -50%);
        }
        .custom-cursor-ring {
            width: 36px;
            height: 36px;
            border: 1.5px solid rgba(0, 240, 255, 0.6);
            border-radius: 50%;
            position: fixed;
            pointer-events: none;
            z-index: 9998;
            transform: translate(-50%, -50%);
            transition: width 0.2s, height 0.2s, border-color 0.2s;
        }

        .admin-wrap {
            position: relative;
            z-index: 2;
            max-width: 1320px;
            margin: 0 auto;
            padding: 24px 20px 80px 20px;
        }

        /* Top Nav */
        header.cyber-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 28px;
            background: rgba(13, 20, 36, 0.65);
            backdrop-filter: blur(20px);
            border: 1px solid var(--border-glow);
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
            margin-bottom: 30px;
        }

        .brand-hub {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .brand-badge {
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, var(--rose-glow), var(--violet-glow));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: #fff;
            box-shadow: 0 0 20px rgba(255, 51, 102, 0.5);
        }

        .brand-info h1 {
            font-size: 1.15rem;
            font-weight: 800;
            color: #fff;
            letter-spacing: 0.5px;
        }

        .brand-info span {
            font-size: 0.76rem;
            color: var(--rose-glow);
            font-family: 'Fira Code', monospace;
        }

        .nav-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .admin-tag {
            font-family: 'Fira Code', monospace;
            font-size: 0.8rem;
            padding: 6px 14px;
            background: rgba(255, 51, 102, 0.15);
            border: 1px solid rgba(255, 51, 102, 0.35);
            border-radius: 20px;
            color: var(--rose-glow);
        }

        .btn-link {
            padding: 8px 18px;
            background: rgba(0, 240, 255, 0.1);
            border: 1px solid var(--cyan-glow);
            border-radius: 10px;
            color: #fff;
            font-size: 0.82rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.25s;
        }
        .btn-link:hover {
            background: var(--cyan-glow);
            color: #050811;
            box-shadow: 0 0 20px rgba(0, 240, 255, 0.5);
            transform: translateY(-2px);
        }

        .btn-logout {
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 10px;
            color: #ff6b6b;
            font-size: 0.82rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-logout:hover {
            background: rgba(255, 51, 102, 0.25);
            border-color: var(--rose-glow);
        }

        /* 3D Metric Stat Grid */
        .metric-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        @media (max-width: 1024px) {
            .metric-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 600px) {
            .metric-grid { grid-template-columns: 1fr; }
        }

        .stat-card {
            background: var(--bg-card);
            backdrop-filter: blur(24px);
            border: 1px solid var(--border-glow);
            border-radius: 20px;
            padding: 24px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.4);
            transform-style: preserve-3d;
            transition: transform 0.15s ease-out, border-color 0.25s, box-shadow 0.25s;
        }

        .stat-card:hover {
            border-color: rgba(0, 240, 255, 0.5);
            box-shadow: 0 20px 50px rgba(0, 240, 255, 0.15);
        }

        .stat-icon {
            font-size: 1.5rem;
            margin-bottom: 12px;
        }

        .stat-title {
            font-size: 0.78rem;
            color: var(--text-muted);
            font-family: 'Fira Code', monospace;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .stat-number {
            font-size: 2rem;
            font-weight: 800;
            color: #fff;
            letter-spacing: -0.5px;
        }

        .stat-sub {
            font-size: 0.78rem;
            color: var(--emerald-glow);
            margin-top: 6px;
            font-family: 'Fira Code', monospace;
        }
        .sub-danger { color: var(--rose-glow); }
        .sub-cyan { color: var(--cyan-glow); }

        /* Section Container */
        .admin-section {
            background: var(--bg-card);
            backdrop-filter: blur(24px);
            border: 1px solid var(--border-glow);
            border-radius: 24px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.45);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 14px;
        }

        .section-title h2 {
            font-size: 1.3rem;
            font-weight: 700;
            color: #fff;
        }

        .section-title p {
            font-size: 0.82rem;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .section-controls {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .search-box {
            padding: 8px 16px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 10px;
            color: #fff;
            font-size: 0.82rem;
            font-family: 'Inter', sans-serif;
            outline: none;
            width: 200px;
            transition: all 0.2s;
        }
        .search-box:focus {
            border-color: var(--cyan-glow);
            box-shadow: 0 0 12px rgba(0, 240, 255, 0.3);
            width: 240px;
        }

        .btn-action {
            padding: 8px 16px;
            border-radius: 10px;
            font-size: 0.82rem;
            font-weight: 600;
            background: rgba(0, 255, 136, 0.1);
            border: 1px solid rgba(0, 255, 136, 0.3);
            color: var(--emerald-glow);
            cursor: none;
            transition: all 0.2s;
        }
        .btn-action:hover {
            background: var(--emerald-glow);
            color: #050811;
            box-shadow: 0 0 15px rgba(0, 255, 136, 0.5);
        }

        /* Cyber Table */
        .table-responsive {
            overflow-x: auto;
        }

        table.cyber-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px;
        }

        table.cyber-table th {
            text-align: left;
            padding: 12px 18px;
            font-size: 0.74rem;
            color: var(--text-muted);
            font-family: 'Fira Code', monospace;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }

        table.cyber-table td {
            padding: 14px 18px;
            background: rgba(255, 255, 255, 0.02);
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 0.86rem;
            color: #d1d5db;
        }

        table.cyber-table tr td:first-child {
            border-left: 1px solid rgba(255, 255, 255, 0.05);
            border-top-left-radius: 12px;
            border-bottom-left-radius: 12px;
        }

        table.cyber-table tr td:last-child {
            border-right: 1px solid rgba(255, 255, 255, 0.05);
            border-top-right-radius: 12px;
            border-bottom-right-radius: 12px;
        }

        table.cyber-table tr:hover td {
            background: rgba(0, 240, 255, 0.05);
            border-color: rgba(0, 240, 255, 0.25);
            color: #fff;
        }

        .badge-status {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 8px;
            font-family: 'Fira Code', monospace;
            font-size: 0.74rem;
            font-weight: 600;
        }
        .badge-success {
            background: rgba(0, 255, 136, 0.15);
            border: 1px solid rgba(0, 255, 136, 0.35);
            color: var(--emerald-glow);
        }
        .badge-failed {
            background: rgba(255, 51, 102, 0.15);
            border: 1px solid rgba(255, 51, 102, 0.35);
            color: var(--rose-glow);
            animation: pulse-danger 1.5s infinite;
        }

        @keyframes pulse-danger {
            0% { opacity: 0.8; } 50% { opacity: 1; box-shadow: 0 0 10px rgba(255, 51, 102, 0.4); } 100% { opacity: 0.8; }
        }

        .badge-admin {
            background: rgba(138, 43, 226, 0.15);
            border: 1px solid rgba(138, 43, 226, 0.35);
            color: #c084fc;
        }
        .badge-user {
            background: rgba(0, 240, 255, 0.1);
            border: 1px solid rgba(0, 240, 255, 0.25);
            color: var(--cyan-glow);
        }

        .btn-delete {
            background: rgba(255, 51, 102, 0.1);
            border: 1px solid rgba(255, 51, 102, 0.3);
            color: #ff6b6b;
            padding: 5px 12px;
            border-radius: 8px;
            font-size: 0.76rem;
            font-weight: 600;
            cursor: none;
            transition: all 0.2s;
        }
        .btn-delete:hover {
            background: var(--rose-glow);
            color: #fff;
            box-shadow: 0 0 12px rgba(255, 51, 102, 0.5);
        }

        .btn-disabled {
            opacity: 0.4;
            cursor: not-allowed;
            pointer-events: none;
        }

        /* Footer */
        footer.cyber-footer {
            text-align: center;
            margin-top: 40px;
            color: var(--text-muted);
            font-size: 0.82rem;
            font-family: 'Fira Code', monospace;
        }
        footer.cyber-footer span { color: var(--rose-glow); }
    </style>
</head>
<body>

    <div class="ambient-orb orb-1"></div>
    <div class="ambient-orb orb-2"></div>
    <canvas id="particle-canvas"></canvas>

    <div class="custom-cursor-dot" id="cursor-dot"></div>
    <div class="custom-cursor-ring" id="cursor-ring"></div>

    <div class="admin-wrap">

        <!-- Top Navigation -->
        <header class="cyber-nav">
            <div class="brand-hub">
                <div class="brand-badge" style="padding: 4px; display: flex; align-items: center; justify-content: center;">
                    <img src="/images/logo.png" alt="Logo" style="width: 26px; height: 26px; object-fit: contain;">
                </div>
                <div class="brand-info">
                    <h1>GRIZZLYOPS // SYSTEM ADMIN CONSOLE</h1>
                    <span>USER AUDIT TRAIL & SYSTEM TELEMETRY</span>
                </div>
            </div>

            <div class="nav-actions">
                <span class="admin-tag">Admin: ${username}</span>
                <a href="/user" class="btn-link">View User Portal ➔</a>
                <a href="/logout" class="btn-logout">Sign Out ⏻</a>
            </div>
        </header>

        <!-- 3D Stat Grid -->
        <div class="metric-grid">
            <div class="stat-card" data-tilt>
                <div class="stat-icon">👥</div>
                <div class="stat-title">// Registered Users</div>
                <div class="stat-number">${metrics.totalUsers != null ? metrics.totalUsers : 0}</div>
                <div class="stat-sub sub-cyan">Database: MySQL 8.0</div>
            </div>

            <div class="stat-card" data-tilt>
                <div class="stat-icon">🟢</div>
                <div class="stat-title">// Successful Logins</div>
                <div class="stat-number">${metrics.successfulLogins != null ? metrics.successfulLogins : 0}</div>
                <div class="stat-sub">Authenticated & Salted</div>
            </div>

            <div class="stat-card" data-tilt>
                <div class="stat-icon">🛡️</div>
                <div class="stat-title">// Security Rejections</div>
                <div class="stat-number">${metrics.failedLogins != null ? metrics.failedLogins : 0}</div>
                <div class="stat-sub sub-danger">Failed Attempts Logged</div>
            </div>

            <div class="stat-card" data-tilt>
                <div class="stat-icon">⚡</div>
                <div class="stat-title">// JVM RAM & Uptime</div>
                <div class="stat-number">${metrics.usedMemMB}M</div>
                <div class="stat-sub sub-cyan">Uptime: ${metrics.uptime} | RAM: ${metrics.memPercent}%</div>
            </div>
        </div>

        <!-- Section 1: User Audit Trail & Login History -->
        <div class="admin-section">
            <div class="section-header">
                <div class="section-title">
                    <h2>📋 User Audit Trail & Login History</h2>
                    <p>Live session monitoring tracking who visited, timestamp, IP, device, and active duration</p>
                </div>
                <div class="section-controls">
                    <input type="text" id="logSearch" class="search-box" placeholder="Search user or IP...">
                    <button onclick="exportAuditCSV()" class="btn-action">📥 Export CSV</button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="cyber-table" id="auditTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Status</th>
                            <th>Device</th>
                            <th>Browser</th>
                            <th>IP Address</th>
                            <th>Login Time</th>
                            <th>Session Duration</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="log" items="${auditLogs}">
                            <tr>
                                <td>#${log.id}</td>
                                <td><strong style="color: #fff;">${log.username}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${log.status == 'SUCCESS'}">
                                            <span class="badge-status badge-success">✓ SUCCESS</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status badge-failed">⚠ FAILED</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${log.device}</td>
                                <td>${log.browser}</td>
                                <td><code style="color: var(--cyan-glow);">${log.ip}</code></td>
                                <td>${log.time}</td>
                                <td><span style="color: var(--emerald-glow); font-family: 'Fira Code', monospace;">~${log.duration} min(s) active</span></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty auditLogs}">
                            <tr>
                                <td colspan="8" style="text-align: center; color: var(--text-muted); padding: 30px;">
                                    No audit logs recorded yet. Log in from the user portal to generate telemetry.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Section 2: Registered Accounts Management -->
        <div class="admin-section">
            <div class="section-header">
                <div class="section-title">
                    <h2>👥 Registered User Directory</h2>
                    <p>Manage employee database accounts, verify roles, and clean test data</p>
                </div>
            </div>

            <div class="table-responsive">
                <table class="cyber-table">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Full Name</th>
                            <th>Email Address</th>
                            <th>Username</th>
                            <th>Assigned Role</th>
                            <th>Registration Date</th>
                            <th>Manage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${usersList}">
                            <tr>
                                <td>#${user.id}</td>
                                <td><strong style="color: #fff;">${user.name}</strong></td>
                                <td>${user.email}</td>
                                <td><code style="color: var(--cyan-glow);">${user.username}</code></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.role == 'ROLE_ADMIN'}">
                                            <span class="badge-status badge-admin">⚡ ROLE_ADMIN</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-status badge-user">ROLE_USER</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${user.regdate}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.username == 'ritesh@soft'}">
                                            <span style="font-size: 0.74rem; color: #64748b; font-family: 'Fira Code', monospace;">[SYSTEM ROOT]</span>
                                        </c:when>
                                        <c:otherwise>
                                            <form method="post" action="/admin/delete-user" style="display:inline;" onsubmit="return confirm('Delete user ${user.username}?');">
                                                <input type="hidden" name="id" value="${user.id}">
                                                <button type="submit" class="btn-delete">Delete 🗑️</button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <footer class="cyber-footer">
            <p>GrizzlyOps Admin Operations Console // Architected by <span>Ritesh Kumar</span> | Enterprise AWS Cloud Infrastructure</p>
        </footer>

    </div>

    <script>
        // Custom 3D Cursor
        const cursorDot = document.getElementById('cursor-dot');
        const cursorRing = document.getElementById('cursor-ring');
        let mouseX = window.innerWidth / 2, mouseY = window.innerHeight / 2;
        let ringX = mouseX, ringY = mouseY;

        window.addEventListener('mousemove', (e) => {
            mouseX = e.clientX; mouseY = e.clientY;
            cursorDot.style.left = mouseX + 'px';
            cursorDot.style.top = mouseY + 'px';
        });

        function animateCursorRing() {
            ringX += (mouseX - ringX) * 0.18;
            ringY += (mouseY - ringY) * 0.18;
            cursorRing.style.left = ringX + 'px';
            cursorRing.style.top = ringY + 'px';
            requestAnimationFrame(animateCursorRing);
        }
        animateCursorRing();

        // 3D Tilt for Stat Cards
        const tiltCards = document.querySelectorAll('[data-tilt]');
        tiltCards.forEach(card => {
            card.addEventListener('mousemove', (e) => {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left, y = e.clientY - rect.top;
                const centerX = rect.width / 2, centerY = rect.height / 2;
                const rotateX = ((y - centerY) / centerY) * -8;
                const rotateY = ((x - centerX) / centerX) * 8;
                card.style.transform = 'perspective(1000px) rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg) scale3d(1.02, 1.02, 1.02)';
            });
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)';
            });
        });

        // Filter Audit Table
        document.getElementById('logSearch').addEventListener('keyup', function() {
            const filter = this.value.toLowerCase();
            const rows = document.querySelectorAll('#auditTable tbody tr');
            rows.forEach(row => {
                const text = row.innerText.toLowerCase();
                row.style.display = text.includes(filter) ? '' : 'none';
            });
        });

        // Export Table to CSV
        function exportAuditCSV() {
            const rows = document.querySelectorAll('#auditTable tr');
            let csv = [];
            for (let i = 0; i < rows.length; i++) {
                let row = [], cols = rows[i].querySelectorAll('td, th');
                for (let j = 0; j < cols.length; j++) {
                    let data = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, '').replace(/(\s\s+)/gm, ' ');
                    data = data.replace(/"/g, '""');
                    row.push('"' + data + '"');
                }
                csv.push(row.join(','));
            }
            const csvFile = new Blob([csv.join('\n')], {type: 'text/csv'});
            const downloadLink = document.createElement('a');
            downloadLink.download = 'audit_logs_' + new Date().toISOString().slice(0, 10) + '.csv';
            downloadLink.href = window.URL.createObjectURL(csvFile);
            downloadLink.style.display = 'none';
            document.body.appendChild(downloadLink);
            downloadLink.click();
            document.body.removeChild(downloadLink);
        }

        // Particle Canvas
        const canvas = document.getElementById('particle-canvas');
        const ctx = canvas.getContext('2d');
        function resize() { canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
        resize();
        window.addEventListener('resize', resize);

        const particles = [];
        for (let i = 0; i < 45; i++) {
            particles.push({
                x: Math.random() * canvas.width,
                y: Math.random() * canvas.height,
                vx: (Math.random() - 0.5) * 0.6,
                vy: (Math.random() - 0.5) * 0.6,
                radius: Math.random() * 2 + 1
            });
        }

        function drawParticles() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            for (let i = 0; i < particles.length; i++) {
                for (let j = i + 1; j < particles.length; j++) {
                    const dx = particles[i].x - particles[j].x, dy = particles[i].y - particles[j].y;
                    const dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist < 120) {
                        ctx.beginPath();
                        ctx.strokeStyle = 'rgba(0, 240, 255, ' + (0.12 * (1 - dist / 120)) + ')';
                        ctx.lineWidth = 0.8;
                        ctx.moveTo(particles[i].x, particles[i].y);
                        ctx.lineTo(particles[j].x, particles[j].y);
                        ctx.stroke();
                    }
                }
            }
            particles.forEach(p => {
                ctx.beginPath();
                ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(0, 240, 255, 0.4)';
                ctx.fill();
                p.x += p.vx; p.y += p.vy;
                if (p.x < 0 || p.x > canvas.width) p.vx *= -1;
                if (p.y < 0 || p.y > canvas.height) p.vy *= -1;
            });
            requestAnimationFrame(drawParticles);
        }
        drawParticles();
    </script>
</body>
</html>
