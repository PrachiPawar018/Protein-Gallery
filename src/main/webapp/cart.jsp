<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.proteingallery.dao.CartDAO, com.proteingallery.model.CartItem, com.proteingallery.model.User, java.util.List, java.math.BigDecimal" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp?error=Please login to view your cart");
        return;
    }
    CartDAO cartDAO = new CartDAO();
    List<CartItem> items = cartDAO.getCartItemsByUserId(user.getId());
    request.setAttribute("cartItems", items);
    
    BigDecimal subtotal = BigDecimal.ZERO;
    for (CartItem item : items) {
        if (item.getTotalPrice() != null) {
            subtotal = subtotal.add(item.getTotalPrice());
        }
    }
    request.setAttribute("cartTotal", subtotal);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart - Protein Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .cart-container {
            max-width: 1200px;
            margin: 3rem auto;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
        }
        @media (max-width: 768px) {
            .cart-container {
                grid-template-columns: 1fr;
            }
        }
        .cart-items {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 2rem;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .cart-item {
            display: flex;
            align-items: center;
            padding: 1.5rem 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            gap: 1.5rem;
        }
        .cart-item:last-child {
            border-bottom: none;
        }
        .item-img {
            width: 100px;
            height: 100px;
            background: #0f172a;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .item-img img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
            padding: 0.5rem;
        }
        .item-details {
            flex-grow: 1;
        }
        .item-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            margin-bottom: 0.25rem;
        }
        .item-price {
            color: var(--primary-color);
            font-weight: bold;
        }
        .item-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .qty-btn {
            background: #0f172a;
            border: 1px solid rgba(255,255,255,0.1);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }
        .qty-btn:hover {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }
        .remove-btn {
            background: transparent;
            border: none;
            color: var(--danger);
            cursor: pointer;
            font-size: 0.9rem;
        }
        .remove-btn:hover {
            text-decoration: underline;
        }
        
        .cart-summary {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 2rem;
            border: 1px solid rgba(255,255,255,0.05);
            height: fit-content;
        }
        .cart-summary h3 {
            margin-bottom: 1.5rem;
            color: white;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            color: var(--text-muted);
        }
        .summary-total {
            display: flex;
            justify-content: space-between;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid rgba(255,255,255,0.1);
            font-size: 1.25rem;
            font-weight: bold;
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="WEB-INF/components/navbar.jsp" />

    <div class="cart-container">
        <div class="cart-items">
            <h2>Your Cart</h2>
            
            <c:if test="${empty cartItems}">
                <p style="color:var(--text-muted); margin-top:1rem;">Your cart is empty. <a href="products" style="color:var(--primary-color);">Continue shopping</a>.</p>
            </c:if>

            <c:forEach var="item" items="${cartItems}">
                <div class="cart-item">
                    <div class="item-img">
                        <img src="${item.productImage}" alt="${item.productName}" onerror="this.src='';">
                    </div>
                    <div class="item-details">
                        <div class="item-name">${item.productName}</div>
                        <div class="item-price">$${item.finalPrice}</div>
                        
                        <div class="item-actions" style="margin-top:1rem;">
                            <button class="qty-btn" onclick="updateQuantity(${item.id}, ${item.quantity - 1})">-</button>
                            <span style="color:white; width:20px; text-align:center;">${item.quantity}</span>
                            <button class="qty-btn" onclick="updateQuantity(${item.id}, ${item.quantity + 1})">+</button>
                            
                            <button class="remove-btn" onclick="removeItem(${item.id})">Remove</button>
                        </div>
                    </div>
                    <div style="font-weight:bold; color:white; font-size:1.1rem;">
                        $${item.totalPrice}
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${not empty cartItems}">
            <div class="cart-summary">
                <h3>Order Summary</h3>
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>$${cartTotal}</span>
                </div>
                <div class="summary-row">
                    <span>Shipping</span>
                    <span>Calculated at checkout</span>
                </div>
                
                <div class="summary-total">
                    <span>Estimated Total</span>
                    <span>$${cartTotal}</span>
                </div>
                
                <a href="checkout.jsp" class="btn-primary" style="text-align:center; display:block; margin-top:2rem; text-decoration:none;">Proceed to Checkout</a>
            </div>
        </c:if>
    </div>

    <!-- The navbar includes cart.js globally, no need to include it again here, but it's safe if we do -->
</body>
</html>
