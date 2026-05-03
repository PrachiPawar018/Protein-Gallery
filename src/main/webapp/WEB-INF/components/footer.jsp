<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

    </main>

    <!-- Footer -->
    <footer class="footer">

      <!-- Main footer -->
      <div class="footer-main">
        <div class="footer-grid">

          <!-- Brand column -->
          <div class="footer-brand">
            <div class="footer-logo">
              🏋️ PROTEIN <span>GALLERY</span>
            </div>
            <p>India's trusted store for 100% authentic
               fitness supplements. We are committed to
               fueling your fitness journey with the best
               products at the best prices.</p>
            <div class="footer-social">
              <a href="#" class="social-btn">📘</a>
              <a href="#" class="social-btn">📸</a>
              <a href="#" class="social-btn">▶️</a>
              <a href="#" class="social-btn">🐦</a>
              <a href="#" class="social-btn">💼</a>
            </div>
            <div class="footer-payment">
              <span>We Accept:</span>
              <img src="${pageContext.request.contextPath}/images/razorpay-badge.png"
                   alt="Razorpay">
              <span>UPI • Cards • NetBanking • Wallets</span>
            </div>
          </div>

          <!-- Quick Links -->
          <div class="footer-col">
            <h4>Quick Links</h4>
            <ul>
              <li><a href="${pageContext.request.contextPath}/">🏠 Home</a></li>
              <li><a href="${pageContext.request.contextPath}/products">🛍️ All Products</a></li>
              <li><a href="${pageContext.request.contextPath}/products?offer=true">
                🔥 Offers & Deals
              </a></li>
              <li><a href="${pageContext.request.contextPath}/about">ℹ️ About Us</a></li>
              <li><a href="${pageContext.request.contextPath}/contact">📞 Contact Us</a></li>
              <li><a href="${pageContext.request.contextPath}/blog">📝 Fitness Blog</a></li>
            </ul>
          </div>

          <!-- Categories -->
          <div class="footer-col">
            <h4>Categories</h4>
            <ul>
              <li><a href="${pageContext.request.contextPath}/products?category=Whey+Protein">
                🥛 Whey Protein
              </a></li>
              <li><a href="${pageContext.request.contextPath}/products?category=Mass+Gainer">
                💪 Mass Gainer
              </a></li>
              <li><a href="${pageContext.request.contextPath}/products?category=Creatine">
                ⚗️ Creatine
              </a></li>
              <li><a href="${pageContext.request.contextPath}/products?category=Pre-Workout">
                ⚡ Pre-Workout
              </a></li>
              <li><a href="${pageContext.request.contextPath}/products?category=Vitamins">
                💊 Vitamins
              </a></li>
              <li><a href="${pageContext.request.contextPath}/products?category=Combo">
                📦 Combo Packs
              </a></li>
            </ul>
          </div>

          <!-- My Account -->
          <div class="footer-col">
            <h4>My Account</h4>
            <ul>
              <li><a href="${pageContext.request.contextPath}/login">🔑 Login</a></li>
              <li><a href="${pageContext.request.contextPath}/register">📝 Register</a></li>
              <li><a href="${pageContext.request.contextPath}/profile">👤 My Profile</a></li>
              <li><a href="${pageContext.request.contextPath}/order/history">
                📦 My Orders
              </a></li>
              <li><a href="${pageContext.request.contextPath}/wishlist">♡ Wishlist</a></li>
              <li><a href="${pageContext.request.contextPath}/cart">🛒 Cart</a></li>
            </ul>
          </div>

          <!-- Contact -->
          <div class="footer-col">
            <h4>Contact Us</h4>
            <div class="footer-contact">
              <div class="contact-item">
                <span>📧</span>
                <span>support@proteingallery.com</span>
              </div>
              <div class="contact-item">
                <span>📞</span>
                <span>+91 98765 43210</span>
              </div>
              <div class="contact-item">
                <span>📍</span>
                <span>Nashik, Maharashtra, India</span>
              </div>
              <div class="contact-item">
                <span>🕐</span>
                <span>Mon-Sat: 9AM - 8PM</span>
              </div>
            </div>
            <div class="footer-trust">
              <span>🔒 100% Secure</span>
              <span>✅ Authentic</span>
              <span>🚚 Fast Delivery</span>
            </div>
          </div>

        </div>
      </div>

      <!-- Footer bottom bar -->
      <div class="footer-bottom">
        <div class="footer-bottom-content">
          <p>
            © 2024 Protein Gallery.
            All Rights Reserved.
            Made with ❤️ in India 🇮🇳
          </p>
          <div class="footer-legal">
            <a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a>
            <a href="${pageContext.request.contextPath}/terms">Terms of Service</a>
            <a href="${pageContext.request.contextPath}/shipping">Shipping Policy</a>
            <a href="${pageContext.request.contextPath}/returns">Return Policy</a>
          </div>
        </div>
      </div>

    </footer>

    <!-- Toast Container -->
    <div id="toast-container"></div>

    <!-- Back to Top Button -->
    <button id="backToTop" class="back-to-top">↑</button>

    <!-- Global JavaScript -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/js/toast.js"></script>

    <c:if test="${not empty sessionScope.user}">
        <script src="${pageContext.request.contextPath}/js/cart.js"></script>
    </c:if>

    <script>
    // Back to Top functionality
    window.addEventListener('scroll', () => {
        const btn = document.getElementById('backToTop');
        if (window.scrollY > 400) {
            btn.classList.add('visible');
        } else {
            btn.classList.remove('visible');
        }
    });

    document.getElementById('backToTop')
      .addEventListener('click', () => {
        window.scrollTo({ top: 0, behavior: 'smooth' });
    });
    </script>

