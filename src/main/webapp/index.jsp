<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Protein Gallery - India's #1 Premium Fitness Store" />

<jsp:include page="WEB-INF/components/header.jsp" />

<!-- HERO BANNER -->
<section class="hero">
  <div class="hero-bg">
    <!-- Dark gradient overlay -->
  </div>
  <div class="hero-content">
    <div class="hero-text">
      <span class="hero-tag">
        🔥 India's #1 Protein Store
      </span>
      <h1 class="hero-title">
        Fuel Your <span>Fitness</span><br>
        Journey Today
      </h1>
      <p class="hero-subtitle">
        100% Authentic Supplements |
        Free Delivery above ₹999 |
        20+ Top Brands
      </p>
      <div class="hero-stats">
        <div class="stat">
          <span class="stat-number">50K+</span>
          <span class="stat-label">Happy Customers</span>
        </div>
        <div class="stat">
          <span class="stat-number">200+</span>
          <span class="stat-label">Products</span>
        </div>
        <div class="stat">
          <span class="stat-number">20+</span>
          <span class="stat-label">Top Brands</span>
        </div>
      </div>
      <div class="hero-actions">
        <a href="${pageContext.request.contextPath}/products" class="btn-primary">
          Shop Now →
        </a>
        <a href="#goals" class="btn-secondary">
          View Goals
        </a>
      </div>
    </div>
    <div class="hero-image">
      <!-- Floating product image with glow -->
      <div class="hero-product-card">
        <img src="${pageContext.request.contextPath}/images/hero-product.png"
             alt="Premium Protein"
             onerror="this.style.display='none'">
        <div class="hero-badge-float">
          ⚡ Best Seller
        </div>
      </div>
    </div>
  </div>

  <!-- Scroll indicator -->
  <div class="scroll-indicator">
    <div class="scroll-dot"></div>
  </div>
</section>

<!-- MARQUEE BRANDS BAR -->
<section class="brands-bar">
  <div class="marquee">
    <div class="marquee-track">
      ON • MuscleBlaze • Dymatize • GNC •
      HealthKart • Fast&Up • Absolute •
      MyProtein • BSN • Optimum Nutrition •
      ON • MuscleBlaze • Dymatize • GNC •
      (repeat for infinite scroll)
    </div>
  </div>
</section>

<!-- GOAL-BASED SHOPPING -->
<section class="goals-section" id="goals">
  <h2 class="section-title">
    Shop By Your <span>Goal</span>
  </h2>
  <p class="section-subtitle">
    Tell us what you want to achieve —
    we'll show you exactly what you need
  </p>

  <div class="goals-grid">

    <div class="goal-card"
         onclick="location.href='${pageContext.request.contextPath}/products?goal=muscle-gain'">
      <div class="goal-icon">💪</div>
      <div class="goal-glow muscle"></div>
      <h3>Muscle Gain</h3>
      <p>Build lean muscle mass with premium
         whey proteins and mass gainers</p>
      <div class="goal-products-count">
        48 Products →
      </div>
    </div>

    <div class="goal-card"
         onclick="location.href='${pageContext.request.contextPath}/products?goal=weight-loss'">
      <div class="goal-icon">🔥</div>
      <div class="goal-glow burn"></div>
      <h3>Weight Loss</h3>
      <p>Burn fat effectively with isolates,
         fat burners and lean proteins</p>
      <div class="goal-products-count">
        32 Products →
      </div>
    </div>

    <div class="goal-card"
         onclick="location.href='${pageContext.request.contextPath}/products?goal=beginner'">
      <div class="goal-icon">🌱</div>
      <div class="goal-glow beginner"></div>
      <h3>Beginner</h3>
      <p>Start your fitness journey right
         with beginner-friendly starter packs</p>
      <div class="goal-products-count">
        25 Products →
      </div>
    </div>

    <div class="goal-card"
         onclick="location.href='${pageContext.request.contextPath}/products?goal=endurance'">
      <div class="goal-icon">⚡</div>
      <div class="goal-glow endurance"></div>
      <h3>Endurance</h3>
      <p>Power through long workouts with
         pre-workouts and electrolytes</p>
      <div class="goal-products-count">
        28 Products →
      </div>
    </div>

  </div>
</section>

