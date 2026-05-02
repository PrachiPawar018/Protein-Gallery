<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Protein Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <h2>Join Protein Gallery</h2>
            
            <% String error = request.getParameter("error");
               if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>

            <form action="auth" method="POST">
                <input type="hidden" name="action" value="register">
                <input type="hidden" name="csrf_token" value="${sessionScope.csrf_token}">
                
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required placeholder="John Doe">
                </div>
                
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="you@example.com">
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" placeholder="+1234567890">
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required minlength="6" placeholder="At least 6 characters">
                </div>
                
                <button type="submit" class="btn-primary">Create Account</button>
            </form>
            
            <div class="auth-links">
                Already have an account? <a href="login.jsp">Login here</a>
            </div>
        </div>
    </div>
</body>
</html>
