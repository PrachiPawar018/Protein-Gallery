<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="pageTitle" value="Login - Protein Gallery" />

<jsp:include page="WEB-INF/components/header.jsp" />

    <!-- Login Section -->
    <section class="auth-section section">
        <div class="container">
            <div class="auth-wrapper">
                <!-- Login Form -->
                <div class="auth-card card">
                    <div class="auth-header">
                        <h2>Welcome Back!</h2>
                        <p class="auth-tagline">Login to continue your fitness journey</p>
                    </div>

                    <c:if test="${not empty param.error}">
                        <div class="alert alert-error">
                            <span class="alert-icon">⚠️</span>
                            <span>${param.error}</span>
                        </div>
                    </c:if>

                    <c:if test="${not empty param.message}">
                        <div class="alert alert-success">
                            <span class="alert-icon">✅</span>
                            <span>${param.message}</span>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth" method="POST" class="auth-form" onsubmit="setLoading(this)">
                        <input type="hidden" name="action" value="login">
                        <input type="hidden" name="csrf_token" value="${sessionScope.csrf_token}">

                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control"
                                   placeholder="you@example.com" autocomplete="email" required>
                        </div>

                        <div class="form-group">
                            <div class="password-header">
                                <label for="password">Password</label>
                                <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-link">Forgot password?</a>
                            </div>
                            <div class="password-wrapper">
                                <input type="password" id="password" name="password" class="form-control"
                                       placeholder="••••••••" autocomplete="current-password" required>
                                <button type="button" class="toggle-password" onclick="togglePasswordVisibility('password', this)" tabindex="-1">
                                    <span class="eye-icon">👁️</span>
                                </button>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="checkbox-label">
                                <input type="checkbox" id="remember" name="remember" value="true">
                                <span class="checkmark"></span>
                                Remember me for 30 days
                            </label>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg">
                            <span class="btn-text">Login Securely</span>
                            <span class="spinner"></span>
                        </button>
                    </form>

                    <div class="auth-divider">
                        <span>New to Protein Gallery?</span>
                    </div>

                    <div class="auth-links">
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline">
                            Create Free Account
                        </a>
                    </div>
                </div>

                <!-- Benefits Sidebar -->
                <div class="auth-sidebar">
                    <div class="benefits-card card">
                        <h3>Why Login?</h3>
                        <div class="benefits-list">
                            <div class="benefit-item">
                                <div class="benefit-icon">🚚</div>
                                <div class="benefit-content">
                                    <h4>Fast & Free Shipping</h4>
                                    <p>Free delivery on orders over $50</p>
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">💰</div>
                                <div class="benefit-content">
                                    <h4>Exclusive Discounts</h4>
                                    <p>Member-only offers and promotions</p>
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">📦</div>
                                <div class="benefit-content">
                                    <h4>Order Tracking</h4>
                                    <p>Real-time updates on your orders</p>
                                </div>
                            </div>
                            <div class="benefit-item">
                                <div class="benefit-icon">👨‍⚕️</div>
                                <div class="benefit-content">
                                    <h4>Expert Support</h4>
                                    <p>Personalized nutrition advice</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

<jsp:include page="WEB-INF/components/footer.jsp" />

<style>
/* Auth Section */
.auth-section {
    padding: 4rem 1rem;
    background: linear-gradient(135deg, var(--bg-dark) 0%, #1e293b 100%);
    min-height: calc(100vh - 200px);
    display: flex;
    align-items: center;
}

.auth-wrapper {
    max-width: 1000px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: 1fr 400px;
    gap: 3rem;
    align-items: start;
}

.auth-card {
    padding: 3rem;
    background: var(--card-bg);
    border: 1px solid rgba(255,255,255,0.05);
    border-radius: var(--radius-lg);
}

.auth-header {
    text-align: center;
    margin-bottom: 2rem;
}

.auth-header h2 {
    font-size: 2rem;
    font-weight: 700;
    color: var(--text-light);
    margin-bottom: 0.5rem;
}

.auth-tagline {
    color: var(--text-muted);
    font-size: 1rem;
}

/* Alerts */
.alert {
    padding: 1rem 1.5rem;
    border-radius: var(--radius-md);
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.75rem;
    font-size: 0.9rem;
}

.alert-error {
    background: rgba(239, 68, 68, 0.1);
    border: 1px solid rgba(239, 68, 68, 0.2);
    color: #ef4444;
}

.alert-success {
    background: rgba(34, 197, 94, 0.1);
    border: 1px solid rgba(34, 197, 94, 0.2);
    color: #22c55e;
}

.alert-icon {
    font-size: 1.1rem;
}

/* Form Styles */
.auth-form {
    margin-bottom: 2rem;
}

.password-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 0.5rem;
}