<!-- FEATURED PRODUCTS -->
<section class="featured-section">
  <h2 class="section-title">
    Featured <span>Products</span>
  </h2>
  <p class="section-subtitle">
    Handpicked premium supplements loved by our customers
  </p>

  <div class="products-grid">
    <!-- Dynamic products will be loaded here -->
    <c:forEach var="product" items="${featuredProducts}" begin="1" end="8">
      <jsp:include page="WEB-INF/components/product-card.jsp" />
    </c:forEach>

    <!-- Skeleton loading for demo -->
    <c:if test="${empty featuredProducts}">
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
    </c:if>
  </div>

  <div class="view-all-container">
    <a href="${pageContext.request.contextPath}/products" class="btn-primary">
      View All Products →
    </a>
  </div>
</section>

<!-- OFFERS BANNER -->
<section class="offers-banner">
  <div class="offer-card hot">
    <span class="offer-tag">⚡ LIMITED TIME</span>
    <h3>Use code <strong>SAVE20</strong></h3>
    <p>Get 20% OFF on orders above ₹1000</p>
    <a href="${pageContext.request.contextPath}/products" class="btn-primary">
      Claim Offer
    </a>
  </div>
  <div class="offer-card premium">
    <span class="offer-tag">🆕 NEW USER</span>
    <h3>Use code <strong>NEWUSER15</strong></h3>
    <p>15% OFF on your first order</p>
    <a href="${pageContext.request.contextPath}/register" class="btn-primary">
      Register Now
    </a>
  </div>
  <div class="offer-card bulk">
    <span class="offer-tag">📦 BULK ORDER</span>
    <h3>Use code <strong>BULK25</strong></h3>
    <p>25% OFF on orders above ₹3000</p>
    <a href="${pageContext.request.contextPath}/products" class="btn-primary">
      Shop Bulk
    </a>
  </div>
</section>

<!-- WHY CHOOSE US -->
<section class="why-choose-section">
  <h2 class="section-title">
    Why Choose <span>Protein Gallery</span>
  </h2>
  <p class="section-subtitle">
    We're committed to your fitness success
  </p>

  <div class="features-grid">
    <div class="feature-card">
      <div class="feature-icon">🏆</div>
      <h3>100% Authentic</h3>
      <p>Direct from brands, guaranteed genuine products with batch verification</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon">🚚</div>
      <h3>Free Delivery</h3>
      <p>On orders above ₹999. Fast, secure, and discreet shipping across India</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon">↩️</div>
      <h3>Easy Returns</h3>
      <p>7-day return policy. No questions asked, hassle-free exchanges</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon">💬</div>
      <h3>24/7 Support</h3>
      <p>Expert nutrition guidance and customer support whenever you need it</p>
    </div>
  </div>
</section>

<!-- BESTSELLERS -->
<section class="bestsellers-section">
  <h2 class="section-title">
    Customer <span>Favorites</span>
  </h2>
  <p class="section-subtitle">
    Most loved products by our fitness community
  </p>

  <div class="products-grid">
    <!-- Dynamic bestsellers will be loaded here -->
    <c:forEach var="product" items="${bestsellerProducts}" begin="1" end="8">
      <jsp:include page="WEB-INF/components/product-card.jsp" />
    </c:forEach>

    <!-- Skeleton loading -->
    <c:if test="${empty bestsellerProducts}">
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
      <div class="skeleton-card"></div>
    </c:if>
  </div>
</section>

<!-- TESTIMONIALS -->
<section class="testimonials-section">
  <h2 class="section-title">
    What Our <span>Customers Say</span>
  </h2>
  <p class="section-subtitle">
    Real stories from real fitness journeys
  </p>

  <div class="testimonials-grid">
    <div class="testimonial-card">
      <div class="stars">★★★★★</div>
      <p>"Protein Gallery has the best deals
         on ON Gold Standard. 100% authentic
         and super fast delivery!"</p>
      <div class="reviewer">
        <div class="reviewer-avatar">R</div>
        <div>
          <strong>Rahul Sharma</strong>
          <span>Mumbai ✓ Verified Buyer</span>
        </div>
      </div>
    </div>
    <div class="testimonial-card">
      <div class="stars">★★★★★</div>
      <p>"Amazing experience! Used NEWUSER15
         coupon and saved ₹450. Will definitely
         shop again!"</p>
      <div class="reviewer">
        <div class="reviewer-avatar">P</div>
        <div>
          <strong>Priya Patel</strong>
          <span>Pune ✓ Verified Buyer</span>
        </div>
      </div>
    </div>
    <div class="testimonial-card">
      <div class="stars">★★★★★</div>
      <p>"The beginner pack was perfect for me.
         Clear instructions, great quality,
         and fast shipping to Nashik!"</p>
      <div class="reviewer">
        <div class="reviewer-avatar">A</div>
        <div>
          <strong>Amit Desai</strong>
          <span>Nashik ✓ Verified Buyer</span>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- NEWSLETTER -->
