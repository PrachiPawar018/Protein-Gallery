<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<script>
    window.csrfToken = '${sessionScope.csrf_token}';
</script>
<style>
    /* Navbar styles */
    .navbar {
        background-color: rgba(15, 23, 42, 0.95);
        backdrop-filter: blur(10px);
        position: sticky;
        top: 0;
        z-index: 100;
        padding: 1rem 2rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        border-bottom: 1px solid rgba(255,255,255,0.05);
    }
    .navbar-brand {
        font-weight: 900;
        font-size: 1.5rem;
        color: white;
        text-decoration: none;
    }
    .navbar-brand span {
        color: var(--primary-color);
    }
    .navbar-links {
        display: flex;
        align-items: center;
        gap: 1.5rem;
    }
    .navbar-links a {
        color: var(--text-light);
        text-decoration: none;
        font-weight: 600;
        transition: color 0.3s;
    }
    .navbar-links a:hover {
        color: var(--primary-color);
    }
    .search-bar {
        display: flex;
        align-items: center;
        background: var(--card-bg);
        border-radius: 20px;
        padding: 0.25rem 1rem;
        border: 1px solid rgba(255,255,255,0.1);
    }
    .search-bar input {
        background: transparent;
        border: none;
        color: white;
        padding: 0.5rem;
        outline: none;
        width: 200px;
    }
    .search-bar button {
        background: transparent;
        border: none;
        color: var(--primary-color);
        cursor: pointer;
        font-weight: bold;
    }
    @media (max-width: 768px) {
        .navbar {
            flex-direction: column;
            gap: 1rem;
            padding: 1rem;
        }
    }
</style>
<nav class="navbar">
    <a href="index.jsp" class="navbar-brand">PROTEIN<span>GALLERY</span></a>
    
    <form action="search" method="GET" class="search-bar">
        <input type="text" name="q" placeholder="Search supplements..." required>
        <button type="submit">SEARCH</button>
    </form>

    <div class="navbar-links">
        <a href="products">Shop All</a>
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <a href="cart.jsp" style="position:relative;">
                    Cart
                    <span id="cart-badge" style="display:none; position:absolute; top:-8px; right:-15px; background:var(--primary-color); color:white; border-radius:50%; padding:0.1rem 0.4rem; font-size:0.7rem; font-weight:bold;">0</span>
                </a>
                <a href="auth?action=logout">Logout (${sessionScope.user.name})</a>
            </c:when>
            <c:otherwise>
                <a href="login.jsp">Login</a>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<script src="${pageContext.request.contextPath}/js/cart.js"></script>
