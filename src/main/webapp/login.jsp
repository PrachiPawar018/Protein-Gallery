<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Protein Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700;800&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .page-wrapper { width: 100%; max-width: 440px; }

        .logo-bar {
            text-align: center;
            margin-bottom: 28px;
        }
        .logo-bar a {
            font-family: 'Montserrat', sans-serif;
            font-size: 28px;
            font-weight: 800;
            color: #FF6B35;
            text-decoration: none;
        }
        .logo-bar a span { color: #fff; }
        .logo-bar p { color: rgba(255,255,255,0.4); font-size: 13px; margin-top: 6px; }

        .card {
            background: rgba(255,255,255,0.04);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 20px;
            padding: 40px 36px;
            box-shadow: 0 24px 60px rgba(0,0,0,0.4);
        }

        .card h2 {
            font-family: 'Montserrat', sans-serif;
            font-size: 24px;
            font-weight: 800;
            color: #fff;
            margin-bottom: 6px;
        }
        .card .tagline {
            font-size: 14px;
            color: rgba(255,255,255,0.4);
            margin-bottom: 28px;
        }

        .alert {
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 13px;
            margin-bottom: 20px;
            display: flex; align-items: center; gap: 10px;
        }
        .alert-error   { background: rgba(231,76,60,0.15);  border: 1px solid rgba(231,76,60,0.3);  color: #e74c3c; }
        .alert-success { background: rgba(39,174,96,0.15);  border: 1px solid rgba(39,174,96,0.3);  color: #27AE60; }

        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: rgba(255,255,255,0.7);
            margin-bottom: 8px;
        }
        .label-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        .label-row label { margin-bottom: 0; }
        .forgot-link {
            font-size: 12px;
            color: #FF6B35;
            text-decoration: none;
            font-weight: 600;
            transition: opacity 0.2s;
        }
        .forgot-link:hover { opacity: 0.8; text-decoration: underline; }

        .password-wrapper { position: relative; }
        .form-group input {
            width: 100%;
            padding: 14px 44px 14px 16px;
            background: rgba(255,255,255,0.06);
            border: 1.5px solid rgba(255,255,255,0.12);
            border-radius: 10px;
            color: #fff;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }
        .form-group input[type="email"] { padding-right: 16px; }
        .form-group input:focus {
            border-color: #FF6B35;
            box-shadow: 0 0 0 3px rgba(255,107,53,0.15);
        }
        .form-group input::placeholder { color: rgba(255,255,255,0.25); }

        .toggle-pass {
            position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: rgba(255,255,255,0.35); font-size: 18px; padding: 4px;
            transition: color 0.2s;
        }
        .toggle-pass:hover { color: #FF6B35; }

        .remember-row {
            display: flex; align-items: center; gap: 10px;
            margin-bottom: 24px;
        }
        .remember-row input[type="checkbox"] {
            width: 18px; height: 18px; accent-color: #FF6B35;
            padding: 0; flex-shrink: 0;
        }
        .remember-row label { color: rgba(255,255,255,0.5); font-size: 13px; cursor: pointer; }

        .btn-primary {
            display: block; width: 100%; padding: 15px;
            background: linear-gradient(135deg, #FF6B35, #f7931e);
            color: #fff; border: none; border-radius: 12px;
            font-size: 16px; font-weight: 700;
            font-family: 'Montserrat', sans-serif;
            cursor: pointer; letter-spacing: 0.5px;
            transition: transform 0.15s, box-shadow 0.15s;
            box-shadow: 0 4px 20px rgba(255,107,53,0.35);
        }
        .btn-primary:hover  { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(255,107,53,0.45); }
        .btn-primary:active { transform: translateY(0); }

        .divider {
            display: flex; align-items: center; gap: 12px;
            margin: 24px 0;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1; height: 1px;
            background: rgba(255,255,255,0.1);
        }
        .divider span { color: rgba(255,255,255,0.3); font-size: 12px; white-space: nowrap; }

        .register-link {
            text-align: center; font-size: 14px;
            color: rgba(255,255,255,0.4);
        }
        .register-link a { color: #FF6B35; font-weight: 600; text-decoration: none; }
        .register-link a:hover { text-decoration: underline; }

        /* Spinner */
        .btn-primary.loading .btn-text { display: none; }
        .btn-primary .spinner { display: none; width: 18px; height: 18px; border: 2px solid rgba(255,255,255,0.3); border-top-color: #fff; border-radius: 50%; animation: spin 0.6s linear infinite; margin: auto; }
        .btn-primary.loading .spinner { display: block; }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>
<div class="page-wrapper">

    <div class="logo-bar">
        <a href="index.jsp">Protein<span>Gallery</span></a>
        <p>India's Premium Protein Store 💪</p>
    </div>

    <div class="card">
        <h2>Welcome Back!</h2>
        <p class="tagline">Login to continue your fitness journey</p>

        <% String error = request.getParameter("error");
           if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error">⚠️ <%= error %></div>
        <% } %>

        <% String message = request.getParameter("message");
           if (message != null && !message.isEmpty()) { %>
        <div class="alert alert-success">✅ <%= message %></div>
        <% } %>

        <form action="auth" method="POST" onsubmit="setLoading(this)">
            <input type="hidden" name="action" value="login">
            <input type="hidden" name="csrf_token" value="${sessionScope.csrf_token}">

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required
                       placeholder="you@example.com" autocomplete="email">
            </div>

            <div class="form-group">
                <div class="label-row">
                    <label for="password">Password</label>
                    <a href="forgot-password" class="forgot-link">Forgot password?</a>
                </div>
                <div class="password-wrapper">
                    <input type="password" id="password" name="password" required
                           placeholder="••••••••" autocomplete="current-password">
                    <button type="button" class="toggle-pass" onclick="toggleVis('password', this)" tabindex="-1">👁</button>
                </div>
            </div>

            <div class="remember-row">
                <input type="checkbox" id="remember" name="remember" value="true">
                <label for="remember">Remember me for 30 days</label>
            </div>

            <button type="submit" class="btn-primary">
                <span class="btn-text">Login →</span>
                <span class="spinner"></span>
            </button>
        </form>

        <div class="divider"><span>New here?</span></div>

        <div class="register-link">
            Don't have an account? <a href="register.jsp">Create one free →</a>
        </div>
    </div>
</div>

<script>
function toggleVis(id, btn) {
    const inp = document.getElementById(id);
    inp.type = inp.type === 'password' ? 'text' : 'password';
    btn.textContent = inp.type === 'password' ? '👁' : '🙈';
}
function setLoading(form) {
    const btn = form.querySelector('.btn-primary');
    if (btn) btn.classList.add('loading');
}
</script>
</body>
</html>

