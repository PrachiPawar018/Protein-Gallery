<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="pageTitle" value="Protein Gallery - Premium Sports Nutrition & Supplements" />

<jsp:include page="WEB-INF/components/header.jsp" />

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="hero-content">
                <h1>Fuel Your <span>Ambition</span></h1>
                <p>Premium sports nutrition and supplements tailored to your specific fitness goals. High-quality ingredients, uncompromising results.</p>
                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-lg">
                        🛍️ Shop All Products
                    </a>
                    <a href="#goals" class="btn btn-outline btn-lg">
                        Explore Goals
                    </a>
                </div>
            </div>
            <div class="hero-image">
                <div class="hero-placeholder">
                    <span class="hero-icon">💪</span>
                    <p>Premium Supplements</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section section">
        <div class="container">
            <div class="section-header text-center">
                <h2>Why Choose Protein Gallery?</h2>
                <p>We're committed to providing the highest quality supplements with transparent sourcing and expert guidance.</p>
            </div>
            <div class="grid grid-3">
                <div class="feature-card card">
                    <div class="feature-icon">🏆</div>
                    <h3>Premium Quality</h3>
                    <p>Only the finest ingredients from trusted manufacturers. No compromises on quality or safety.</p>
                </div>
                <div class="feature-card card">
                    <div class="feature-icon">🚚</div>
                    <h3>Fast Shipping</h3>
                    <p>Free shipping on orders over $50. Discreet packaging and fast delivery worldwide.</p>
                </div>
                <div class="feature-card card">
                    <div class="feature-icon">👨‍⚕️</div>
                    <h3>Expert Support</h3>
                    <p>Our nutrition experts are here to help you choose the right supplements for your goals.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Goals Section -->
    <section id="goals" class="goals-section section">
        <div class="container">
            <div class="section-header text-center">
                <h2>Shop By Your Goal</h2>
                <p>Find the perfect supplements to support your fitness journey</p>
            </div>
            <div class="grid grid-2">
                <a href="${pageContext.request.contextPath}/products?goal=muscle-gain" class="goal-card card">
                    <div class="goal-icon">💪</div>
                    <h3>Muscle Gain</h3>
                    <p>Whey Protein, Mass Gainers, Creatine & BCAAs for building lean muscle mass</p>
                    <div class="goal-products">
                        <span class="product-tag">Whey Protein</span>
                        <span class="product-tag">Creatine</span>
                        <span class="product-tag">Mass Gainers</span>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/products?goal=weight-loss" class="goal-card card">
                    <div class="goal-icon">⚖️</div>
                    <h3>Weight Loss</h3>
                    <p>Fat Burners, Lean Protein & Metabolism boosters for effective weight management</p>
                    <div class="goal-products">
                        <span class="product-tag">Fat Burners</span>
                        <span class="product-tag">Lean Protein</span>
                        <span class="product-tag">CLA</span>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/products?goal=endurance" class="goal-card card">
                    <div class="goal-icon">🏃</div>
                    <h3>Endurance</h3>
                    <p>Pre-workouts, BCAAs & Energy supplements for peak performance and recovery</p>
                    <div class="goal-products">
                        <span class="product-tag">Pre-Workouts</span>
                        <span class="product-tag">BCAAs</span>
                        <span class="product-tag">Electrolytes</span>
                    </div>
                </a>
                <a href="${pageContext.request.contextPath}/products?goal=beginner" class="goal-card card">
                    <div class="goal-icon">🌱</div>
                    <h3>Beginner Friendly</h3>
                    <p>Starter packs, multivitamins & essentials for those new to fitness supplementation</p>
                    <div class="goal-products">
                        <span class="product-tag">Starter Packs</span>
                        <span class="product-tag">Multivitamins</span>
                        <span class="product-tag">Fish Oil</span>
                    </div>
                </a>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="categories-section section">
        <div class="container">
            <div class="section-header text-center">
                <h2>Product Categories</h2>
                <p>Explore our comprehensive range of premium supplements</p>
            </div>
            <div class="grid grid-4">
                <div class="category-card card">
                    <div class="category-icon">🥛</div>
                    <h4>Proteins</h4>
                    <p>Whey, Casein, Plant-based proteins</p>
                    <a href="${pageContext.request.contextPath}/products?category=Whey Protein" class="category-link">Shop Proteins →</a>
                </div>
                <div class="category-card card">
                    <div class="category-icon">⚡</div>
                    <h4>Pre-Workouts</h4>
                    <p>Energy boosters and performance enhancers</p>
                    <a href="${pageContext.request.contextPath}/products?category=Pre-Workout" class="category-link">Shop Pre-Workouts →</a>
                </div>
                <div class="category-card card">
                    <div class="category-icon">💊</div>
                    <h4>Vitamins</h4>
                    <p>Multivitamins and targeted nutrient support</p>
                    <a href="${pageContext.request.contextPath}/products?category=Vitamins" class="category-link">Shop Vitamins →</a>
                </div>
                <div class="category-card card">
                    <div class="category-icon">🏆</div>
                    <h4>Accessories</h4>
                    <p>Shakers, containers, and fitness gear</p>
                    <a href="${pageContext.request.contextPath}/products?category=Accessories" class="category-link">Shop Accessories →</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="testimonials-section section">
        <div class="container">
            <div class="section-header text-center">
                <h2>What Our Customers Say</h2>
                <p>Real results from real people</p>
            </div>
            <div class="grid grid-3">
                <div class="testimonial-card card">
                    <div class="testimonial-stars">★★★★★</div>
                    <p>"Protein Gallery has transformed my fitness journey. The quality of their whey protein is unmatched, and I've seen incredible results in just 3 months!"</p>
                    <div class="testimonial-author">
                        <strong>Sarah M.</strong>
                        <span>Fitness Enthusiast</span>
                    </div>
                </div>
                <div class="testimonial-card card">
                    <div class="testimonial-stars">★★★★★</div>
                    <p>"Fast shipping, great customer service, and products that actually work. I've tried many supplements, but Protein Gallery is my go-to now."</p>
                    <div class="testimonial-author">
                        <strong>Mike R.</strong>
                        <span>Bodybuilder</span>
                    </div>
                </div>
                <div class="testimonial-card card">
                    <div class="testimonial-stars">★★★★★</div>
                    <p>"The pre-workout supplements give me the energy boost I need without the jitters. Highly recommend for anyone serious about their training."</p>
                    <div class="testimonial-author">
                        <strong>Jenna L.</strong>
                        <span>CrossFit Athlete</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section section-sm">
        <div class="container">
            <div class="cta-card card text-center">
                <h2>Ready to Start Your Journey?</h2>
                <p>Join thousands of satisfied customers and fuel your fitness goals with premium supplements.</p>
                <div class="cta-actions">
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary btn-lg">
                        Create Free Account
                    </a>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-lg">
                        Browse Products
                    </a>
                </div>
            </div>
        </div>
    </section>

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
