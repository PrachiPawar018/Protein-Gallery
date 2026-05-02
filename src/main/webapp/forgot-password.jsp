<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Protein Gallery</title>
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

        .page-wrapper {
            width: 100%;
            max-width: 480px;
        }

        /* === LOGO === */
        .logo-bar {
            text-align: center;
            margin-bottom: 28px;
        }
        .logo-bar a {
            font-family: 'Montserrat', sans-serif;
            font-size: 26px;
            font-weight: 800;
            color: #FF6B35;
            text-decoration: none;
            letter-spacing: 1px;
        }
        .logo-bar a span { color: #fff; }

        /* === PROGRESS STEPS === */
        .steps-bar {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 28px;
            gap: 0;
        }
        .step-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 6px;
        }
        .step-circle {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.05);
            color: rgba(255,255,255,0.4);
            font-weight: 700;
            font-size: 14px;
            display: flex; align-items: center; justify-content: center;
            transition: all 0.3s;
        }
        .step-circle.active {
            background: #FF6B35;
            border-color: #FF6B35;
            color: #fff;
            box-shadow: 0 0 16px rgba(255,107,53,0.5);
        }
        .step-circle.done {
            background: #27AE60;
            border-color: #27AE60;
            color: #fff;
        }
        .step-label {
            font-size: 10px;
            color: rgba(255,255,255,0.4);
            text-align: center;
            white-space: nowrap;
        }
        .step-label.active { color: #FF6B35; font-weight: 600; }
        .step-label.done   { color: #27AE60; }
        .step-line {
            flex: 1;
            height: 2px;
            background: rgba(255,255,255,0.1);
            margin: 0 8px;
            margin-bottom: 22px;
        }
        .step-line.done { background: #27AE60; }

        /* === CARD === */
        .card {
            background: rgba(255,255,255,0.04);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 20px;
            padding: 40px 36px;
            box-shadow: 0 24px 60px rgba(0,0,0,0.4);
        }

        .card-icon {
            text-align: center;
            font-size: 52px;
            margin-bottom: 12px;
            animation: bounce 1s ease infinite alternate;
        }
        @keyframes bounce {
            from { transform: translateY(0); }
            to   { transform: translateY(-6px); }
        }

        .card h2 {
            font-family: 'Montserrat', sans-serif;
            font-size: 22px;
            font-weight: 800;
            color: #fff;
            text-align: center;
            margin-bottom: 8px;
        }
        .card p.subtitle {
            font-size: 14px;
            color: rgba(255,255,255,0.5);
            text-align: center;
            margin-bottom: 28px;
            line-height: 1.6;
        }
        .card p.subtitle strong { color: #FF6B35; }

        /* === ALERTS === */
        .alert {
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 13px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-error   { background: rgba(231,76,60,0.15);  border: 1px solid rgba(231,76,60,0.3);  color: #e74c3c; }
        .alert-success { background: rgba(39,174,96,0.15);  border: 1px solid rgba(39,174,96,0.3);  color: #27AE60; }

        /* === FORM === */
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: rgba(255,255,255,0.7);
            margin-bottom: 8px;
        }
        .form-group input {
            width: 100%;
            padding: 14px 16px;
            background: rgba(255,255,255,0.06);
            border: 1.5px solid rgba(255,255,255,0.12);
            border-radius: 10px;
            color: #fff;
            font-size: 15px;
            font-family: 'Inter', sans-serif;
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }
        .form-group input:focus {
            border-color: #FF6B35;
            box-shadow: 0 0 0 3px rgba(255,107,53,0.15);
        }
        .form-group input::placeholder { color: rgba(255,255,255,0.25); }

        /* OTP inputs */
        .otp-grid {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-bottom: 24px;
        }
        .otp-grid input {
            width: 52px;
            height: 60px;
            text-align: center;
            font-size: 24px;
            font-weight: 700;
            color: #FF6B35;
            background: rgba(255,255,255,0.06);
            border: 1.5px solid rgba(255,255,255,0.15);
            border-radius: 12px;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            padding: 0;
        }
        .otp-grid input:focus {
            border-color: #FF6B35;
            box-shadow: 0 0 0 3px rgba(255,107,53,0.2);
        }

        /* === PASSWORD STRENGTH === */
        .strength-bar { height: 4px; border-radius: 2px; background: rgba(255,255,255,0.1); margin-top: 8px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 2px; transition: width 0.3s, background 0.3s; width: 0; }
        .strength-text { font-size: 11px; margin-top: 4px; font-weight: 600; }

        /* === BUTTON === */
        .btn-primary {
            display: block;
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #FF6B35, #f7931e);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            font-family: 'Montserrat', sans-serif;
            cursor: pointer;
            letter-spacing: 0.5px;
            transition: transform 0.15s, box-shadow 0.15s, opacity 0.15s;
            box-shadow: 0 4px 20px rgba(255,107,53,0.35);
            margin-top: 4px;
        }
        .btn-primary:hover  { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(255,107,53,0.45); }
        .btn-primary:active { transform: translateY(0);    opacity: 0.9; }

        .btn-outline {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 10px 18px;
            background: transparent;
            border: 1.5px solid rgba(255,255,255,0.15);
            border-radius: 8px;
            color: rgba(255,255,255,0.6);
            font-size: 13px;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: border-color 0.2s, color 0.2s;
            text-decoration: none;
        }
        .btn-outline:hover { border-color: #FF6B35; color: #FF6B35; }

        /* === RESEND === */
        .resend-row {
            text-align: center;
            margin-top: 16px;
            font-size: 13px;
            color: rgba(255,255,255,0.4);
        }
        .resend-row a, .resend-row button.link-btn {
            color: #FF6B35;
            text-decoration: none;
            font-weight: 600;
            background: none; border: none; cursor: pointer;
            font-size: 13px; font-family: 'Inter', sans-serif;
        }
        .resend-row a:hover, .resend-row button.link-btn:hover { text-decoration: underline; }

        .footer-link {
            text-align: center;
            margin-top: 22px;
            font-size: 13px;
            color: rgba(255,255,255,0.4);
        }
        .footer-link a { color: #FF6B35; text-decoration: none; font-weight: 600; }
        .footer-link a:hover { text-decoration: underline; }

        /* === SHOW/HIDE PASSWORD === */
        .password-wrapper { position: relative; }
        .toggle-pass {
            position: absolute; right: 14px; top: 50%; transform: translateY(-50%);
            background: none; border: none; cursor: pointer; color: rgba(255,255,255,0.4);
            font-size: 18px; padding: 4px; transition: color 0.2s;
        }
        .toggle-pass:hover { color: #FF6B35; }

        /* === SUCCESS STATE === */
        .success-check {
            text-align: center;
            margin-bottom: 20px;
        }
        .success-check .checkmark {
            width: 70px; height: 70px;
            background: rgba(39,174,96,0.15);
            border: 2px solid #27AE60;
            border-radius: 50%;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 32px;
            animation: pop 0.4s ease;
        }
        @keyframes pop {
            0%   { transform: scale(0.5); opacity: 0; }
            80%  { transform: scale(1.1); }
            100% { transform: scale(1); opacity: 1; }
        }

        /* Spinner */
        .spinner { display: none; }
        .btn-primary.loading .spinner { display: inline-block; }
        .btn-primary.loading .btn-text { display: none; }
        .spinner { width: 18px; height: 18px; border: 2px solid rgba(255,255,255,0.3); border-top-color: #fff; border-radius: 50%; animation: spin 0.6s linear infinite; }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
</head>
<body>
<%
    String step  = request.getParameter("step");
    if (step == null) step = "1";
    String error = request.getParameter("error");
    String email = request.getParameter("email");
    if (email == null) email = "";

    // Secure step 3: must have otpVerifiedEmail in session
    if ("3".equals(step)) {
        String verified = (String) session.getAttribute("otpVerifiedEmail");
        if (verified == null || verified.isEmpty()) {
            step = "1";
            error = "Session expired. Please start again.";
        }
    }
%>

<div class="page-wrapper">

    <!-- Logo -->
    <div class="logo-bar">
        <a href="index.jsp">Protein<span>Gallery</span></a>
    </div>

    <!-- Progress Steps -->
    <div class="steps-bar">
        <div class="step-item">
            <div class="step-circle <%= "1".equals(step) ? "active" : "done" %>">
                <%= "1".equals(step) ? "1" : "✓" %>
            </div>
            <div class="step-label <%= "1".equals(step) ? "active" : "done" %>">Email</div>
        </div>
        <div class="step-line <%= !("1".equals(step)) ? "done" : "" %>"></div>
        <div class="step-item">
            <div class="step-circle <%= "2".equals(step) ? "active" : ("3".equals(step) ? "done" : "") %>">
                <%= "3".equals(step) ? "✓" : "2" %>
            </div>
            <div class="step-label <%= "2".equals(step) ? "active" : ("3".equals(step) ? "done" : "") %>">Verify OTP</div>
        </div>
        <div class="step-line <%= "3".equals(step) ? "done" : "" %>"></div>
        <div class="step-item">
            <div class="step-circle <%= "3".equals(step) ? "active" : "" %>">3</div>
            <div class="step-label <%= "3".equals(step) ? "active" : "" %>">New Password</div>
        </div>
    </div>

    <div class="card">

        <!-- =========================================== -->
        <!-- STEP 1: Enter Email -->
        <!-- =========================================== -->
        <% if ("1".equals(step)) { %>

        <div class="card-icon">📧</div>
        <h2>Forgot Password?</h2>
        <p class="subtitle">Enter your registered email and we'll send you a <strong>6-digit OTP</strong> to reset your password.</p>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error">⚠️ <%= request.getParameter("error") %></div>
        <% } %>

        <form action="forgot-password" method="POST" onsubmit="setLoading(this)">
            <input type="hidden" name="action" value="sendOtp">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" required
                       placeholder="you@example.com" autocomplete="email"
                       value="<%= email.replace("\"", "&quot;") %>">
            </div>
            <button type="submit" class="btn-primary" id="sendBtn">
                <span class="btn-text">Send OTP →</span>
                <span class="spinner"></span>
            </button>
        </form>

        <div class="footer-link">
            Remember your password? <a href="login.jsp">Back to Login</a>
        </div>

        <!-- =========================================== -->
        <!-- STEP 2: Enter OTP -->
        <!-- =========================================== -->
        <% } else if ("2".equals(step)) { %>

        <div class="card-icon">🔢</div>
        <h2>Enter OTP</h2>
        <p class="subtitle">We've sent a 6-digit code to <strong><%= email.isEmpty() ? "your email" : email %></strong>.<br>Check your inbox (and spam folder).</p>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error">⚠️ <%= request.getParameter("error") %></div>
        <% } %>

        <form action="forgot-password" method="POST" id="otpForm" onsubmit="setLoading(this)">
            <input type="hidden" name="action" value="verifyOtp">
            <input type="hidden" name="email" value="<%= email %>">
            <input type="hidden" name="otp"   id="otpHidden">

            <!-- 6 individual OTP input boxes -->
            <div class="otp-grid">
                <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]" autocomplete="off">
                <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]" autocomplete="off">
                <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]" autocomplete="off">
                <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]" autocomplete="off">
                <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]" autocomplete="off">
                <input type="text" maxlength="1" class="otp-digit" inputmode="numeric" pattern="[0-9]" autocomplete="off">
            </div>

            <button type="submit" class="btn-primary">
                <span class="btn-text">Verify OTP →</span>
                <span class="spinner"></span>
            </button>
        </form>

        <div class="resend-row">
            Didn't receive it?
            <form action="forgot-password" method="POST" style="display:inline">
                <input type="hidden" name="action" value="sendOtp">
                <input type="hidden" name="email"  value="<%= email %>">
                <button type="submit" class="link-btn">Resend OTP</button>
            </form>
        </div>

        <div class="footer-link">
            Wrong email? <a href="forgot-password?step=1">Go back</a>
        </div>

        <!-- =========================================== -->
        <!-- STEP 3: New Password -->
        <!-- =========================================== -->
        <% } else if ("3".equals(step)) { %>

        <div class="card-icon">🔐</div>
        <h2>Set New Password</h2>
        <p class="subtitle">OTP verified! Create a strong new password for your account.</p>

        <% if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-error">⚠️ <%= request.getParameter("error") %></div>
        <% } %>

        <form action="forgot-password" method="POST" id="resetForm" onsubmit="return validateReset(this)">
            <input type="hidden" name="action" value="resetPassword">

            <div class="form-group">
                <label for="newPassword">New Password</label>
                <div class="password-wrapper">
                    <input type="password" id="newPassword" name="newPassword" required
                           placeholder="Min. 8 characters" minlength="8"
                           oninput="checkStrength(this.value)">
                    <button type="button" class="toggle-pass" onclick="toggleVis('newPassword', this)">👁</button>
                </div>
                <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                <div class="strength-text" id="strengthText"></div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <div class="password-wrapper">
                    <input type="password" id="confirmPassword" name="confirmPassword" required
                           placeholder="Repeat your password">
                    <button type="button" class="toggle-pass" onclick="toggleVis('confirmPassword', this)">👁</button>
                </div>
                <div id="matchMsg" style="font-size:12px; margin-top:6px;"></div>
            </div>

            <button type="submit" class="btn-primary">
                <span class="btn-text">Reset Password ✓</span>
                <span class="spinner"></span>
            </button>
        </form>

        <% } %>

    </div><!-- /card -->
</div><!-- /page-wrapper -->

<script>
// ============================================================
// OTP BOX: auto-advance + backspace + paste support
// ============================================================
document.addEventListener('DOMContentLoaded', () => {
    const digits = document.querySelectorAll('.otp-digit');
    if (!digits.length) return;

    digits.forEach((input, idx) => {
        input.addEventListener('input', () => {
            if (input.value.length === 1 && idx < digits.length - 1) {
                digits[idx + 1].focus();
            }
            updateHidden();
        });
        input.addEventListener('keydown', (e) => {
            if (e.key === 'Backspace' && !input.value && idx > 0) {
                digits[idx - 1].focus();
            }
        });
        input.addEventListener('paste', (e) => {
            e.preventDefault();
            const pasted = (e.clipboardData || window.clipboardData).getData('text').replace(/\D/g, '');
            digits.forEach((d, i) => { d.value = pasted[i] || ''; });
            const next = Math.min(pasted.length, digits.length - 1);
            digits[next].focus();
            updateHidden();
        });
    });

    function updateHidden() {
        const h = document.getElementById('otpHidden');
        if (h) h.value = Array.from(digits).map(d => d.value).join('');
    }

    // Auto-focus first digit
    if (digits[0]) digits[0].focus();
});

// ============================================================
// OTP Form submit validation
// ============================================================
const otpForm = document.getElementById('otpForm');
if (otpForm) {
    otpForm.addEventListener('submit', (e) => {
        const otp = document.getElementById('otpHidden').value;
        if (otp.length < 6) {
            e.preventDefault();
            alert('Please enter all 6 digits of the OTP.');
        }
    });
}

// ============================================================
// PASSWORD STRENGTH
// ============================================================
function checkStrength(val) {
    const fill = document.getElementById('strengthFill');
    const text = document.getElementById('strengthText');
    if (!fill) return;
    let score = 0;
    if (val.length >= 8) score++;
    if (/[A-Z]/.test(val)) score++;
    if (/[0-9]/.test(val)) score++;
    if (/[^A-Za-z0-9]/.test(val)) score++;

    const map = [
        { pct: '0%', color: '', label: '' },
        { pct: '25%', color: '#e74c3c', label: '🔴 Weak' },
        { pct: '50%', color: '#f39c12', label: '🟡 Fair' },
        { pct: '75%', color: '#3498db', label: '🔵 Good' },
        { pct: '100%', color: '#27AE60', label: '🟢 Strong' },
    ];
    fill.style.width      = map[score].pct;
    fill.style.background = map[score].color;
    text.textContent      = map[score].label;
    text.style.color      = map[score].color;
}

// ============================================================
// PASSWORD MATCH
// ============================================================
const confirmPwd = document.getElementById('confirmPassword');
if (confirmPwd) {
    confirmPwd.addEventListener('input', () => {
        const newPwd = document.getElementById('newPassword').value;
        const msg    = document.getElementById('matchMsg');
        if (!confirmPwd.value) { msg.textContent = ''; return; }
        if (newPwd === confirmPwd.value) {
            msg.textContent = '✅ Passwords match'; msg.style.color = '#27AE60';
        } else {
            msg.textContent = '❌ Passwords do not match'; msg.style.color = '#e74c3c';
        }
    });
}

function validateReset(form) {
    const p1 = document.getElementById('newPassword').value;
    const p2 = document.getElementById('confirmPassword').value;
    if (p1.length < 8) {
        alert('Password must be at least 8 characters.');
        return false;
    }
    if (p1 !== p2) {
        alert('Passwords do not match.');
        return false;
    }
    setLoading(form);
    return true;
}

// ============================================================
// SHOW/HIDE PASSWORD
// ============================================================
function toggleVis(id, btn) {
    const inp = document.getElementById(id);
    if (inp.type === 'password') {
        inp.type = 'text';
        btn.textContent = '🙈';
    } else {
        inp.type = 'password';
        btn.textContent = '👁';
    }
}

// ============================================================
// LOADING SPINNER
// ============================================================
function setLoading(form) {
    const btn = form.querySelector('.btn-primary');
    if (btn) btn.classList.add('loading');
}
</script>
</body>
</html>
