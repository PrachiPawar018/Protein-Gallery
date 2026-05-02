<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<c:set var="pageTitle" value="Shop - Protein Gallery" />

<jsp:include page="WEB-INF/components/header.jsp" />

    <!-- Page Header -->
    <section class="page-header-section">
        <div class="container">
            <div class="page-header-content">
                <c:choose>
                    <c:when test="${not empty currentGoal}">
                        <h1>Goal: <span>${currentGoal.replace('-', ' ')}</span></h1>
                        <p>Premium supplements tailored for ${currentGoal.replace('-', ' ')}</p>
                    </c:when>
                    <c:when test="${not empty searchQuery}">
                        <h1>Search Results for <span>"${searchQuery}"</span></h1>
                        <p>Found ${products.size()} products matching your search</p>
                    </c:when>
                    <c:otherwise>
                        <h1>All <span>Products</span></h1>
                        <p>Discover our complete range of premium sports nutrition supplements</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <!-- Filters Section -->
    <section class="filters-section section-sm">
        <div class="container">
            <div class="filters-bar">
                <div class="filter-group">
                    <label for="category-filter">Category:</label>
                    <select id="category-filter" class="form-control">
                        <option value="">All Categories</option>
                        <option value="Whey Protein">Whey Protein</option>
                        <option value="Mass Gainers">Mass Gainers</option>
                        <option value="Pre-Workout">Pre-Workout</option>
                        <option value="Vitamins">Vitamins</option>
                        <option value="Accessories">Accessories</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="sort-filter">Sort by:</label>
                    <select id="sort-filter" class="form-control">
                        <option value="name">Name</option>
                        <option value="price-low">Price: Low to High</option>
                        <option value="price-high">Price: High to Low</option>
                        <option value="rating">Rating</option>
                        <option value="newest">Newest</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="price-filter">Price Range:</label>
                    <select id="price-filter" class="form-control">
                        <option value="">All Prices</option>
                        <option value="0-25">$0 - $25</option>
                        <option value="25-50">$25 - $50</option>
                        <option value="50-100">$50 - $100</option>
                        <option value="100+">$100+</option>
                    </select>
                </div>
            </div>
        </div>
    </section>

    <!-- Products Grid -->
    <section class="products-section section">
        <div class="container">
            <c:if test="${empty products}">
                <div class="empty-state text-center">
                    <div class="empty-icon">🔍</div>
                    <h2>No products found</h2>
                    <p>We couldn't find any products matching your criteria. Try adjusting your filters or search terms.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                        View All Products
                    </a>
                </div>
            </c:if>

            <c:if test="${not empty products}">
                <div class="products-stats">
                    <p>Showing ${products.size()} product${products.size() != 1 ? 's' : ''}</p>
                </div>

                <div class="products-grid">
                    <c:forEach var="product" items="${products}">
                        <jsp:include page="WEB-INF/components/product-card.jsp">
                            <jsp:param name="product" value="${product}" />
                        </jsp:include>
                    </c:forEach>
                </div>
            </c:if>
        </div>
    </section>

    <!-- Newsletter Section -->
    <section class="newsletter-section section-sm">
        <div class="container">
            <div class="newsletter-card card text-center">
                <h3>Stay Updated</h3>
                <p>Get the latest product releases, exclusive offers, and fitness tips delivered to your inbox.</p>
                <form class="newsletter-form" onsubmit="subscribeNewsletter(event)">
                    <div class="form-group">
                        <input type="email" id="newsletter-email" class="form-control" placeholder="Enter your email" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Subscribe</button>
                </form>
            </div>
        </div>
    </section>

<jsp:include page="WEB-INF/components/footer.jsp" />

<style>
/* Page Header */
.page-header-section {
    background: linear-gradient(135deg, var(--bg-dark) 0%, #1e293b 100%);
    padding: 4rem 1rem;
    text-align: center;
    border-bottom: 1px solid rgba(255,255,255,0.05);
}

.page-header-content h1 {
    font-size: 2.5rem;
    font-weight: 900;
    color: var(--text-light);
    margin-bottom: 1rem;
    text-transform: capitalize;
}

.page-header-content h1 span {
    color: var(--primary-color);
}

.page-header-content p {
    font-size: 1.1rem;
    color: var(--text-muted);
    max-width: 600px;
    margin: 0 auto;
}

/* Filters */
.filters-section {
    background: var(--card-bg);
    border-bottom: 1px solid rgba(255,255,255,0.05);
}

.filters-bar {
    display: flex;
    gap: 2rem;
    align-items: end;
    flex-wrap: wrap;
}

.filter-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    min-width: 200px;
}

.filter-group label {
    font-weight: 600;
    color: var(--text-light);
    font-size: 0.9rem;
}

/* Products Grid */
.products-section {
    padding-top: 2rem;
}

.products-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 2rem;
}

.products-stats {
    text-align: center;
    color: var(--text-muted);
    margin-bottom: 2rem;
    font-size: 0.9rem;
}

/* Empty State */
.empty-state {
    padding: 4rem 2rem;
    max-width: 500px;
    margin: 0 auto;
}

.empty-icon {
    font-size: 4rem;
    margin-bottom: 1rem;
}

.empty-state h2 {
    color: var(--text-light);
    margin-bottom: 1rem;
}

.empty-state p {
    color: var(--text-muted);
    margin-bottom: 2rem;
    line-height: 1.6;
}

/* Newsletter */
.newsletter-card {
    background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-hover) 100%);
    color: white;
    padding: 3rem 2rem;
    margin: 0 auto;
    max-width: 600px;
}

.newsletter-card h3 {
    color: white;
    margin-bottom: 1rem;
}

.newsletter-card p {
    color: rgba(255,255,255,0.9);
    margin-bottom: 2rem;
}

.newsletter-form {
    display: flex;
    gap: 1rem;
    max-width: 500px;
    margin: 0 auto;
}

.newsletter-form .form-group {
    flex: 1;
    margin-bottom: 0;
}

.newsletter-form .form-control {
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.2);
    color: white;
}

.newsletter-form .form-control::placeholder {
    color: rgba(255,255,255,0.7);
}

.newsletter-form .form-control:focus {
    border-color: white;
    background: rgba(255,255,255,0.15);
}

/* Responsive */
@media (max-width: 768px) {
    .filters-bar {
        flex-direction: column;
        align-items: stretch;
    }

    .filter-group {
        min-width: auto;
    }

    .products-grid {
        grid-template-columns: 1fr;
    }

    .newsletter-form {
        flex-direction: column;
    }
}
</style>

<script>
// Newsletter subscription
function subscribeNewsletter(event) {
    event.preventDefault();
    const email = document.getElementById('newsletter-email').value;

    // Show success message
    showSuccess('Thank you for subscribing! Check your email for confirmation.');

    // Reset form
    event.target.reset();
}

// Filter functionality (placeholder for future implementation)
document.getElementById('category-filter').addEventListener('change', function() {
    // Implement category filtering
    console.log('Filter by category:', this.value);
});

document.getElementById('sort-filter').addEventListener('change', function() {
    // Implement sorting
    console.log('Sort by:', this.value);
});

document.getElementById('price-filter').addEventListener('change', function() {
    // Implement price filtering
    console.log('Filter by price:', this.value);
});
</script>
