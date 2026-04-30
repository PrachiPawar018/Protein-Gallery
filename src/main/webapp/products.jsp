<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop - Protein Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .page-header {
            padding: 3rem 1rem;
            text-align: center;
            background: linear-gradient(135deg, var(--bg-dark) 0%, #1e293b 100%);
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .page-header h1 {
            color: var(--text-light);
            text-transform: capitalize;
            font-size: 2.5rem;
            font-weight: 900;
        }
        .page-header h1 span {
            color: var(--primary-color);
        }
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 2rem;
            padding: 4rem 2rem;
            max-width: 1200px;
            margin: 0 auto;
        }
        .product-card {
            background: var(--card-bg);
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 12px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.5);
            border-color: rgba(255,255,255,0.2);
        }
        .product-img {
            width: 100%;
            height: 250px;
            background: #0f172a;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .product-info {
            padding: 1.5rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .product-brand {
            font-size: 0.8rem;
            color: var(--primary-color);
            text-transform: uppercase;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .product-title {
            font-size: 1.1rem;
            color: white;
            margin-bottom: 1rem;
            font-weight: 600;
            line-height: 1.4;
        }
        .product-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: white;
            margin-top: auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .original-price {
            text-decoration: line-through;
            color: var(--text-muted);
            font-size: 0.9rem;
            font-weight: normal;
            margin-right: 0.5rem;
        }
        .discount-badge {
            background: var(--danger);
            color: white;
            font-size: 0.75rem;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            font-weight: bold;
        }
        .btn-cart {
            margin-top: 1rem;
            background: transparent;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
            padding: 0.75rem;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
            display: block;
        }
        .btn-cart:hover {
            background: var(--primary-color);
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="WEB-INF/components/navbar.jsp" />

    <div class="page-header">
        <c:choose>
            <c:when test="${not empty currentGoal}">
                <h1>Goal: <span>${currentGoal.replace('-', ' ')}</span></h1>
            </c:when>
            <c:when test="${not empty searchQuery}">
                <h1>Search Results for <span>"${searchQuery}"</span></h1>
            </c:when>
            <c:otherwise>
                <h1>All <span>Products</span></h1>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="products-grid">
        <c:if test="${empty products}">
            <div style="text-align:center; grid-column: 1 / -1; color: var(--text-muted); padding: 3rem;">
                <h2>No products found.</h2>
            </div>
        </c:if>

        <c:forEach var="p" items="${products}">
            <div class="product-card">
                <div class="product-img">
                    <img src="${p.imageUrl}" alt="${p.name}" style="max-width:100%; max-height:100%; object-fit:contain; padding:1rem;" onerror="this.src=''; this.alt='No Image';">
                </div>
                <div class="product-info">
                    <div class="product-brand">${p.brand}</div>
                    <div class="product-title">${p.name}</div>
                    <div class="product-price">
                        <div>
                            <c:if test="${p.discountPercent > 0}">
                                <span class="original-price">$${p.price}</span>
                            </c:if>
                            <span>$${p.finalPrice}</span>
                        </div>
                        <c:if test="${p.discountPercent > 0}">
                            <span class="discount-badge">-${p.discountPercent}%</span>
                        </c:if>
                    </div>
                    <!-- Directs to Phase 5 cart logic -->
                    <a href="cart/add?id=${p.id}" class="btn-cart">Add to Cart</a>
                </div>
            </div>
        </c:forEach>
    </div>
</body>
</html>
