<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enterprise AWS 3-Tier Platform // Ritesh Kumar</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
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

        .ambient-orb {
            position: fixed;
            border-radius: 50%;
            filter: blur(130px);
            opacity: 0.35;
            z-index: 0;
            pointer-events: none;
        }
        .orb-1 { width: 520px; height: 520px; background: radial-gradient(circle, var(--cyan-glow), transparent 70%); top: -120px; left: -120px; }
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

        .hero-card {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 580px;
            background: var(--bg-card);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
            border: 1px solid var(--border-glow);
            border-radius: 28px;
            padding: 48px 40px;
            text-align: center;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.6), inset 0 0 25px rgba(0, 240, 255, 0.04);
            transform-style: preserve-3d;
            transition: transform 0.15s ease-out, border-color 0.3s;
        }

        .hero-card:hover {
            border-color: rgba(0, 240, 255, 0.5);
            box-shadow: 0 30px 70px rgba(0, 240, 255, 0.15);
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-family: 'Fira Code', monospace;
            font-size: 0.78rem;
            color: var(--cyan-glow);
            background: rgba(0, 240, 255, 0.08);
            border: 1px solid rgba(0, 240, 255, 0.25);
            padding: 6px 16px;
            border-radius: 20px;
            margin-bottom: 22px;
        }

        h1.hero-title {
            font-size: 2.2rem;
            font-weight: 800;
            color: #fff;
            letter-spacing: -0.8px;
            line-height: 1.25;
            margin-bottom: 14px;
        }

        .hero-title span {
            background: linear-gradient(135deg, var(--cyan-glow), var(--violet-glow));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        p.hero-desc {
            font-size: 0.95rem;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 34px;
        }

        .btn-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 28px;
        }

        .btn-cyber {
            padding: 14px 20px;
            border-radius: 14px;
            font-size: 0.92rem;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.25s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--cyan-glow), #0088ff);
            color: #050811;
            box-shadow: 0 0 20px rgba(0, 240, 255, 0.4);
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 0 30px rgba(0, 240, 255, 0.7);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.12);
            color: #fff;
        }
        .btn-secondary:hover {
            background: rgba(0, 240, 255, 0.1);
            border-color: var(--cyan-glow);
            transform: translateY(-2px);
            box-shadow: 0 0 20px rgba(0, 240, 255, 0.2);
        }

        .creator-footer {
            font-size: 0.8rem;
            font-family: 'Fira Code', monospace;
            color: #64748b;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            padding-top: 20px;
        }
        .creator-footer span { color: var(--cyan-glow); }
    </style>
</head>
<body>

    <div class="ambient-orb orb-1"></div>
    <div class="ambient-orb orb-2"></div>
    <canvas id="particle-canvas"></canvas>

    <div class="custom-cursor-dot" id="cursor-dot"></div>
    <div class="custom-cursor-ring" id="cursor-ring"></div>

    <div class="hero-card" id="tilt-card">
        <div class="hero-badge">⚡ PRODUCTION CLOUD ARCHITECTURE</div>
        <h1 class="hero-title">Enterprise AWS 3-Tier <span>Web Platform</span></h1>
        <p class="hero-desc">
            High-availability cloud portal built with Spring Boot, automated with Terraform, containerized via Docker, and orchestrated on AWS Multi-AZ infrastructure.
        </p>

        <div class="btn-row">
            <a href="login" class="btn-cyber btn-primary">Sign In ➔</a>
            <a href="register" class="btn-cyber btn-secondary">Register New User</a>
        </div>

        <div class="creator-footer">
            Designed & Engineered by <span>Ritesh Kumar</span> // Software & DevOps Engineer
        </div>
    </div>

    <script>
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

        const card = document.getElementById('tilt-card');
        card.addEventListener('mousemove', (e) => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left, y = e.clientY - rect.top;
            const centerX = rect.width / 2, centerY = rect.height / 2;
            const rotateX = ((y - centerY) / centerY) * -8;
            const rotateY = ((x - centerX) / centerX) * 8;
            card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.02, 1.02, 1.02)`;
        });
        card.addEventListener('mouseleave', () => {
            card.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)';
        });

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
                    const dx = particles[i].x - particles[j].x, dy = particles[i].y - particles[j].y;
                    const dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist < 120) {
                        ctx.beginPath();
                        ctx.strokeStyle = `rgba(0, 240, 255, ${0.12 * (1 - dist / 120)})`;
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