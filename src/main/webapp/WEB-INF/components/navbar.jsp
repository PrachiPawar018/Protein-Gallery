<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<nav class="navbar" id="navbar">
  <div class="nav-container">

    <!-- Logo -->
    <a href="${pageContext.request.contextPath}/" class="nav-logo">
      <span class="logo-icon">🏋️</span>
      <span class="logo-text">
        PROTEIN <span class="logo-accent">GALLERY</span>
      </span>
    </a>

    <!-- Center Links -->
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/" class="nav-link ${pageContext.request.servletPath == '/index.jsp' ? 'active' : ''}">Home</a></li>
      <li><a href="${pageContext.request.contextPath}/products" class="nav-link">Products</a></li>
      <li class="nav-dropdown">
        <a href="#" class="nav-link">
          Goals ▾
        </a>
        <div class="dropdown-menu">
          <a href="${pageContext.request.contextPath}/products?goal=muscle-gain">
            💪 Muscle Gain
          </a>
          <a href="${pageContext.request.contextPath}/products?goal=weight-loss">
            🔥 Weight Loss
          </a>
          <a href="${pageContext.request.contextPath}/products?goal=beginner">
            🌱 Beginner
          </a>
          <a href="${pageContext.request.contextPath}/products?goal=endurance">
            ⚡ Endurance
          </a>
        </div>
      </li>
      <li><a href="${pageContext.request.contextPath}/products?offer=true"
             class="nav-link">
        <span class="nav-badge">HOT</span> Offers
      </a></li>
      <li><a href="${pageContext.request.contextPath}/about" class="nav-link">About</a></li>
    </ul>

    <!-- Right Icons -->
    <div class="nav-actions">
      <button class="nav-icon-btn" id="searchToggle">
        🔍
      </button>
      <a href="${pageContext.request.contextPath}/wishlist" class="nav-icon-btn">
        ♡ <span class="wishlist-count">0</span>
      </a>
      <a href="${pageContext.request.contextPath}/cart" class="nav-icon-btn cart-btn">
        🛒
        <span class="cart-count badge badge-orange">
          ${sessionScope.cartCount != null ?
            sessionScope.cartCount : 0}
        </span>
      </a>

      <!-- If not logged in -->
      <c:if test="${sessionScope.user == null}">
        <a href="${pageContext.request.contextPath}/login" class="btn-primary nav-cta">
          Login
        </a>
      </c:if>

      <!-- If logged in -->
      <c:if test="${sessionScope.user != null}">
        <div class="user-menu">
          <div class="user-avatar">
            ${fn:substring(sessionScope.user.name,0,1)}
          </div>
          <div class="user-dropdown">
            <a href="${pageContext.request.contextPath}/profile">👤 My Profile</a>
            <a href="${pageContext.request.contextPath}/order/history">📦 My Orders</a>
            <a href="${pageContext.request.contextPath}/wishlist">♡ Wishlist</a>
            <hr>
            <a href="${pageContext.request.contextPath}/auth/logout" class="logout-link">
              🚪 Logout
            </a>
          </div>
        </div>
      </c:if>

      <!-- Mobile Hamburger -->
      <button class="hamburger" id="hamburger">
        <span></span>
        <span></span>
        <span></span>
      </button>
    </div>
  </div>

  <!-- Search Bar (Hidden by default) -->
  <div class="search-bar-expanded" id="searchBar">
    <form action="${pageContext.request.contextPath}/products" method="GET">
      <input type="hidden" name="csrf_token" value="${sessionScope.csrf_token}">
      <input type="text"
             name="search"
             placeholder="Search proteins, brands, goals..."
             class="search-input-expanded"
             required>
      <button type="submit" class="search-submit">🔍</button>
    </form>
    <button class="search-close" id="searchClose">✕</button>
  </div>
</nav>

<!-- Mobile Menu Overlay -->
<div class="mobile-overlay" id="mobileOverlay">
  <div class="mobile-menu">
    <ul>
      <li><a href="${pageContext.request.contextPath}/">🏠 Home</a></li>
      <li><a href="${pageContext.request.contextPath}/products">🛍️ Products</a></li>
      <li><a href="${pageContext.request.contextPath}/products?goal=muscle-gain">
        💪 Muscle Gain
      </a></li>
      <li><a href="${pageContext.request.contextPath}/products?goal=weight-loss">
        🔥 Weight Loss
      </a></li>
      <li><a href="${pageContext.request.contextPath}/products?goal=beginner">
        🌱 Beginner
      </a></li>
      <li><a href="${pageContext.request.contextPath}/cart">🛒 Cart</a></li>
      <li><a href="${pageContext.request.contextPath}/profile">👤 Profile</a></li>
      <li><a href="${pageContext.request.contextPath}/auth/logout">🚪 Logout</a></li>
    </ul>
  </div>