.forgot-link {
    font-size: 0.85rem;
    color: var(--primary-color);
    text-decoration: none;
    font-weight: 500;
    transition: var(--transition);
}

.forgot-link:hover {
    color: var(--primary-hover);
    text-decoration: underline;
}

.password-wrapper {
    position: relative;
}

.toggle-password {
    position: absolute;
    right: 0.75rem;
    top: 50%;
    transform: translateY(-50%);
    background: none;
    border: none;
    cursor: pointer;
    color: var(--text-muted);
    padding: 0.5rem;
    transition: var(--transition);
}

.toggle-password:hover {
    color: var(--primary-color);
}

.checkbox-label {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    cursor: pointer;
    font-size: 0.9rem;
    color: var(--text-muted);
    margin: 0;
}

.checkbox-label input[type="checkbox"] {
    width: 18px;
    height: 18px;
    accent-color: var(--primary-color);
    margin: 0;
}

.auth-divider {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin: 2rem 0;
}

.auth-divider::before,
.auth-divider::after {
    content: '';
    flex: 1;
    height: 1px;
    background: rgba(255,255,255,0.1);
}

.auth-divider span {
    color: var(--text-muted);
    font-size: 0.9rem;
    white-space: nowrap;
}

.auth-links {
    text-align: center;
}

/* Benefits Sidebar */
.auth-sidebar {
    position: sticky;
    top: 2rem;
}

.benefits-card {
    padding: 2rem;
}

.benefits-card h3 {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--text-light);
    margin-bottom: 1.5rem;
    text-align: center;
}

.benefits-list {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.benefit-item {
    display: flex;
    align-items: flex-start;
    gap: 1rem;
}

.benefit-icon {
    font-size: 2rem;
    flex-shrink: 0;
}

.benefit-content h4 {
    font-size: 1rem;
    font-weight: 600;
    color: var(--text-light);
    margin-bottom: 0.25rem;
}

.benefit-content p {
    font-size: 0.85rem;
    color: var(--text-muted);
    line-height: 1.4;
}

/* Loading State */
.btn.loading .btn-text {
    display: none;
}

.btn .spinner {
    display: none;
    width: 18px;
    height: 18px;
    border: 2px solid rgba(255,255,255,0.3);
    border-top-color: white;
    border-radius: 50%;
    animation: spin 0.6s linear infinite;
    margin: auto;
}

.btn.loading .spinner {
    display: block;
}

@keyframes spin {
    to {
        transform: rotate(360deg);
    }
}

/* Responsive */
@media (max-width: 768px) {
    .auth-wrapper {
        grid-template-columns: 1fr;
        gap: 2rem;
    }

    .auth-card {
        padding: 2rem;
    }

    .benefits-card {
        order: -1;
    }

    .benefits-list {
        gap: 1rem;
    }

    .benefit-item {
        flex-direction: column;
        text-align: center;
        gap: 0.5rem;
    }
}
</style>

<script>
// Password visibility toggle
function togglePasswordVisibility(inputId, button) {
    const input = document.getElementById(inputId);
    const eyeIcon = button.querySelector('.eye-icon');

    if (input.type === 'password') {
        input.type = 'text';
        eyeIcon.textContent = '🙈';
    } else {
        input.type = 'password';
        eyeIcon.textContent = '👁️';
    }
}

// Loading state
function setLoading(form) {
    const btn = form.querySelector('.btn');
    if (btn) {
        btn.classList.add('loading');
        btn.disabled = true;
    }
}
</script>