<section class="newsletter">
  <div class="newsletter-content">
    <h2>Get <span>Exclusive Deals</span>
        in Your Inbox</h2>
    <p>Subscribe for offers, new arrivals,
       and fitness tips</p>
    <form class="newsletter-form"
          action="${pageContext.request.contextPath}/newsletter/subscribe"
          method="POST">
      <input type="hidden" name="csrf_token"
             value="${sessionScope.csrf_token}">
      <input type="email"
             placeholder="Enter your email..."
             required>
      <button type="submit" class="btn-primary">
        Subscribe 🔔
      </button>
    </form>
    <p class="newsletter-note">
      🔒 No spam. Unsubscribe anytime.
    </p>
  </div>
</section>

<style>
/* HERO STYLES */
.hero {
    min-height: 100vh;
    background: linear-gradient(
        135deg,
        #1A1A2E 0%,
        #16213E 50%,
        #0F3460 100%
    );
    position: relative;
    display: flex;
    align-items: center;
    overflow: hidden;
    padding-top: 70px;
}

.hero::before {
    content: '';
    position: absolute;
    top: -50%;
    right: -20%;
    width: 600px;
    height: 600px;
    background: radial-gradient(
        circle,
        rgba(255,107,53,0.15) 0%,
        transparent 70%
    );
    border-radius: 50%;
}

.hero::after {
    content: '';
    position: absolute;
    bottom: -20%;
    left: -10%;
    width: 400px;
    height: 400px;
    background: radial-gradient(
        circle,
        rgba(15,52,96,0.5) 0%,
        transparent 70%
    );
    border-radius: 50%;
}

.hero-content {
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 24px;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 60px;
    align-items: center;
    position: relative;
    z-index: 1;
}

.hero-tag {
    display: inline-block;
    background: rgba(255,107,53,0.15);
    border: 1px solid rgba(255,107,53,0.3);
    color: #FF6B35;
    padding: 8px 20px;
    border-radius: 50px;
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 24px;
    animation: pulse 3s infinite;
}

.hero-title {
    font-family: 'Montserrat', sans-serif;
    font-size: clamp(2.5rem, 5vw, 4rem);
    font-weight: 900;
    line-height: 1.1;
    margin-bottom: 20px;
}

.hero-title span { color: #FF6B35; }

.hero-subtitle {
    color: #B0B8C4;
    font-size: 1.1rem;
    margin-bottom: 32px;
    line-height: 1.8;
}

.hero-stats {
    display: flex;
    gap: 40px;
    margin-bottom: 40px;
}

.stat-number {
    display: block;
    font-family: 'Montserrat', sans-serif;
    font-size: 2rem;
    font-weight: 800;
    color: #FF6B35;
}

.stat-label {
    font-size: 13px;
    color: #B0B8C4;
}

.hero-actions {
    display: flex;
    gap: 16px;
    flex-wrap: wrap;
}

.hero-image {
    position: relative;
}

.hero-product-card {
    position: relative;
    max-width: 400px;
    background: rgba(255,255,255,0.05);
    border-radius: 20px;
    padding: 20px;
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255,107,53,0.2);
}

.hero-product-card img {
    width: 100%;
    height: auto;
    border-radius: 12px;
}

.hero-badge-float {
    position: absolute;
    top: -10px;
    right: -10px;
    background: #FF6B35;
    color: white;
    padding: 8px 16px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
    box-shadow: 0 4px 20px rgba(255,107,53,0.4);
}

.scroll-indicator {
    position: absolute;
    bottom: 30px;
    left: 50%;
    transform: translateX(-50%);
    animation: float 2s ease-in-out infinite;
}

.scroll-dot {
    width: 8px;
    height: 16px;
    background: #FF6B35;
    border-radius: 4px;
    margin: 0 auto;
}

/* BRANDS BAR */
.brands-bar {
    background: rgba(255,107,53,0.08);
    border-top: 1px solid rgba(255,107,53,0.15);
    border-bottom: 1px solid rgba(255,107,53,0.15);
    padding: 16px 0;
    overflow: hidden;
}

.marquee-track {
    display: flex;
    gap: 60px;
    animation: marquee 20s linear infinite;
    white-space: nowrap;
    color: #FF6B35;
    font-weight: 700;
    font-size: 14px;
    letter-spacing: 2px;
}

