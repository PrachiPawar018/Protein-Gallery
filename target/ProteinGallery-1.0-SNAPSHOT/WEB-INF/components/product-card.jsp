<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!-- Product Card Component -->
<div class="product-card" data-product-id="${product.id}">
    <div class="product-image-container">
        <c:choose>
            <c:when test="${not empty product.imageUrl}">
                <img src="${product.imageUrl}" alt="${product.name}" class="product-image" loading="lazy">
            </c:when>
            <c:otherwise>
                <div class="product-image-placeholder">
                    <span class="placeholder-icon">🏋️</span>
                    <span class="placeholder-text">No Image</span>
                </div>
            </c:otherwise>
        </c:choose>

        <c:if test="${product.discountPercent > 0}">
            <div class="discount-badge">-${product.discountPercent}%</div>
        </c:if>

        <c:if test="${product.stock <= 5 && product.stock > 0}">
            <div class="stock-warning">Only ${product.stock} left!</div>
        </c:if>

        <c:if test="${product.stock == 0}">
            <div class="out-of-stock">Out of Stock</div>
        </c:if>
    </div>

    <div class="product-info">
        <div class="product-category">${product.category}</div>
        <c:if test="${not empty product.brand}">
            <div class="product-brand">${product.brand}</div>
        </c:if>

        <h3 class="product-title">
            <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}">${product.name}</a>
        </h3>

        <div class="product-rating">
            <div class="stars">
                <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                        <c:when test="${product.ratingAvg >= i}">
                            <span class="star filled">★</span>
                        </c:when>
                        <c:when test="${product.ratingAvg >= i - 0.5}">
                            <span class="star half">★</span>
                        </c:when>
                        <c:otherwise>
                            <span class="star">☆</span>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
            <span class="rating-text">(${product.reviewCount})</span>
        </div>

        <c:if test="${not empty product.description && fn:length(product.description) > 0}">
            <p class="product-description">
                ${fn:substring(product.description, 0, 100)}${fn:length(product.description) > 100 ? '...' : ''}
            </p>
        </c:if>

        <div class="product-price">
            <c:if test="${product.discountPercent > 0}">
                <span class="original-price">$${product.price}</span>
                <span class="discounted-price">$${product.finalPrice}</span>
            </c:if>
            <c:if test="${product.discountPercent == 0}">
                <span class="current-price">$${product.price}</span>
            </c:if>
        </div>

        <div class="product-actions">
            <c:choose>
                <c:when test="${product.stock > 0}">
                    <button class="btn-add-to-cart" onclick="addToCart(${product.id})">
                        <span class="cart-icon">🛒</span>
                        Add to Cart
                    </button>
                </c:when>
                <c:otherwise>
                    <button class="btn-out-of-stock" disabled>
                        Out of Stock
                    </button>
                </c:otherwise>
            </c:choose>

            <button class="btn-wishlist" onclick="toggleWishlist(${product.id})">
                <span class="wishlist-icon">❤️</span>
            </button>
        </div>

        <c:if test="${not empty product.nutritionInfo && fn:length(product.nutritionInfo) > 0}">
            <div class="product-nutrition">
                <button class="nutrition-toggle" onclick="toggleNutrition(this)">
                    View Nutrition Facts
                </button>
                <div class="nutrition-content" style="display: none;">
                    ${product.nutritionInfo}
                </div>
            </div>
        </c:if>
    </div>
</div>

<style>
.product-card {
    background: var(--card-bg);
    border: 1px solid rgba(255,255,255,0.05);
    border-radius: 12px;
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
}

.product-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.3);
    border-color: rgba(249, 115, 22, 0.3);
}

.product-image-container {
    position: relative;
    width: 100%;
    height: 250px;
    background: #0f172a;
    overflow: hidden;
}

.product-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
}

.product-card:hover .product-image {
    transform: scale(1.05);
}

.product-image-placeholder {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: var(--text-muted);
    background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
}

.placeholder-icon {
    font-size: 3rem;
    margin-bottom: 0.5rem;
}

.placeholder-text {
    font-size: 0.9rem;
    font-weight: 500;
}

.discount-badge {
    position: absolute;
    top: 10px;
    left: 10px;
    background: var(--danger);
    color: white;
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-size: 0.75rem;
    font-weight: bold;
    z-index: 2;
}

.stock-warning {
    position: absolute;
    top: 10px;
    right: 10px;
    background: #f59e0b;
    color: white;
    padding: 0.25rem 0.5rem;
    border-radius: 4px;
    font-size: 0.7rem;
    font-weight: bold;
    z-index: 2;
}

.out-of-stock {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: rgba(0,0,0,0.8);
    color: white;
    padding: 0.5rem 1rem;
    border-radius: 6px;
    font-size: 0.9rem;
    font-weight: bold;
    z-index: 2;
}

