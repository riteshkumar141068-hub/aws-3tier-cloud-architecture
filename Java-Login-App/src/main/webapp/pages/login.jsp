<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GrizzlyOps Portal Login // Ritesh Kumar</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="icon" type="image/png" href="/images/logo.png">
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;600&family=Inter:wght@300;400;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --bg-deep: #060913;
            --bg-card: rgba(13, 20, 36, 0.75);
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
            cursor: none;
        }

        body {
            background-color: var(--bg-deep);
            color: var(--text-main);
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
            padding: 20px;
        }

        /* Ambient Glowing Orbs */
        .ambient-orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(130px);
            opacity: 0.35;
            z-index: 0;
            pointer-events: none;
        }
        .orb-1 { width: 500px; height: 500px; background: radial-gradient(circle, var(--cyan-glow), transparent 70%); top: -120px; left: -120px; }
        .orb-2 { width: 550px; height: 550px; background: radial-gradient(circle, var(--violet-glow), transparent 70%); bottom: -120px; right: -120px; }

        #particle-canvas {
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 1;
            pointer-events: none;
        }

        /* Custom 3D Cursor */
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

        /* 3D Login Card */
        .login-card {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 440px;
            background: var(--bg-card);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid var(--border-glow);
            border-radius: 24px;
            padding: 40px 36px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.6), inset 0 0 20px rgba(0, 240, 255, 0.04);
            transform-style: preserve-3d;
            transition: transform 0.15s ease-out, border-color 0.3s, box-shadow 0.3s;
        }

        .login-card:hover {
            border-color: rgba(0, 240, 255, 0.5);
            box-shadow: 0 30px 70px rgba(0, 240, 255, 0.15);
        }

        .brand-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-family: 'Fira Code', monospace;
            font-size: 0.75rem;
            color: var(--cyan-glow);
            background: rgba(0, 240, 255, 0.08);
            border: 1px solid rgba(0, 240, 255, 0.25);
            padding: 5px 14px;
            border-radius: 20px;
            margin-bottom: 20px;
        }

        h2.title {
            font-size: 1.8rem;
            font-weight: 800;
            color: #fff;
            letter-spacing: -0.5px;
            margin-bottom: 6px;
        }

        p.subtitle {
            font-size: 0.88rem;
            color: var(--text-muted);
            margin-bottom: 26px;
        }

        .error-banner {
            background: rgba(255, 77, 77, 0.15);
            border: 1px solid rgba(255, 77, 77, 0.35);
            color: #ff6b6b;
            padding: 10px 14px;
            border-radius: 12px;
            font-size: 0.84rem;
            margin-bottom: 20px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: #cbd5e1;
            margin-bottom: 8px;
            letter-spacing: 0.3px;
        }

        .input-wrap {
            position: relative;
        }

        .input-wrap input {
            width: 100%;
            padding: 13px 16px;
            background: rgba(255, 255, 255, 0.035);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 12px;
            color: #fff;
            font-size: 0.92rem;
            font-family: 'Inter', sans-serif;
            outline: none;
            transition: all 0.25s ease;
        }

        .input-wrap input:focus {
            background: rgba(0, 240, 255, 0.05);
            border-color: var(--cyan-glow);
            box-shadow: 0 0 15px rgba(0, 240, 255, 0.25);
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            margin-top: 10px;
            background: linear-gradient(135deg, var(--cyan-glow), #0099ff);
            border: none;
            border-radius: 12px;
            color: #050811;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: none;
            transition: all 0.25s ease;
            box-shadow: 0 0 20px rgba(0, 240, 255, 0.4);
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 30px rgba(0, 240, 255, 0.7);
        }

        .auth-footer {
            margin-top: 24px;
            text-align: center;
            font-size: 0.85rem;
            color: var(--text-muted);
        }

        .auth-footer a {
            color: var(--cyan-glow);
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s;
        }

        .auth-footer a:hover {
            color: #fff;
            text-shadow: 0 0 8px var(--cyan-glow);
        }

        .creator-tag {
            text-align: center;
            margin-top: 22px;
            font-size: 0.75rem;
            font-family: 'Fira Code', monospace;
            color: #64748b;
        }

        .creator-tag span {
            color: var(--cyan-glow);
        }
    </style>
</head>
<body>

    <div class="ambient-orb orb-1"></div>
    <div class="ambient-orb orb-2"></div>
    <canvas id="particle-canvas"></canvas>

    <div class="custom-cursor-dot" id="cursor-dot"></div>
    <div class="custom-cursor-ring" id="cursor-ring"></div>

    <div class="login-card" id="tilt-card">
        <div style="display: flex; justify-content: center; margin-bottom: 16px;">
            <div style="width: 76px; height: 76px; border-radius: 22px; background: linear-gradient(135deg, #00f0ff, #8a2be2); padding: 2.5px; box-shadow: 0 0 25px rgba(0, 240, 255, 0.45);">
                <div style="width: 100%; height: 100%; background: #080d1a; border-radius: 19px; display: flex; align-items: center; justify-content: center; padding: 6px;">
                    <img src="/images/logo.png" alt="Ritesh Kumar" style="width: 100%; height: 100%; object-fit: contain;">
                </div>
            </div>
        </div>
        <div class="brand-badge" style="margin: 0 auto 16px auto; width: fit-content;">🕶️ GRIZZLYOPS // SECURE ACCESS</div>
        <h2 class="title">Sign In</h2>
        <p class="subtitle">Enterprise Cloud Telemetry & Authentication</p>

        <% if (request.getAttribute("errorMessage") != null && !request.getAttribute("errorMessage").toString().isEmpty()) { %>
            <div class="error-banner">${errorMessage}</div>
        <% } %>

        <form method="post" action="login">
            <div class="form-group">
                <label>Username</label>
                <div class="input-wrap">
                    <input type="text" name="userName" required autocomplete="off" placeholder="Enter your username">
                </div>
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="input-wrap">
                    <input type="password" name="password" required placeholder="••••••••••••">
                </div>
            </div>

            <button type="submit" class="btn-submit">Authenticate ➔</button>

            <div class="auth-footer">
                Don't have an account? <a href="register">Register Here</a>
            </div>

            <div class="creator-tag">
                Architected by <span>Ritesh Kumar</span> // GrizzlyOps Lead Engineer
            </div>
        </form>
    </div>

    <script>
        // Custom 3D Cursor
        const cursorDot = document.getElementById('cursor-dot');
        const cursorRing = document.getElementById('cursor-ring');
        let mouseX = window.innerWidth / 2, mouseY = window.innerHeight / 2;
        let ringX = mouseX, ringY = mouseY;

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

        // 3D Tilt Card
        const card = document.getElementById('tilt-card');
        card.addEventListener('mousemove', (e) => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            const centerX = rect.width / 2;
            const centerY = rect.height / 2;
            const rotateX = ((y - centerY) / centerY) * -9;
            const rotateY = ((x - centerX) / centerX) * 9;
            card.style.transform = 'perspective(1000px) rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg) scale3d(1.02, 1.02, 1.02)';
        });
        card.addEventListener('mouseleave', () => {
            card.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)';
        });

        // Particle Canvas
        const canvas = document.getElementById('particle-canvas');
        const ctx = canvas.getContext('2d');
        function resize() { canvas.width = window.innerWidth; canvas.height = window.innerHeight; }
        resize();
        window.addEventListener('resize', resize);

        const particles = [];
        for (let i = 0; i < 40; i++) {
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
                    const dx = particles[i].x - particles[j].x;
                    const dy = particles[i].y - particles[j].y;
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