<style>
.footer {
    background: #0D0D1A;
    border-top: 1px solid rgba(255,107,53,0.2);
    margin-top: 80px;
}

.footer-main {
    max-width: 1400px;
    margin: 0 auto;
    padding: 60px 24px;
}

.footer-grid {
    display: grid;
    grid-template-columns: 2fr 1fr 1fr 1fr 1.5fr;
    gap: 40px;
}

.footer-logo {
    font-family: 'Montserrat', sans-serif;
    font-size: 20px;
    font-weight: 800;
    margin-bottom: 16px;
    letter-spacing: 1px;
}

.footer-logo span { color: #FF6B35; }

.footer-brand p {
    color: #B0B8C4;
    font-size: 14px;
    line-height: 1.7;
    margin-bottom: 20px;
}

.footer-social {
    display: flex;
    gap: 8px;
    margin-bottom: 20px;
}

.social-btn {
    width: 40px;
    height: 40px;
    background: rgba(255,255,255,0.05);
    border: 1px solid rgba(255,255,255,0.1);
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
    font-size: 16px;
    transition: all 0.3s ease;
}

.social-btn:hover {
    background: rgba(255,107,53,0.15);
    border-color: rgba(255,107,53,0.3);
    transform: translateY(-3px);
}

.footer-col h4 {
    font-family: 'Montserrat', sans-serif;
    font-size: 14px;
    font-weight: 700;
    letter-spacing: 1px;
    text-transform: uppercase;
    color: #FF6B35;
    margin-bottom: 20px;
}

.footer-col ul { list-style: none; }

.footer-col ul li { margin-bottom: 12px; }

.footer-col ul li a {
    color: #B0B8C4;
    text-decoration: none;
    font-size: 14px;
    transition: all 0.3s ease;
    display: inline-block;
}

.footer-col ul li a:hover {
    color: #FF6B35;
    padding-left: 6px;
}

.contact-item {
    display: flex;
    gap: 10px;
    color: #B0B8C4;
    font-size: 14px;
    margin-bottom: 12px;
    align-items: flex-start;
}

.footer-trust {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
    margin-top: 16px;
}

.footer-trust span {
    font-size: 12px;
    color: #27AE60;
    font-weight: 600;
}

.footer-bottom {
    border-top: 1px solid rgba(255,255,255,0.05);
    padding: 20px 24px;
}

.footer-bottom-content {
    max-width: 1400px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
}

.footer-bottom p {
    color: #B0B8C4;
    font-size: 13px;
}

.footer-legal {
    display: flex;
    gap: 20px;
}

.footer-legal a {
    color: #B0B8C4;
    text-decoration: none;
    font-size: 13px;
    transition: color 0.3s;
}

.footer-legal a:hover { color: #FF6B35; }

@media (max-width: 1024px) {
    .footer-grid {
        grid-template-columns: 1fr 1fr;
    }
}

@media (max-width: 600px) {
    .footer-grid {
        grid-template-columns: 1fr;
    }
    .footer-bottom-content {
        flex-direction: column;
        text-align: center;
    }
}
</style>

</body>
</html>