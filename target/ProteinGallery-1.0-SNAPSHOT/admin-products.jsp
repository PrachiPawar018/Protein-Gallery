<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inventory - Protein Gallery Admin</title>
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
        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card-bg);
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.05);
        }
        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            color: white;
        }
        th {
            background: rgba(255,255,255,0.02);
            color: var(--text-muted);
            text-transform: uppercase;
            font-size: 0.85rem;
        }
    </style>
</head>
<body>
    <div class="admin-layout">
        <div class="admin-sidebar">
            <h2 style="color:var(--primary-color); text-align:center; margin-bottom:2rem;">ADMIN</h2>
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/products" class="active">Inventory</a>
            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
            <a href="${pageContext.request.contextPath}/auth?action=logout" style="margin-top:2rem; color:var(--danger);">Logout</a>
        </div>
        
        <div class="admin-content">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:2rem;">
                <h1 style="color:white;">Inventory Management</h1>
                <button class="btn-primary" style="padding:0.5rem 1rem;">+ Add Product</button>
            </div>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <tr>
                            <td>${p.id}</td>
                            <td>${p.name}</td>
                            <td>$${p.price}</td>
                            <td>${p.stock}</td>
                            <td>
                                <button style="background:transparent; border:none; color:var(--primary-color); cursor:pointer;">Edit</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
