<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<div class="product-card">

  <!-- Image container -->
  <div class="product-img-wrap">
    <img src="${product.imageUrl}"
         alt="${fn:escapeXml(product.name)}"
         loading="lazy"
         class="product-img"
         onerror="this.style.display='none'">

    <!-- Badges -->
    <c:if test="${product.discountPercent > 0}">
      <span class="product-badge discount">
        ${product.discountPercent}% OFF
      </span>
    </c:if>
    <c:if test="${product.stock < 10 && product.stock > 0}">
      <span class="product-badge low-stock">
        Only ${product.stock} left!
      </span>
    </c:if>
    <c:if test="${product.stock == 0}">
      <span class="product-badge out-of-stock">
        Out of Stock
      </span>
    </c:if>

    <!-- Wishlist button -->
    <button class="wishlist-btn"
            data-id="${product.id}">♡</button>

    <!-- Quick view on hover -->
    <div class="product-overlay">
      <a href="${pageContext.request.contextPath}/products/detail?id=${product.id}"
         class="quick-view-btn">
        Quick View 👁
      </a>
    </div>
  </div>

  <!-- Product info -->
  <div class="product-info">
    <span class="product-brand">
      ${fn:escapeXml(product.brand)}
    </span>
    <h3 class="product-name">
      <a href="${pageContext.request.contextPath}/products/detail?id=${product.id}">
        ${fn:escapeXml(product.name)}
      </a>
    </h3>

    <!-- Stars -->
    <div class="product-rating">
      <span class="stars">
        <c:forEach begin="1" end="5" var="i">
          <c:choose>
            <c:when test="${product.ratingAvg >= i}">★</c:when>
            <c:otherwise>☆</c:otherwise>
          </c:choose>
        </c:forEach>
      </span>
      <span class="rating-num">
        ${product.ratingAvg}
      </span>
    </div>

    <!-- Price -->
    <div class="product-price">
      <c:if test="${product.discountPercent > 0}">
        <span class="price-original">
          ₹<fmt:formatNumber value="${product.price}" pattern="#,##0"/>
        </span>
      </c:if>
      <span class="price-current">
        ₹<fmt:formatNumber value="${product.price * (1 - product.discountPercent/100)}" pattern="#,##0"/>
      </span>
      <c:if test="${product.discountPercent > 0}">
        <span class="price-save">
          Save ₹<fmt:formatNumber value="${product.price * product.discountPercent/100}" pattern="#,##0"/>
        </span>
      </c:if>
    </div>

    <!-- Add to Cart -->
    <button class="btn-add-cart"
            data-id="${product.id}"
            ${product.stock == 0 ? 'disabled' : ''}>
      <c:choose>
        <c:when test="${product.stock == 0}">
          Out of Stock
        </c:when>
        <c:otherwise>
          🛒 Add to Cart
        </c:otherwise>
      </c:choose>
    </button>
  </div>
</div>

<style>
.product-card {
    background: var(--card-bg);
    border: 1px solid var(--border);
    border-radius: 16px;
    overflow: hidden;
    transition: all 0.3s ease;
    position: relative;
}

.product-card:hover {
    transform: translateY(-6px);
    border-color: rgba(255,107,53,0.4);
    box-shadow: 0 20px 60px rgba(0,0,0,0.4),
                0 0 30px rgba(255,107,53,0.1);
}

.product-img-wrap {
    position: relative;
    aspect-ratio: 1;
    overflow: hidden;
    background: linear-gradient(
        135deg, #1E1E3A, #252545);
}

.product-img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.5s ease;
}

.product-card:hover .product-img {
    transform: scale(1.08);
}

.product-badge {
    position: absolute;
    top: 12px;
    left: 12px;
    padding: 4px 10px;
    border-radius: 6px;
    font-size: 11px;
    font-weight: 700;
}

.product-badge.discount   {
    background: #FF6B35;
    color: white;
}
.product-badge.low-stock  {
    background: #F4D03F;
    color: #1A1A2E;
}
.product-badge.out-of-stock {
    background: #E74C3C;
    color: white;
}

.wishlist-btn {
    position: absolute;
    top: 12px;
    right: 12px;
    background: rgba(26,26,46,0.8);
    border: 1px solid rgba(255,255,255,0.1);
    color: #B0B8C4;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 16px;
    backdrop-filter: blur(4px);
}

.wishlist-btn:hover,
.wishlist-btn.active {
    background: rgba(231,76,60,0.2);
    border-color: #E74C3C;
    color: #E74C3C;
}

.product-overlay {
    position: absolute;
    inset: 0;
    background: rgba(26,26,46,0.7);
    display: flex;
    align-items: center;
    justify-content: center;
    opacity: 0;
    transition: opacity 0.3s ease;
    backdrop-filter: blur(4px);
}

.product-card:hover .product-overlay {
    opacity: 1;
}

.quick-view-btn {
    background: white;
    color: #1A1A2E;
    padding: 10px 20px;
    border-radius: 50px;
    text-decoration: none;
    font-weight: 600;
    font-size: 13px;
    transition: all 0.3s ease;
}

.quick-view-btn:hover {
    background: #FF6B35;
    color: white;
}

.product-info { padding: 16px; }

.product-brand {
    color: #FF6B35;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 1px;
    text-transform: uppercase;
}

.product-name {
    margin: 6px 0 8px;
    font-size: 15px;
    font-weight: 600;
    line-height: 1.4;
}

.product-name a {
    color: white;
    text-decoration: none;
    transition: color 0.3s;
}

.product-name a:hover { color: #FF6B35; }

.product-rating {
    display: flex;
    align-items: center;
    gap: 6px;
    margin-bottom: 12px;
}

.stars { color: #F4D03F; font-size: 13px; }
.rating-num {
    color: #B0B8C4;
    font-size: 13px;
}

.product-price {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
    margin-bottom: 16px;
}

.price-current {
    font-family: 'Montserrat', sans-serif;
    font-size: 1.3rem;
    font-weight: 800;
    color: white;
}

.price-original {
    font-size: 14px;
    color: #B0B8C4;
    text-decoration: line-through;
}

.price-save {
    font-size: 12px;
    color: #27AE60;
    font-weight: 600;
}

.btn-add-cart {
    width: 100%;
    background: linear-gradient(
        135deg, #FF6B35, #E55A25);
    color: white;
    border: none;
    padding: 12px;
    border-radius: 10px;
    font-weight: 700;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-family: 'Montserrat', sans-serif;
}

.btn-add-cart:hover:not(:disabled) {
    transform: translateY(-1px);
    box-shadow: 0 8px 20px rgba(255,107,53,0.4);
}

.btn-add-cart:disabled {
    background: #2A2A4A;
    color: #B0B8C4;
    cursor: not-allowed;
}
</style>
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