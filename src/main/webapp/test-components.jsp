<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="pageTitle" value="Component Test - Protein Gallery" />

<jsp:include page="WEB-INF/components/header.jsp" />

    <!-- Test Section -->
    <section class="section">
        <div class="container">
            <h1>Component Test Page</h1>
            <p>This page tests all the new components we've created.</p>

            <!-- Test Product Cards -->
            <h2>Product Cards</h2>
            <div class="products-grid">
                <jsp:include page="WEB-INF/components/product-card.jsp">
                    <jsp:param name="product" value="${testProduct1}" />
                </jsp:include>
                <jsp:include page="WEB-INF/components/product-card.jsp">
                    <jsp:param name="product" value="${testProduct2}" />
                </jsp:include>
            </div>

            <!-- Test Toast -->
            <h2>Toast Notifications</h2>
            <button onclick="showSuccess('Success message!')">Show Success Toast</button>
            <button onclick="showError('Error message!')">Show Error Toast</button>
            <button onclick="showInfo('Info message!')">Show Info Toast</button>
        </div>
    </section>

<jsp:include page="WEB-INF/components/footer.jsp" />

<style>
.products-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 2rem;
    margin: 2rem 0;
}

button {
    margin: 0.5rem;
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: 600;
}

button:nth-child(1) { background: var(--success); color: white; }
button:nth-child(2) { background: var(--danger); color: white; }
button:nth-child(3) { background: var(--info); color: white; }
</style>