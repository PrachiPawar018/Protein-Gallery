<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Success - Protein Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body style="display:flex; flex-direction:column; min-height:100vh;">
    <jsp:include page="WEB-INF/components/navbar.jsp" />

    <div style="flex-grow:1; display:flex; align-items:center; justify-content:center; text-align:center; padding:2rem;">
        <div style="background:var(--card-bg); padding:4rem; border-radius:16px; border:1px solid var(--primary-color);">
            <h1 style="color:var(--primary-color); font-size:3rem; margin-bottom:1rem;">Thank You!</h1>
            <p style="color:white; font-size:1.25rem; margin-bottom:2rem;">Your order #${param.orderId} has been successfully placed.</p>
            <a href="products" class="btn-primary">Continue Shopping</a>
        </div>
    </div>
</body>
</html>