.product-info {
    padding: 1.5rem;
}

.product-category {
    font-size: 0.75rem;
    color: var(--primary-color);
    text-transform: uppercase;
    font-weight: 700;
    margin-bottom: 0.25rem;
}

.product-brand {
    font-size: 0.8rem;
    color: var(--text-muted);
    font-weight: 600;
    margin-bottom: 0.5rem;
}

.product-title {
    margin-bottom: 0.75rem;
}

.product-title a {
    color: var(--text-light);
    text-decoration: none;
    font-size: 1.1rem;
    font-weight: 600;
    line-height: 1.4;
    transition: color 0.3s;
}

.product-title a:hover {
    color: var(--primary-color);
}

.product-rating {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 0.75rem;
}

.stars {
    display: flex;
    gap: 0.1rem;
}

.star {
    color: #64748b;
    font-size: 0.9rem;
}

.star.filled {
    color: #fbbf24;
}

.star.half {
    color: #fbbf24;
    position: relative;
}

.star.half::after {
    content: '★';
    position: absolute;
    left: 0;
    top: 0;
    width: 50%;
    overflow: hidden;
    color: #64748b;
}

.rating-text {
    font-size: 0.8rem;
    color: var(--text-muted);
}

.product-description {
    color: var(--text-muted);
    font-size: 0.85rem;
    line-height: 1.4;
    margin-bottom: 1rem;
}

.product-price {
    margin-bottom: 1rem;
}

.original-price {
    text-decoration: line-through;
    color: var(--text-muted);
    font-size: 0.9rem;
    margin-right: 0.5rem;
}

.discounted-price,
.current-price {
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--primary-color);
}

.product-actions {
    display: flex;
    gap: 0.5rem;
    align-items: center;
}

.btn-add-to-cart,
.btn-out-of-stock {
    flex: 1;
    padding: 0.75rem 1rem;
    border: none;
    border-radius: 6px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
}

.btn-add-to-cart {
    background: var(--primary-color);
    color: white;
}

.btn-add-to-cart:hover {
    background: var(--primary-hover);
    transform: translateY(-1px);
}

.btn-out-of-stock {
    background: var(--text-muted);
    color: var(--bg-dark);
    cursor: not-allowed;
}

.btn-wishlist {
    padding: 0.75rem;
    border: 1px solid rgba(255,255,255,0.1);
    background: transparent;
    color: var(--text-muted);
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s;
}

.btn-wishlist:hover {
    border-color: #ef4444;
    color: #ef4444;
    transform: scale(1.05);
}

.btn-wishlist.active {
    border-color: #ef4444;
    color: #ef4444;
    background: rgba(239, 68, 68, 0.1);
}

.product-nutrition {
    margin-top: 1rem;
    padding-top: 1rem;
    border-top: 1px solid rgba(255,255,255,0.05);
}

.nutrition-toggle {
    background: none;
    border: 1px solid rgba(255,255,255,0.1);
    color: var(--text-muted);
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.8rem;
    transition: all 0.3s;
}

.nutrition-toggle:hover {
    border-color: var(--primary-color);
    color: var(--primary-color);
}

.nutrition-content {
    margin-top: 0.5rem;
    padding: 0.5rem;
    background: rgba(255,255,255,0.02);
    border-radius: 4px;
    font-size: 0.8rem;
    color: var(--text-muted);
    line-height: 1.4;
}

@media (max-width: 768px) {
    .product-card {
        margin-bottom: 1rem;
    }

    .product-actions {
        flex-direction: column;
    }

    .btn-add-to-cart,
    .btn-out-of-stock {
        width: 100%;
    }
}
</style>

<script>
// Product card functionality
function addToCart(productId) {
    // Implement cart functionality
    fetch(`${window.contextPath}/cart/add`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRF-Token': window.csrfToken
        },
        body: `productId=${productId}&quantity=1`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showSuccess('Product added to cart!');
            updateCartBadge();
        } else {
            showError(data.message || 'Failed to add product to cart');
        }
    })
    .catch(error => {
        showError('Network error. Please try again.');
    });
}

function toggleWishlist(productId) {
    // Implement wishlist functionality
    const btn = event.target.closest('.btn-wishlist');
    btn.classList.toggle('active');

    if (btn.classList.contains('active')) {
        showSuccess('Added to wishlist!');
    } else {
        showInfo('Removed from wishlist');
    }
}

function toggleNutrition(button) {
    const content = button.nextElementSibling;
    const isVisible = content.style.display !== 'none';

    content.style.display = isVisible ? 'none' : 'block';
    button.textContent = isVisible ? 'View Nutrition Facts' : 'Hide Nutrition Facts';
}
</script>