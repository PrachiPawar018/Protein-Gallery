<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - Protein Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 3rem 1rem;
        }
        .product-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            background: var(--card-bg);
            border-radius: 16px;
            padding: 3rem;
            border: 1px solid rgba(255,255,255,0.05);
        }
        @media (max-width: 768px) {
            .product-layout {
                grid-template-columns: 1fr;
                gap: 2rem;
                padding: 1.5rem;
            }
        }
        .product-image {
            background: #0f172a;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 400px;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .product-image img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
            padding: 2rem;
        }
        .product-details h1 {
            color: white;
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            line-height: 1.2;
        }
        .product-brand {
            color: var(--primary-color);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 1rem;
        }
        .product-price-block {
            display: flex;
            align-items: baseline;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .final-price {
            font-size: 2.5rem;
            color: white;
            font-weight: 900;
        }
        .original-price {
            text-decoration: line-through;
            color: var(--text-muted);
            font-size: 1.25rem;
        }
        .discount-tag {
            background: var(--danger);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 6px;
            font-weight: bold;
        }
        .product-description {
            color: var(--text-muted);
            line-height: 1.8;
            margin-bottom: 2rem;
        }
        .nutrition-panel {
            background: #0f172a;
            padding: 1.5rem;
            border-radius: 8px;
            border-left: 4px solid var(--primary-color);
            margin-bottom: 2rem;
        }
        .nutrition-panel strong {
            color: white;
            display: block;
            margin-bottom: 0.5rem;
        }
        .action-block {
            display: flex;
            gap: 1rem;
        }
        .quantity-input {
            width: 80px;
            background: #0f172a;
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
            border-radius: 6px;
            padding: 0.75rem;
            font-size: 1.1rem;
            text-align: center;
        }
        .btn-add-cart {
            flex-grow: 1;
            background: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: background 0.3s;
        }
        .btn-add-cart:hover {
            background: var(--primary-hover);
        }

        /* Reviews Section */
        .reviews-section {
            margin-top: 4rem;
        }
        .reviews-section h2 {
            color: white;
            margin-bottom: 2rem;
            font-size: 2rem;
        }
        .review-card {
            background: var(--card-bg);
            padding: 1.5rem;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.05);
            margin-bottom: 1rem;
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        .reviewer-name {
            color: white;
            font-weight: bold;
        }
        .review-date {
            color: var(--text-muted);
            font-size: 0.875rem;
        }
        .review-stars {
            color: #fbbf24; /* Yellow */
            margin-bottom: 0.5rem;
        }
        
        .review-form {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 3rem;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .review-form select, .review-form textarea {
            width: 100%;
            padding: 1rem;
            background: #0f172a;
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
            border-radius: 6px;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <jsp:include page="WEB-INF/components/navbar.jsp" />

    <div class="container">
        <% String msg = request.getParameter("msg");
           if (msg != null) { %>
            <div class="alert alert-success"><%= msg %></div>
        <% } %>
        <% String err = request.getParameter("error");
           if (err != null) { %>
            <div class="alert alert-error"><%= err %></div>
        <% } %>

        <div class="product-layout">
            <div class="product-image">
                <img src="${product.imageUrl}" alt="${product.name}" onerror="this.src=''; this.alt='No Image';">
            </div>
            
            <div class="product-details">
                <div class="product-brand">${product.brand}</div>
                <h1>${product.name}</h1>
                
                <div style="color: #fbbf24; margin-bottom: 1rem; display:flex; gap: 0.5rem; align-items:center;">
                    <span>★ ${product.ratingAvg}</span>
                    <span style="color: var(--text-muted); font-size:0.9rem;">(${reviews.size()} reviews)</span>
                </div>

                <div class="product-price-block">
                    <div class="final-price">$${product.finalPrice}</div>
                    <c:if test="${product.discountPercent > 0}">
                        <div class="original-price">$${product.price}</div>
                        <div class="discount-tag">-${product.discountPercent}% OFF</div>
                    </c:if>
                </div>
                
                <div class="product-description">
                    ${product.description}
                </div>
                
                <div class="nutrition-panel">
                    <strong>Nutrition Highlights</strong>
                    ${product.nutritionInfo}
                </div>
                
                <form action="cart/add" method="POST" class="action-block">
                    <input type="hidden" name="productId" value="${product.id}">
                    <input type="number" name="quantity" value="1" min="1" max="${product.stock}" class="quantity-input" required>
                    <button type="submit" class="btn-add-cart">Add to Cart</button>
                </form>
            </div>
        </div>

        <div class="reviews-section">
            <h2>Customer Reviews</h2>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="review-form">
                        <h3>Write a Review</h3>
                        <form action="review" method="POST">
                            <input type="hidden" name="productId" value="${product.id}">
                            <select name="rating" required>
                                <option value="" disabled selected>Select Rating</option>
                                <option value="5">5 - Excellent</option>
                                <option value="4">4 - Very Good</option>
                                <option value="3">3 - Average</option>
                                <option value="2">2 - Poor</option>
                                <option value="1">1 - Terrible</option>
                            </select>
                            <textarea name="comment" rows="4" placeholder="Share your experience with this product..." required></textarea>
                            <button type="submit" class="btn-primary" style="width:auto;">Submit Review</button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert" style="background:#1e293b; color:var(--text-muted);">
                        Please <a href="login.jsp" style="color:var(--primary-color);">log in</a> to leave a review.
                    </div>
                </c:otherwise>
            </c:choose>

            <div class="reviews-list">
                <c:if test="${empty reviews}">
                    <p style="color:var(--text-muted);">No reviews yet. Be the first to review!</p>
                </c:if>

                <c:forEach var="r" items="${reviews}">
                    <div class="review-card">
                        <div class="review-header">
                            <div class="reviewer-name">${r.userName}</div>
                            <div class="review-date">${r.createdAt}</div>
                        </div>
                        <div class="review-stars">
                            <c:forEach begin="1" end="${r.rating}">★</c:forEach>
                            <c:forEach begin="${r.rating + 1}" end="5"><span style="color:#334155;">★</span></c:forEach>
                        </div>
                        <div style="color:var(--text-light);">${r.comment}</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>
