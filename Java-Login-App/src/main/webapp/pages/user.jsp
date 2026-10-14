<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevOps Cloud Portal // Ritesh Kumar</title>
    <!-- Modern Tech Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="icon" type="image/png" href="/images/logo.png">
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500;600&family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-deep: #060913;
            --bg-card: rgba(13, 20, 36, 0.7);
            --border-glow: rgba(0, 240, 255, 0.25);
            --cyan-glow: #00f0ff;
            --violet-glow: #8a2be2;
            --emerald-glow: #00ff88;
            --text-main: #f0f4fc;
            --text-muted: #8b9bb4;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            cursor: none; /* Handled by custom 3D cursor */
        }

        body {
            background-color: var(--bg-deep);
            color: var(--text-main);
            font-family: 'Inter', -apple-system, sans-serif;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }

        /* Ambient 3D Glow Orbs in Background */
        .ambient-orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(120px);
            opacity: 0.35;
            z-index: 0;
            pointer-events: none;
            animation: orbFloat 18s ease-in-out infinite alternate;
        }
        .orb-1 { width: 500px; height: 500px; background: radial-gradient(circle, var(--cyan-glow), transparent 70%); top: -100px; left: -100px; }
        .orb-2 { width: 600px; height: 600px; background: radial-gradient(circle, var(--violet-glow), transparent 70%); bottom: -150px; right: -100px; animation-delay: -6s; }

        @keyframes orbFloat {
            0% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(60px, 80px) scale(1.15); }
            100% { transform: translate(-40px, 40px) scale(0.95); }
        }

        /* Interactive Particle Canvas */
        #particle-canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 1;
            pointer-events: none;
        }

        /* Custom Futuristic 3D Cursor */
        .custom-cursor-dot {
            width: 8px;
            height: 8px;
            background: var(--cyan-glow);
            box-shadow: 0 0 12px var(--cyan-glow), 0 0 24px var(--cyan-glow);
            border-radius: 50%;
            position: fixed;
            pointer-events: none;
            z-index: 9999;
            transform: translate(-50%, -50%);
            transition: width 0.15s, height 0.15s;
        }

        .custom-cursor-ring {
            width: 36px;
            height: 36px;
            border: 1.5px solid rgba(0, 240, 255, 0.6);
            box-shadow: 0 0 15px rgba(0, 240, 255, 0.2);
            border-radius: 50%;
            position: fixed;
            pointer-events: none;
            z-index: 9998;
            transform: translate(-50%, -50%);
            transition: transform 0.1s ease-out, width 0.2s, height 0.2s, border-color 0.2s;
        }

        /* App Container */
        .app-container {
            position: relative;
            z-index: 2;
            max-width: 1240px;
            margin: 0 auto;
            padding: 24px 20px 80px 20px;
        }

        /* Futuristic Header / Nav */
        header.cyber-nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 28px;
            background: rgba(13, 20, 36, 0.6);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--border-glow);
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4);
            margin-bottom: 36px;
        }

        .brand-hub {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .brand-badge {
            width: 42px;
            height: 42px;
            background: linear-gradient(135deg, var(--cyan-glow), var(--violet-glow));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            color: #fff;
            font-size: 1.15rem;
            box-shadow: 0 0 15px rgba(0, 240, 255, 0.5);
        }

        .brand-info h1 {
            font-size: 1.1rem;
            font-weight: 700;
            letter-spacing: 0.5px;
            color: #fff;
        }

        .brand-info span {
            font-size: 0.75rem;
            color: var(--cyan-glow);
            font-family: 'Fira Code', monospace;
        }

        .user-telemetry {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .live-status {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.8rem;
            font-family: 'Fira Code', monospace;
            padding: 6px 14px;
            background: rgba(0, 255, 136, 0.1);
            border: 1px solid rgba(0, 255, 136, 0.3);
            border-radius: 20px;
            color: var(--emerald-glow);
        }

        .pulse-dot {
            width: 8px;
            height: 8px;
            background: var(--emerald-glow);
            border-radius: 50%;
            box-shadow: 0 0 8px var(--emerald-glow);
            animation: pulse 1.6s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(0.9); opacity: 0.7; }
            50% { transform: scale(1.3); opacity: 1; }
            100% { transform: scale(0.9); opacity: 0.7; }
        }

        .logout-btn {
            padding: 8px 18px;
            background: rgba(255, 59, 48, 0.15);
            border: 1px solid rgba(255, 59, 48, 0.3);
            border-radius: 10px;
            color: #ff6b6b;
            font-size: 0.82rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.25s ease;
        }

        .logout-btn:hover {
            background: rgba(255, 59, 48, 0.3);
            border-color: #ff4d4d;
            box-shadow: 0 0 15px rgba(255, 77, 77, 0.4);
            transform: translateY(-2px);
        }

        /* 3D Tilt Grid Container */
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1.15fr 0.85fr;
            gap: 28px;
            margin-bottom: 32px;
        }

        @media (max-width: 900px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        /* 3D Tilt Card Base */
        .card-3d {
            background: var(--bg-card);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid var(--border-glow);
            border-radius: 24px;
            padding: 32px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.5), inset 0 0 20px rgba(0, 240, 255, 0.03);
            transform-style: preserve-3d;
            transition: transform 0.15s ease-out, box-shadow 0.25s, border-color 0.25s;
            position: relative;
        }

        .card-3d:hover {
            border-color: rgba(0, 240, 255, 0.55);
            box-shadow: 0 25px 60px rgba(0, 240, 255, 0.15), inset 0 0 25px rgba(0, 240, 255, 0.06);
        }

        .card-tag {
            display: inline-block;
            font-family: 'Fira Code', monospace;
            font-size: 0.72rem;
            color: var(--cyan-glow);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            background: rgba(0, 240, 255, 0.08);
            border: 1px solid rgba(0, 240, 255, 0.2);
            padding: 4px 12px;
            border-radius: 8px;
            margin-bottom: 16px;
        }

        /* Profile Section */
        .profile-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 24px;
        }

        .avatar-frame {
            width: 72px;
            height: 72px;
            border-radius: 20px;
            background: linear-gradient(135deg, #00f0ff, #8a2be2, #00ff88);
            padding: 2.5px;
            box-shadow: 0 0 25px rgba(0, 240, 255, 0.4);
        }

        .avatar-inner {
            width: 100%;
            height: 100%;
            background: #080d1a;
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.7rem;
            font-weight: 800;
            color: var(--cyan-glow);
        }

        .profile-name {
            font-size: 1.75rem;
            font-weight: 800;
            color: #fff;
            letter-spacing: -0.5px;
        }

        .profile-title {
            font-size: 0.95rem;
            color: var(--cyan-glow);
            font-weight: 500;
            margin-top: 4px;
        }

        .profile-bio {
            color: var(--text-muted);
            font-size: 0.92rem;
            line-height: 1.65;
            margin-bottom: 24px;
        }

        /* Tech Pills */
        .tech-stack-wrap {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 28px;
        }

        .tech-pill {
            display: flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            font-size: 0.8rem;
            color: #d8e2f0;
            font-family: 'Fira Code', monospace;
            transition: all 0.2s ease;
        }

        .tech-pill:hover {
            background: rgba(0, 240, 255, 0.12);
            border-color: var(--cyan-glow);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 240, 255, 0.2);
        }

        /* Action Buttons Grid */
        .action-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .cyber-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 13px 20px;
            border-radius: 14px;
            font-weight: 600;
            font-size: 0.88rem;
            text-decoration: none;
            transition: all 0.25s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }

        .btn-cyan {
            background: linear-gradient(135deg, rgba(0, 240, 255, 0.2), rgba(0, 240, 255, 0.05));
            border: 1px solid var(--cyan-glow);
            color: #fff;
            box-shadow: 0 0 15px rgba(0, 240, 255, 0.15);
        }

        .btn-cyan:hover {
            background: var(--cyan-glow);
            color: #050811;
            box-shadow: 0 0 25px rgba(0, 240, 255, 0.6);
            transform: translateY(-3px);
        }

        .btn-violet {
            background: linear-gradient(135deg, rgba(138, 43, 226, 0.2), rgba(138, 43, 226, 0.05));
            border: 1px solid var(--violet-glow);
            color: #fff;
            box-shadow: 0 0 15px rgba(138, 43, 226, 0.15);
        }

        .btn-violet:hover {
            background: var(--violet-glow);
            color: #fff;
            box-shadow: 0 0 25px rgba(138, 43, 226, 0.6);
            transform: translateY(-3px);
        }

        /* System Telemetry List */
        .telemetry-list {
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .telemetry-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 18px;
            background: rgba(255, 255, 255, 0.025);
            border: 1px solid rgba(255, 255, 255, 0.07);
            border-radius: 14px;
            font-size: 0.85rem;
            transition: all 0.2s;
        }

        .telemetry-item:hover {
            background: rgba(0, 240, 255, 0.04);
            border-color: rgba(0, 240, 255, 0.25);
            transform: translateX(4px);
        }

        .item-label {
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .item-val {
            font-family: 'Fira Code', monospace;
            font-size: 0.8rem;
            color: #fff;
            padding: 3px 10px;
            background: rgba(0, 0, 0, 0.4);
            border-radius: 6px;
        }

        .val-glow {
            color: var(--cyan-glow);
            border: 1px solid rgba(0, 240, 255, 0.3);
        }

        .val-emerald {
            color: var(--emerald-glow);
            border: 1px solid rgba(0, 255, 136, 0.3);
        }

        /* Architecture Banner Card */
        .arch-banner {
            background: var(--bg-card);
            backdrop-filter: blur(24px);
            border: 1px solid var(--border-glow);
            border-radius: 24px;
            padding: 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 15px 40px rgba(0,0,0,0.4);
            position: relative;
            overflow: hidden;
        }

        .arch-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, var(--cyan-glow), var(--violet-glow));
        }

        .arch-content h3 {
            font-size: 1.25rem;
            margin-bottom: 8px;
            color: #fff;
        }

        .arch-content p {
            color: var(--text-muted);
            font-size: 0.9rem;
            max-width: 700px;
            line-height: 1.6;
        }

        /* Footer */
        footer.cyber-footer {
            text-align: center;
            margin-top: 48px;
            color: var(--text-muted);
            font-size: 0.82rem;
            font-family: 'Fira Code', monospace;
        }

        footer.cyber-footer a {
            color: var(--cyan-glow);
            text-decoration: none;
            transition: color 0.2s;
        }

        footer.cyber-footer a:hover {
            color: #fff;
            text-shadow: 0 0 10px var(--cyan-glow);
        }
    </style>
