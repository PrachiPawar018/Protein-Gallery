<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="pageTitle" value="Server Error - Protein Gallery" />

<jsp:include page="WEB-INF/components/header.jsp" />

<div class="container">
    <div class="error-page">
        <div class="error-content">
            <h1>500 - Internal Server Error</h1>
            <p>Sorry, something went wrong on our end. Please try again later.</p>

            <div class="error-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                    🏠 Go Home
                </a>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline">
                    🛍️ Continue Shopping
                </a>
            </div>

            <c:if test="${not empty pageContext.errorData}">
                <details class="error-details">
                    <summary>Technical Details (for developers)</summary>
                    <p><strong>Status Code:</strong> ${pageContext.errorData.statusCode}</p>
                    <p><strong>Request URI:</strong> ${pageContext.errorData.requestURI}</p>
                    <p><strong>Servlet Name:</strong> ${pageContext.errorData.servletName}</p>
                </details>
            </c:if>
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
    color: var(--error-color, #dc3545);
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

.error-details {
    background: var(--bg-secondary);
    padding: 1rem;
    border-radius: 8px;
    text-align: left;
    max-width: 600px;
    margin: 0 auto;
}

.error-details summary {
    cursor: pointer;
    font-weight: 600;
}

.error-details p {
    margin: 0.5rem 0;
    font-family: monospace;
    font-size: 0.9rem;
}
</style>

<jsp:include page="WEB-INF/components/footer.jsp" />