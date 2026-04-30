<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Processing Payment - Protein Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body style="display:flex; flex-direction:column; min-height:100vh; background:var(--bg-dark); color:white;">
    <div style="flex-grow:1; display:flex; align-items:center; justify-content:center; text-align:center;">
        <div>
            <h2 style="color:var(--primary-color);">Initializing Secure Payment...</h2>
            <p style="color:var(--text-muted); margin-top:1rem;">Please do not refresh the page.</p>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/payment/verify" method="POST" id="razorpayForm">
        <input type="hidden" name="razorpay_payment_id" id="razorpay_payment_id">
        <input type="hidden" name="razorpay_order_id" id="razorpay_order_id">
        <input type="hidden" name="razorpay_signature" id="razorpay_signature">
        <input type="hidden" name="dbOrderId" value="${dbOrderId}">
    </form>

    <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
    <script>
        var options = {
            "key": "${rzpKey}",
            "amount": "${amount}",
            "currency": "INR",
            "name": "Protein Gallery",
            "description": "Order #${dbOrderId} Payment",
            "image": "https://dummyimage.com/150x150/0f172a/f97316.png&text=PG",
            "order_id": "${rzpOrderId}",
            "handler": function (response){
                document.getElementById('razorpay_payment_id').value = response.razorpay_payment_id;
                document.getElementById('razorpay_order_id').value = response.razorpay_order_id;
                document.getElementById('razorpay_signature').value = response.razorpay_signature;
                document.getElementById('razorpayForm').submit();
            },
            "theme": {
                "color": "#f97316"
            },
            "modal": {
                "ondismiss": function(){
                    window.location.href = "${pageContext.request.contextPath}/checkout.jsp?error=Payment Cancelled";
                }
            }
        };
        var rzp1 = new Razorpay(options);
        rzp1.on('payment.failed', function (response){
            alert(response.error.description);
            window.location.href = "${pageContext.request.contextPath}/checkout.jsp?error=Payment Failed";
        });
        
        window.onload = function() {
            rzp1.open();
        };
    </script>
</body>
</html>
