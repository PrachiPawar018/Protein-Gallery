<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="pageTitle" value="Page Not Found - Protein Gallery" />

<jsp:include page="WEB-INF/components/header.jsp" />

<div class="container">
    <div class="error-page">
        <div class="error-content">
            <h1>404 - Page Not Found</h1>
            <p>The page you're looking for doesn't exist or has been moved.</p>

            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    🏠 Go Home
                </a>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline">
                    🛍️ Browse Products
                </a>
            </div>

            <div class="search-suggestions">
                <h3>Popular Pages:</h3>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/products">All Products</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?goal=muscle-gain">Muscle Gain Supplements</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?goal=weight-loss">Weight Loss Products</a></li>
                    <li><a href="${pageContext.request.contextPath}/cart">Shopping Cart</a></li>
                    <li><a href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<style>
.error-page {
    min-height: 60vh;
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
}

.error-content h1 {
    font-size: 3rem;
    color: var(--warning-color, #ffc107);
    margin-bottom: 1rem;
}

.error-content p {
    font-size: 1.2rem;
    color: var(--text-secondary);
    margin-bottom: 2rem;
}

.error-actions {
    display: flex;
    gap: 1rem;
    justify-content: center;
    margin-bottom: 2rem;
}

.search-suggestions {
    background: var(--bg-secondary);
    padding: 2rem;
    border-radius: 12px;
    max-width: 500px;
    margin: 0 auto;
}

.search-suggestions h3 {
    margin-bottom: 1rem;
    color: var(--text-primary);
}

.search-suggestions ul {
    list-style: none;
    padding: 0;
}

.search-suggestions li {
    margin-bottom: 0.5rem;
}

.search-suggestions a {
    color: var(--primary-color);
    text-decoration: none;
    padding: 0.5rem;
    display: block;
    border-radius: 6px;
    transition: background-color 0.2s;
}

.search-suggestions a:hover {
    background: var(--bg-hover);
}
</style>

<jsp:include page="WEB-INF/components/footer.jsp" />