</head>
<body>

    <!-- Ambient Glowing Orbs -->
    <div class="ambient-orb orb-1"></div>
    <div class="ambient-orb orb-2"></div>

    <!-- Particle Background Canvas -->
    <canvas id="particle-canvas"></canvas>

    <!-- Custom Cursor -->
    <div class="custom-cursor-dot" id="cursor-dot"></div>
    <div class="custom-cursor-ring" id="cursor-ring"></div>

    <div class="app-container">
        
        <!-- Navigation Bar -->
        <header class="cyber-nav">
            <div class="brand-hub">
                <div class="brand-badge" style="padding: 4px; display: flex; align-items: center; justify-content: center;">
                    <img src="/images/logo.png" alt="Logo" style="width: 26px; height: 26px; object-fit: contain;">
                </div>
                <div class="brand-info">
                    <h1>RITESH.DEV // CLOUD PORTAL</h1>
                    <span>ENTERPRISE AWS 3-TIER PLATFORM</span>
                </div>
            </div>

            <div class="user-telemetry">
                <div class="live-status">
                    <span class="pulse-dot"></span>
                    <span>ONLINE // 200 OK</span>
                </div>
                <div style="font-size: 0.9rem; font-weight: 600; color: #fff;">
                    User: <span style="color: var(--cyan-glow);">${username}</span>
                </div>
                <c:if test="${sessionScope.role == 'ROLE_ADMIN' || role == 'ROLE_ADMIN'}">
                    <a href="/admin" class="logout-btn" style="border-color: rgba(138,43,226,0.6); background: rgba(138,43,226,0.2); color: #d8b4fe;">⚡ Admin Console</a>
                </c:if>
                <a href="/logout" class="logout-btn">Log Out ⏻</a>
            </div>
        </header>

        <!-- Main Dashboard 3D Grid -->
        <div class="dashboard-grid">
            
            <!-- Left Card: Developer Profile & Identity -->
            <div class="card-3d" data-tilt>
                <span class="card-tag">// LEAD ARCHITECT & ENGINEER</span>
                
                <div class="profile-header">
                    <div class="avatar-frame">
                        <div class="avatar-inner" style="padding: 6px; overflow: hidden;">
                            <img src="/images/logo.png" alt="Ritesh Kumar" style="width: 100%; height: 100%; object-fit: contain; border-radius: 12px; filter: drop-shadow(0 0 10px rgba(0, 240, 255, 0.4));">
                        </div>
                    </div>
                    <div>
                        <h2 class="profile-name">Ritesh Kumar</h2>
                        <div class="profile-title">Software & Cloud / DevOps Engineer</div>
                    </div>
                </div>

                <p class="profile-bio">
                    Architected and engineered this enterprise-grade 3-Tier cloud application. Designed with high-availability AWS VPC topologies, automated Terraform infrastructure, containerized microservices, and end-to-end GitOps delivery.
                </p>

                <div class="tech-stack-wrap">
                    <div class="tech-pill"><span>☁️</span> AWS Multi-AZ</div>
                    <div class="tech-pill"><span>🛠️</span> Terraform v5.x</div>
                    <div class="tech-pill"><span>🐳</span> Docker OCI</div>
                    <div class="tech-pill"><span>⚙️</span> GitHub Actions</div>
                    <div class="tech-pill"><span>☕</span> Java 17 LTS</div>
                    <div class="tech-pill"><span>🍃</span> Spring Boot</div>
                    <div class="tech-pill"><span>🗄️</span> MySQL 8.0</div>
                    <div class="tech-pill"><span>🛡️</span> Trivy SAST</div>
                    <div class="tech-pill"><span>⚡</span> HikariCP</div>
                    <div class="tech-pill"><span>🔒</span> BCrypt Auth</div>
                </div>

                <div class="action-grid">
                    <a href="https://github.com/riteshkumar141068-hub/aws-3tier-cloud-architecture" target="_blank" class="cyber-btn btn-cyan">
                        <span>🐙 View GitHub Repo</span>
                    </a>
                    <a href="/actuator/health" target="_blank" class="cyber-btn btn-violet">
                        <span>📊 Live Health API</span>
                    </a>
                </div>
            </div>

            <!-- Right Card: Live Infrastructure Telemetry -->
            <div class="card-3d" data-tilt>
                <span class="card-tag">// CLOUD TELEMETRY & RUNTIME</span>
                
                <div class="telemetry-list">
                    <div class="telemetry-item">
                        <span class="item-label"><span>🌐</span> Cloud Topology</span>
                        <span class="item-val val-glow">AWS VPC (192.168.0.0/16)</span>
                    </div>

                    <div class="telemetry-item">
                        <span class="item-label"><span>⚖️</span> Traffic Distribution</span>
                        <span class="item-val val-glow">AWS Application Load Balancer</span>
                    </div>

                    <div class="telemetry-item">
                        <span class="item-label"><span>📈</span> Elastic Scaling</span>
                        <span class="item-val">Auto Scaling Group (2 - 6 EC2)</span>
                    </div>

                    <div class="telemetry-item">
                        <span class="item-label"><span>🗄️</span> Persistence Engine</span>
                        <span class="item-val val-emerald">Amazon RDS MySQL 8.0</span>
                    </div>

                    <div class="telemetry-item">
                        <span class="item-label"><span>🚀</span> Connection Pool</span>
                        <span class="item-val val-emerald">HikariCP (Active / Pooled)</span>
                    </div>

                    <div class="telemetry-item">
                        <span class="item-label"><span>🔐</span> Credential Security</span>
                        <span class="item-val">BCrypt Salted Hash (10-Round)</span>
                    </div>

                    <div class="telemetry-item">
                        <span class="item-label"><span>🛡️</span> Code Vulnerabilities</span>
                        <span class="item-val val-emerald">0 Critical (Trivy Verified)</span>
                    </div>

                    <div class="telemetry-item">
                        <span class="item-label"><span>📜</span> Provisioning Tool</span>
                        <span class="item-val val-glow">Terraform (AWS Provider 5.x)</span>
                    </div>
                </div>
            </div>

        </div>

        <!-- Full-Width Bottom Banner: Architecture Showcase -->
        <div class="arch-banner card-3d" data-tilt>
            <div class="arch-content">
                <span class="card-tag">// DEVOPS CAPSTONE HIGHLIGHT</span>
                <h3>Engineered for High Availability, Security & Scale</h3>
                <p>
                    From network subnets to secure database pooling, every tier follows enterprise defense-in-depth security principles. Application servers reside in isolated private subnets with automated zero-downtime health checking.
                </p>
            </div>
            <div>
                <a href="https://github.com/riteshkumar141068-hub/aws-3tier-cloud-architecture/blob/main/INTERVIEW_GUIDE.md" target="_blank" class="cyber-btn btn-cyan">
                    <span>📖 Interview Guide</span>
                </a>
            </div>
        </div>

        <!-- Footer -->
        <footer class="cyber-footer">
            <p>Designed & Architected by <a href="https://github.com/riteshkumar141068-hub" target="_blank">Ritesh Kumar</a> | &copy; 2026 All Rights Reserved.</p>
        </footer>

    </div>

    <!-- Scripts for 3D Tilt, Particle Mesh & Cursor Animation -->
    <script>
        // -------------------------------------------------------------
        // 1. Custom 3D Cursor Implementation
        // -------------------------------------------------------------
        const cursorDot = document.getElementById('cursor-dot');
        const cursorRing = document.getElementById('cursor-ring');
        let mouseX = window.innerWidth / 2;
        let mouseY = window.innerHeight / 2;
        let ringX = mouseX;
        let ringY = mouseY;

        window.addEventListener('mousemove', (e) => {
            mouseX = e.clientX;
            mouseY = e.clientY;
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

        // Scale cursor ring on hover over interactive elements
        const interactiveElements = document.querySelectorAll('a, button, .tech-pill, .telemetry-item, .card-3d');
        interactiveElements.forEach(el => {
            el.addEventListener('mouseenter', () => {
                cursorRing.style.width = '54px';
                cursorRing.style.height = '54px';
                cursorRing.style.borderColor = '#00f0ff';
                cursorRing.style.backgroundColor = 'rgba(0, 240, 255, 0.08)';
            });
            el.addEventListener('mouseleave', () => {
                cursorRing.style.width = '36px';
                cursorRing.style.height = '36px';
                cursorRing.style.borderColor = 'rgba(0, 240, 255, 0.6)';
                cursorRing.style.backgroundColor = 'transparent';
            });
        });

        // -------------------------------------------------------------
        // 2. High-Tech 3D Tilt Effect on Cards
        // -------------------------------------------------------------
        const tiltCards = document.querySelectorAll('[data-tilt]');
        tiltCards.forEach(card => {
            card.addEventListener('mousemove', (e) => {
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                const centerX = rect.width / 2;
                const centerY = rect.height / 2;
                
                const rotateX = ((y - centerY) / centerY) * -7;
                const rotateY = ((x - centerX) / centerX) * 7;
                
                card.style.transform = 'perspective(1000px) rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg) scale3d(1.015, 1.015, 1.015)';
            });

            card.addEventListener('mouseleave', () => {
                card.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)';
            });
        });

        // -------------------------------------------------------------
        // 3. Interactive Particle Mesh Background (HTML5 Canvas)
        // -------------------------------------------------------------
        const canvas = document.getElementById('particle-canvas');
        const ctx = canvas.getContext('2d');

        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }
        resizeCanvas();
        window.addEventListener('resize', resizeCanvas);

        const particles = [];
        const particleCount = Math.min(Math.floor(window.innerWidth / 22), 65);

        for (let i = 0; i < particleCount; i++) {
            particles.push({
                x: Math.random() * canvas.width,
                y: Math.random() * canvas.height,
                vx: (Math.random() - 0.5) * 0.7,
                vy: (Math.random() - 0.5) * 0.7,
                radius: Math.random() * 2 + 1
            });
        }

        function drawParticles() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // Connect nearby particles
            for (let i = 0; i < particles.length; i++) {
                for (let j = i + 1; j < particles.length; j++) {
                    const dx = particles[i].x - particles[j].x;
                    const dy = particles[i].y - particles[j].y;
                    const dist = Math.sqrt(dx * dx + dy * dy);

                    if (dist < 130) {
                        ctx.beginPath();
                        ctx.strokeStyle = 'rgba(0, 240, 255, ' + (0.15 * (1 - dist / 130)) + ')';
                        ctx.lineWidth = 0.8;
                        ctx.moveTo(particles[i].x, particles[i].y);
                        ctx.lineTo(particles[j].x, particles[j].y);
                        ctx.stroke();
                    }
                }
            }

            // Draw and update particles
            particles.forEach(p => {
                ctx.beginPath();
                ctx.arc(p.x, p.y, p.radius, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(0, 240, 255, 0.45)';
                ctx.fill();

                p.x += p.vx;
                p.y += p.vy;

                if (p.x < 0 || p.x > canvas.width) p.vx *= -1;
                if (p.y < 0 || p.y > canvas.height) p.vy *= -1;
            });

            requestAnimationFrame(drawParticles);
        }
        drawParticles();

        // Real-time active visit duration heartbeat (pings server every 15 seconds)
        setInterval(function() {
            try {
                fetch('/api/heartbeat', { method: 'POST' }).catch(function() {});
            } catch(e) {}
        }, 15000);
    </script>
</body>
</html>