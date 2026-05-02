<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Premium sports nutrition and supplements for fitness goals. High-quality protein, creatine, pre-workouts, and more.">
    <meta name="keywords" content="protein supplements, whey protein, creatine, pre-workout, fitness supplements, sports nutrition">
    <title><c:out value="${pageTitle != null ? pageTitle : 'Protein Gallery - Fuel Your Fitness'}" /></title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;900&display=swap" rel="stylesheet">

    <!-- Global CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">

    <!-- CSRF Token for AJAX -->
    <script>
        window.csrfToken = '${sessionScope.csrf_token}';
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
</head>
<body>
    <!-- Header/Navbar -->
    <jsp:include page="WEB-INF/components/navbar.jsp" />

    <!-- Main Content Container -->
    <main class="main-content"></content>