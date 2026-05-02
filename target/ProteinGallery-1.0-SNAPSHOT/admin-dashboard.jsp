<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Protein Gallery</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-layout {
            display: flex;
            min-height: 100vh;
        }
        .admin-sidebar {
            width: 250px;
            background: #0f172a;
            border-right: 1px solid rgba(255,255,255,0.05);
            padding: 2rem 1rem;
        }
        .admin-sidebar a {
            display: block;
            color: var(--text-light);
            padding: 1rem;
            text-decoration: none;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            transition: background 0.3s;
        }
        .admin-sidebar a:hover, .admin-sidebar a.active {
            background: var(--primary-color);
            color: white;
            font-weight: bold;
        }
        .admin-content {
            flex-grow: 1;
            padding: 2rem;
            background: var(--bg-dark);
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }
        .stat-card {
            background: var(--card-bg);
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 12px;
            padding: 1.5rem;
        }
        .stat-title {
            color: var(--text-muted);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.5rem;
        }
        .stat-value {
            font-size: 2rem;
            color: white;
            font-weight: 900;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <div class="admin-sidebar">
            <h2 style="color:var(--primary-color); text-align:center; margin-bottom:2rem;">ADMIN</h2>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/products">Inventory</a>
            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/auth?action=logout" style="margin-top:2rem; color:var(--danger);">Logout</a>
        </div>
        
        <div class="admin-content">
            <h1 style="color:white; margin-bottom:2rem;">Dashboard Overview</h1>
            
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-title">Total Revenue</div>
                    <div class="stat-value">$${totalRevenue}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-title">Orders</div>
                    <div class="stat-value">${totalOrders}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-title">Products</div>
                    <div class="stat-value">${totalProducts}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-title">Users</div>
                    <div class="stat-value">${totalUsers}</div>
                </div>
            </div>

            <!-- Optional: Recent Orders Table -->
        </div>
    </div>
</body>
</html>