@keyframes marquee {
    from { transform: translateX(0); }
    to   { transform: translateX(-50%); }
}

/* GOALS SECTION */
.goals-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 24px;
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 24px;
}

.goal-card {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 20px;
    padding: 40px 32px;
    cursor: pointer;
    transition: all 0.4s ease;
    position: relative;
    overflow: hidden;
    text-align: center;
}

.goal-card:hover {
    transform: translateY(-8px);
    border-color: var(--primary);
    box-shadow: 0 20px 60px rgba(255,107,53,0.2);
}

.goal-icon {
    font-size: 48px;
    margin-bottom: 16px;
    animation: float 3s ease-in-out infinite;
}

.goal-card h3 {
    font-family: 'Montserrat', sans-serif;
    font-size: 1.4rem;
    font-weight: 700;
    margin-bottom: 12px;
}

.goal-card p {
    color: var(--text-secondary);
    font-size: 14px;
    line-height: 1.6;
    margin-bottom: 20px;
}

.goal-products-count {
    color: var(--primary);
    font-weight: 600;
    font-size: 14px;
}

.goal-glow {
    position: absolute;
    width: 150px;
    height: 150px;
    border-radius: 50%;
    top: -50px;
    right: -50px;
    opacity: 0.1;
}

.goal-glow.muscle   { background: #FF6B35; }
.goal-glow.burn     { background: #E74C3C; }
.goal-glow.beginner { background: #27AE60; }
.goal-glow.endurance{ background: #3498DB; }

/* PRODUCTS GRID */
.products-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 24px;
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 24px;
}

.view-all-container {
    text-align: center;
    margin-top: 40px;
}

/* OFFERS BANNER */
.offers-banner {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 24px;
    max-width: 1400px;
    margin: 0 auto;
    padding: 60px 24px;
}

.offer-card {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 32px;
    text-align: center;
    position: relative;
    overflow: hidden;
}

.offer-card.hot {
    border-color: #FF6B35;
    background: linear-gradient(135deg, rgba(255,107,53,0.05), rgba(255,107,53,0.02));
}

.offer-card.premium {
    border-color: #F4D03F;
    background: linear-gradient(135deg, rgba(244,208,63,0.05), rgba(244,208,63,0.02));
}

.offer-card.bulk {
    border-color: #27AE60;
    background: linear-gradient(135deg, rgba(39,174,96,0.05), rgba(39,174,96,0.02));
}

.offer-tag {
    display: inline-block;
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 700;
    margin-bottom: 16px;
}

.offer-card.hot .offer-tag { background: #FF6B35; color: white; }
.offer-card.premium .offer-tag { background: #F4D03F; color: #1A1A2E; }
.offer-card.bulk .offer-tag { background: #27AE60; color: white; }

.offer-card h3 {
    font-family: 'Montserrat', sans-serif;
    font-size: 1.5rem;
    margin-bottom: 12px;
}

.offer-card p {
    color: var(--text-secondary);
    margin-bottom: 24px;
}

/* FEATURES GRID */
.why-choose-section {
    padding: 80px 0;
}

.features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 32px;
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 24px;
}

.feature-card {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 32px;
    text-align: center;
    transition: all 0.3s ease;
}

.feature-card:hover {
    transform: translateY(-4px);
    border-color: var(--primary);
    box-shadow: 0 8px 32px rgba(255,107,53,0.15);
}

.feature-icon {
    font-size: 48px;
    margin-bottom: 16px;
}

.feature-card h3 {
    font-family: 'Montserrat', sans-serif;
    font-size: 1.3rem;
    margin-bottom: 12px;
}

.feature-card p {
    color: var(--text-secondary);
    font-size: 14px;
    line-height: 1.6;
}

/* TESTIMONIALS */
.testimonials-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 24px;
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 24px;
}

.testimonial-card {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 32px;
    position: relative;
}

.stars {
    color: #F4D03F;
    font-size: 16px;
    margin-bottom: 16px;
}

.testimonial-card p {
    color: var(--text-secondary);
    font-size: 15px;
    line-height: 1.6;
    margin-bottom: 24px;
    font-style: italic;
}

.reviewer {
    display: flex;
    align-items: center;
    gap: 12px;
}

.reviewer-avatar {
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, #FF6B35, #E55A25);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    color: white;
}

.reviewer strong {
    display: block;
    color: white;
    font-size: 14px;
}

.reviewer span {
    color: var(--text-secondary);
    font-size: 12px;
}

/* NEWSLETTER */
.newsletter {
    background: linear-gradient(135deg, #1A1A2E, #16213E);
    padding: 80px 0;
    text-align: center;
}

.newsletter-content {
    max-width: 600px;
    margin: 0 auto;
    padding: 0 24px;
}

.newsletter h2 {
    font-family: 'Montserrat', sans-serif;
    font-size: 2.5rem;
    margin-bottom: 16px;
}

.newsletter h2 span { color: #FF6B35; }

.newsletter p {
    color: var(--text-secondary);
    font-size: 1.1rem;
    margin-bottom: 32px;
}

.newsletter-form {
    display: flex;
    gap: 12px;
    margin-bottom: 16px;
    flex-wrap: wrap;
    justify-content: center;
}

.newsletter-form input {
    flex: 1;
    min-width: 250px;
    padding: 14px 20px;
    border: 2px solid var(--border);
    border-radius: 50px;
    background: var(--input-bg);
    color: white;
    font-size: 16px;
}

.newsletter-form input:focus {
    outline: none;
    border-color: #FF6B35;
}

.newsletter-note {
    color: var(--text-secondary);
    font-size: 14px;
}

/* SKELETON LOADING */
.skeleton-card {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 16px;
    height: 350px;
    animation: shimmer 2s infinite;
}

@keyframes shimmer {
    0% { opacity: 0.5; }
    50% { opacity: 1; }
    100% { opacity: 0.5; }
}

/* RESPONSIVE */
@media (max-width: 1200px) {
    .goals-grid { grid-template-columns: repeat(2, 1fr); }
    .hero-content { gap: 40px; }
}

@media (max-width: 768px) {
    .hero-content {
        grid-template-columns: 1fr;
        text-align: center;
    }
    .hero-stats { justify-content: center; }
    .hero-actions { justify-content: center; }
    .goals-grid { grid-template-columns: repeat(2, 1fr); }
    .hero-title { font-size: 2rem; }
    .hero-stats {
        flex-direction: column;
        gap: 16px;
    }
    .offers-banner { grid-template-columns: 1fr; }
    .newsletter-form { flex-direction: column; }
    .newsletter-form input { min-width: auto; }
}

@media (max-width: 480px) {
    .goals-grid { grid-template-columns: 1fr; }
    .products-grid { grid-template-columns: 1fr; }
    .testimonials-grid { grid-template-columns: 1fr; }
    .features-grid { grid-template-columns: 1fr; }
}
</style>

<jsp:include page="WEB-INF/components/footer.jsp" />

<jsp:include page="WEB-INF/components/footer.jsp" />
            font-size: 2.5rem;
            color: white;
            font-weight: 900;
        }
        .goals-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }
        .goal-card {
            background-color: var(--card-bg);
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 16px;
            padding: 3rem 2rem;
            text-align: center;
            transition: transform 0.3s, border-color 0.3s, box-shadow 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: white;
            display: block;
        }
        .goal-card:hover {
            transform: translateY(-10px);
            border-color: var(--primary-color);
            box-shadow: 0 10px 30px rgba(249, 115, 22, 0.2);
        }
        .goal-card h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            font-size: 1.75rem;
            font-weight: 700;
        }
        .goal-card p {
            color: var(--text-muted);
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <jsp:include page="WEB-INF/components/navbar.jsp" />

    <div class="hero">
        <h1>Fuel Your <span>Ambition</span></h1>
        <p>Premium sports nutrition and supplements tailored to your specific fitness goals. High-quality ingredients, uncompromising results.</p>
        <a href="products" class="btn-primary">Shop All Products</a>
    </div>

    <div class="goals-section">
        <h2>Shop By Your Goal</h2>
        <div class="goals-grid">
            <a href="products?goal=muscle-gain" class="goal-card">
                <h3>Muscle Gain</h3>
                <p>Whey, Mass Gainers & Creatine</p>
            </a>
            <a href="products?goal=weight-loss" class="goal-card">
                <h3>Weight Loss</h3>
                <p>Fat Burners & Lean Protein</p>
            </a>
            <a href="products?goal=endurance" class="goal-card">
                <h3>Endurance</h3>
                <p>Pre-workouts & BCAAs</p>
            </a>
            <a href="products?goal=beginner" class="goal-card">
                <h3>Beginner</h3>
                <p>Starter Stacks & Essentials</p>
            </a>
        </div>
    </div>
</body>
</html>