</div>

<style>
.navbar {
    position: fixed;
    top: 0;
    width: 100%;
    z-index: 1000;
    background: rgba(26, 26, 46, 0.95);
    backdrop-filter: blur(20px);
    border-bottom: 1px solid rgba(255,107,53,0.15);
    transition: all 0.3s ease;
    height: 70px;
    display: flex;
    align-items: center;
}

.navbar.scrolled {
    box-shadow: 0 4px 30px rgba(0,0,0,0.5);
    background: rgba(26, 26, 46, 0.98);
}

.navbar.hidden {
    transform: translateY(-100%);
}

.nav-container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 24px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    width: 100%;
}

.nav-logo {
    display: flex;
    align-items: center;
    gap: 10px;
    text-decoration: none;
    font-family: 'Montserrat', sans-serif;
    font-weight: 800;
    font-size: 20px;
    color: white;
    letter-spacing: 1px;
}

.logo-accent { color: #FF6B35; }

.nav-links {
    display: flex;
    list-style: none;
    gap: 8px;
    align-items: center;
}

.nav-link {
    color: #B0B8C4;
    text-decoration: none;
    padding: 8px 16px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.3s ease;
    position: relative;
}

.nav-link:hover,
.nav-link.active {
    color: #FF6B35;
    background: rgba(255,107,53,0.1);
}

.nav-badge {
    background: #FF6B35;
    color: white;
    padding: 2px 6px;
    border-radius: 4px;
    font-size: 10px;
    font-weight: 700;
    margin-right: 4px;
    animation: pulse 2s infinite;
}

/* Dropdown */
.nav-dropdown { position: relative; }

.dropdown-menu {
    position: absolute;
    top: calc(100% + 10px);
    left: 0;
    background: #1E1E3A;
    border: 1px solid rgba(255,107,53,0.2);
    border-radius: 12px;
    padding: 8px;
    min-width: 200px;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.3s ease;
    box-shadow: 0 20px 60px rgba(0,0,0,0.5);
}

.nav-dropdown:hover .dropdown-menu {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.dropdown-menu a {
    display: block;
    padding: 10px 16px;
    color: #B0B8C4;
    text-decoration: none;
    border-radius: 8px;
    font-size: 14px;
    transition: all 0.2s ease;
}

.dropdown-menu a:hover {
    background: rgba(255,107,53,0.1);
    color: #FF6B35;
    padding-left: 20px;
}

/* Nav Actions */
.nav-actions {
    display: flex;
    align-items: center;
    gap: 8px;
}

.nav-icon-btn {
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.1);
    color: #B0B8C4;
    width: 40px;
    height: 40px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
    font-size: 16px;
    position: relative;
}

.nav-icon-btn:hover {
    background: rgba(255,107,53,0.1);
    border-color: rgba(255,107,53,0.3);
    color: #FF6B35;
}

.cart-count {
    position: absolute;
    top: -6px;
    right: -6px;
    background: #FF6B35;
    color: white;
    width: 18px;
    height: 18px;
    border-radius: 50%;
    font-size: 10px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* User Avatar */
.user-menu { position: relative; }

.user-avatar {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, #FF6B35, #E55A25);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 16px;
    cursor: pointer;
    box-shadow: 0 0 15px rgba(255,107,53,0.3);
}

.user-dropdown {
    position: absolute;
    top: calc(100% + 10px);
    right: 0;
    background: #1E1E3A;
    border: 1px solid rgba(255,107,53,0.2);
    border-radius: 12px;
    padding: 8px;
    min-width: 180px;
    opacity: 0;
    visibility: hidden;
    transition: all 0.3s ease;
    box-shadow: 0 20px 60px rgba(0,0,0,0.5);
}

.user-menu:hover .user-dropdown {
    opacity: 1;
    visibility: visible;
}

.user-dropdown a {
    display: block;
    padding: 10px 16px;
    color: #B0B8C4;
    text-decoration: none;
    border-radius: 8px;
    font-size: 14px;
    transition: all 0.2s ease;
}

.user-dropdown a:hover {
    background: rgba(255,107,53,0.1);
    color: #FF6B35;
}

.logout-link { color: #E74C3C !important; }
.logout-link:hover {
    background: rgba(231,76,60,0.1) !important;
}

/* Hamburger */
.hamburger {
    display: none;
    flex-direction: column;
    gap: 5px;
    background: none;
    border: none;
    cursor: pointer;
    padding: 8px;
}

.hamburger span {
    width: 24px;
    height: 2px;
    background: white;
    border-radius: 2px;
    transition: all 0.3s ease;
}

.hamburger.active span:nth-child(1) {
    transform: rotate(45deg) translate(5px, 5px);
}
.hamburger.active span:nth-child(2) {
    opacity: 0;
}
.hamburger.active span:nth-child(3) {
    transform: rotate(-45deg) translate(5px, -5px);
}

/* Search Bar */
.search-bar-expanded {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: rgba(26,26,46,0.98);
    backdrop-filter: blur(20px);
    border-bottom: 1px solid rgba(255,107,53,0.15);
    padding: 16px 24px;
    display: none;
    align-items: center;
    gap: 16px;
}

.search-bar-expanded form {
    flex: 1;
    display: flex;
    align-items: center;
    gap: 12px;
}

.search-input-expanded {
    flex: 1;
    background: var(--input-bg);
    border: 2px solid rgba(255,107,53,0.2);
    border-radius: 25px;
    padding: 12px 20px;
    color: white;
    font-size: 16px;
    outline: none;
    transition: all 0.3s ease;
}

.search-input-expanded:focus {
    border-color: #FF6B35;
    box-shadow: 0 0 20px rgba(255,107,53,0.3);
}

.search-submit {
    background: linear-gradient(135deg, #FF6B35, #E55A25);
    border: none;
    color: white;
    padding: 12px 20px;
    border-radius: 25px;
    cursor: pointer;
    font-weight: 700;
    transition: all 0.3s ease;
}

.search-submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 20px rgba(255,107,53,0.4);
}

.search-close {
    background: none;
    border: none;
    color: #B0B8C4;
    font-size: 20px;
    cursor: pointer;
    padding: 8px;
    transition: color 0.3s ease;
}

.search-close:hover {
    color: #FF6B35;
}

/* Mobile Menu */
.mobile-overlay {
    position: fixed;
    inset: 0;
    background: rgba(26,26,46,0.98);
    z-index: 999;
    display: none;
    padding: 100px 32px 32px;
}

.mobile-overlay.active { display: block; }

.mobile-menu ul { list-style: none; }

.mobile-menu ul li a {
    display: block;
    padding: 16px 0;
    font-size: 20px;
    font-weight: 600;
    color: white;
    text-decoration: none;
    border-bottom: 1px solid rgba(255,255,255,0.05);
    transition: color 0.3s;
}

.mobile-menu ul li a:hover { color: #FF6B35; }

@media (max-width: 768px) {
    .nav-links { display: none; }
    .hamburger { display: flex; }
    .nav-cta { display: none; }
}
</style>

<script>
// Scroll behavior
let lastScroll = 0;
const navbar = document.getElementById('navbar');

window.addEventListener('scroll', () => {
    const current = window.scrollY;

    if (current > 100) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }

    if (current > lastScroll && current > 200) {
        navbar.classList.add('hidden');
    } else {
        navbar.classList.remove('hidden');
    }
    lastScroll = current;
});

// Search toggle
document.getElementById('searchToggle')
  .addEventListener('click', () => {
    document.getElementById('searchBar')
      .style.display = 'flex';
    document.querySelector('.search-input-expanded')
      .focus();
});

document.getElementById('searchClose')
  .addEventListener('click', () => {
    document.getElementById('searchBar')
      .style.display = 'none';
});

// Hamburger
document.getElementById('hamburger')
  .addEventListener('click', () => {
    document.getElementById('hamburger')
      .classList.toggle('active');
    document.getElementById('mobileOverlay')
      .classList.toggle('active');
    document.body.style.overflow =
      document.getElementById('mobileOverlay')
        .classList.contains('active') ?
        'hidden' : '';
});
</script>
