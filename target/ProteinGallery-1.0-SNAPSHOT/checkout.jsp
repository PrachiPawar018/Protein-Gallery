<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout - Protein Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .checkout-container {
            max-width: 1000px;
            margin: 3rem auto;
            padding: 0 1rem;
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 2rem;
        }
        @media (max-width: 768px) {
            .checkout-container {
                grid-template-columns: 1fr;
            }
        }
        .form-section {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 2rem;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .form-section h3 {
            margin-bottom: 1.5rem;
            color: var(--primary-color);
        }
        .summary-section {
            background: var(--card-bg);
            border-radius: 12px;
            padding: 2rem;
            border: 1px solid rgba(255,255,255,0.05);
            height: fit-content;
        }
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            font-size: 0.95rem;
        }
        .summary-item .name {
            color: var(--text-muted);
            max-width: 60%;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .summary-item .price {
            color: white;
            font-weight: 600;
        }
        .divider {
            height: 1px;
            background: rgba(255,255,255,0.1);
            margin: 1.5rem 0;
        }
        .totals-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }
        .final-total {
            font-size: 1.5rem;
            font-weight: 900;
            color: white;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        
        .coupon-block {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }
        .coupon-block input {
            flex-grow: 1;
            padding: 0.75rem;
            border-radius: 6px;
            border: 1px solid rgba(255,255,255,0.1);
            background: #0f172a;
            color: white;
        }
        .coupon-block button {
            background: #334155;
            color: white;
            border: none;
            padding: 0 1.5rem;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        
        .payment-methods {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        .payment-card {
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 8px;
            padding: 1rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: #0f172a;
        }
        .payment-card:hover {
            border-color: var(--primary-color);
        }
        .payment-card input[type="radio"] {
            accent-color: var(--primary-color);
        }
    </style>
</head>
<body>
    <jsp:include page="WEB-INF/components/navbar.jsp" />

    <div class="checkout-container">
        <div class="form-section">
            <h3>Shipping Details</h3>
            <% String error = request.getParameter("error");
               if (error != null) { %>
               <div class="alert alert-error"><%= error %></div>
            <% } %>

            <form action="checkout/process" method="POST" id="checkoutForm">
                <input type="hidden" name="coupon_code" id="applied_coupon" value="">
                <input type="hidden" name="csrf_token" value="${sessionScope.csrf_token}">
                
                <div style="margin-bottom: 1.5rem;">
                    <label style="display:block; margin-bottom:0.5rem; color:var(--text-light);">Full Address</label>
                    <input type="text" name="address" required placeholder="123 Main Street, Apt 4B" style="width:100%; padding:0.75rem; border-radius:6px; border:1px solid rgba(255,255,255,0.1); background:#0f172a; color:white;">
                </div>
                
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:1rem; margin-bottom: 1.5rem;">
                    <div>
                        <label style="display:block; margin-bottom:0.5rem; color:var(--text-light);">City / State</label>
                        <input type="text" name="city" required placeholder="New York, NY" style="width:100%; padding:0.75rem; border-radius:6px; border:1px solid rgba(255,255,255,0.1); background:#0f172a; color:white;">
                    </div>
                    <div>
                        <label style="display:block; margin-bottom:0.5rem; color:var(--text-light);">Zip Code / Pincode</label>
                        <input type="text" name="zip" required placeholder="10001" style="width:100%; padding:0.75rem; border-radius:6px; border:1px solid rgba(255,255,255,0.1); background:#0f172a; color:white;">
                    </div>
                </div>

                <h3 style="margin-top:2rem;">Payment Method</h3>
                <div class="payment-methods">
                    <label class="payment-card">
                        <input type="radio" name="payment_method" value="RAZORPAY" checked>
                        <span>Pay Online (Razorpay)</span>
                    </label>
                    <label class="payment-card">
                        <input type="radio" name="payment_method" value="COD">
                        <span>Cash on Delivery</span>
                    </label>
                </div>

                <button type="submit" class="btn-primary" style="font-size:1.25rem; padding:1rem; width:100%;">Place Order</button>
            </form>
        </div>

        <div class="summary-section">
            <h3>Order Summary</h3>
            <div id="items-list">
                <c:forEach var="item" items="${cartItems}">
                    <div class="summary-item">
                        <div class="name">${item.quantity}x ${item.productName}</div>
                        <div class="price">$${item.totalPrice}</div>
                    </div>
                </c:forEach>
            </div>

            <div class="divider"></div>

            <div class="coupon-block">
                <input type="text" id="couponInput" placeholder="Enter promo code">
                <button type="button" onclick="applyCoupon()">Apply</button>
            </div>
            <div id="couponMessage" style="font-size:0.875rem; margin-bottom:1rem;"></div>

            <div class="totals-row">
                <span style="color:var(--text-muted);">Subtotal</span>
                <span id="displaySubtotal">$${subtotal}</span>
            </div>
            <div class="totals-row" id="discountRow" style="display:none;">
                <span style="color:var(--success);">Discount</span>
                <span id="displayDiscount" style="color:var(--success);">-$0.00</span>
            </div>
            <div class="totals-row">
                <span style="color:var(--text-muted);">Shipping</span>
                <span>Free</span>
            </div>

            <div class="totals-row final-total">
                <span>Total</span>
                <span id="displayTotal">$${subtotal}</span>
            </div>
        </div>
    </div>

    <script>
        const subtotal = parseFloat('${subtotal}');
        
        function applyCoupon() {
            const code = document.getElementById('couponInput').value;
            if (!code) return;

            const formData = new URLSearchParams();
            formData.append('code', code);

            fetch('checkout/apply-coupon', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData
            })
            .then(res => res.json())
            .then(data => {
                const msg = document.getElementById('couponMessage');
                if (data.success && subtotal >= data.minOrder) {
                    msg.innerHTML = '<span style="color:var(--success);">Coupon applied successfully!</span>';
                    document.getElementById('applied_coupon').value = code;
                    
                    const discountAmt = subtotal * (data.discountPercent / 100);
                    const finalTotal = subtotal - discountAmt;
                    
                    document.getElementById('displayDiscount').innerText = '-$' + discountAmt.toFixed(2);
                    document.getElementById('discountRow').style.display = 'flex';
                    document.getElementById('displayTotal').innerText = '$' + finalTotal.toFixed(2);
                } else {
                    let errorText = data.error || ('Minimum order of $' + data.minOrder + ' required');
                    msg.innerHTML = '<span style="color:var(--danger);">' + errorText + '</span>';
                    document.getElementById('applied_coupon').value = '';
                    document.getElementById('discountRow').style.display = 'none';
                    document.getElementById('displayTotal').innerText = '$' + subtotal.toFixed(2);
                }
            })
            .catch(err => console.error(err));
        }
    </script>
</body>
</html>
