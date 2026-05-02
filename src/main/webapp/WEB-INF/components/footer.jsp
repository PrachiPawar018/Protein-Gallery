<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-section">
                <h3>Protein Gallery</h3>
                <p>Your trusted source for premium sports nutrition and fitness supplements. Quality ingredients, proven results.</p>
                <div class="social-links">
                    <a href="#" class="social-link">📘 Facebook</a>
                    <a href="#" class="social-link">📷 Instagram</a>
                    <a href="#" class="social-link">🐦 Twitter</a>
                    <a href="#" class="social-link">📧 Newsletter</a>
                </div>
            </div>

            <div class="footer-section">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/products">Shop All Products</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?goal=muscle-gain">Muscle Gain</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?goal=weight-loss">Weight Loss</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?goal=endurance">Endurance</a></li>
                    <li><a href="${pageContext.request.contextPath}/products?goal=beginner">Beginner Guide</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h4>Customer Service</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/shipping">Shipping Info</a></li>
                    <li><a href="${pageContext.request.contextPath}/returns">Returns & Exchanges</a></li>
                    <li><a href="${pageContext.request.contextPath}/faq">FAQ</a></li>
                    <li><a href="${pageContext.request.contextPath}/size-guide">Size Guide</a></li>
                </ul>
            </div>

            <div class="footer-section">
                <h4>Account</h4>
                <ul>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li><a href="${pageContext.request.contextPath}/profile">My Profile</a></li>
                            <li><a href="${pageContext.request.contextPath}/orders">Order History</a></li>
                            <li><a href="${pageContext.request.contextPath}/cart">Shopping Cart</a></li>
                            <li><a href="${pageContext.request.contextPath}/auth?action=logout">Logout</a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
                            <li><a href="${pageContext.request.contextPath}/register.jsp">Create Account</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>

        <div class="footer-bottom">
            <div class="footer-bottom-content">
                <p>&copy; 2024 Protein Gallery. All rights reserved.</p>
                <div class="footer-links">
                    <a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a>
                    <a href="${pageContext.request.contextPath}/terms">Terms of Service</a>
                    <a href="${pageContext.request.contextPath}/cookies">Cookie Policy</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Toast Notifications -->
    <jsp:include page="toast.jsp" />

    <!-- Global JavaScript -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>

    <c:if test="${not empty sessionScope.user}">
        <script src="${pageContext.request.contextPath}/js/cart.js"></script>
    </c:if>
</body>
</html>