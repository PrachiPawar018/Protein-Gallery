<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Protein Gallery - Fuel Your Fitness</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hero {
            background: linear-gradient(135deg, var(--bg-dark) 0%, #1e293b 100%);
            padding: 5rem 1rem;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .hero h1 {
            font-size: 3.5rem;
            font-weight: 900;
            color: white;
            margin-bottom: 1rem;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        .hero h1 span {
            color: var(--primary-color);
        }
        .hero p {
            font-size: 1.25rem;
            color: var(--text-muted);
            max-width: 600px;
            margin: 0 auto 2rem auto;
        }
        .hero .btn-primary {
            display: inline-block;
            width: auto;
            padding: 1rem 2.5rem;
            font-size: 1.1rem;
            text-decoration: none;
            border-radius: 30px;
        }
        
        .goals-section {
            padding: 5rem 1rem;
            max-width: 1200px;
            margin: 0 auto;
        }
        .goals-section h2 {
            text-align: center;
            margin-bottom: 3rem;
            font-size: 2.5rem;
            color: white;
            font-weight: 900;
        }
        .goals-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 2rem;
        }
        .goal-card {
            background-color: var(--card-bg);
            border: 1px solid rgba(255,255,255,0.05);
            border-radius: 16px;
            padding: 3rem 2rem;
            text-align: center;
            transition: transform 0.3s, border-color 0.3s, box-shadow 0.3s;
            cursor: pointer;
            text-decoration: none;
            color: white;
            display: block;
        }
        .goal-card:hover {
            transform: translateY(-10px);
            border-color: var(--primary-color);
            box-shadow: 0 10px 30px rgba(249, 115, 22, 0.2);
        }
        .goal-card h3 {
            color: var(--primary-color);
            margin-bottom: 1rem;
            font-size: 1.75rem;
            font-weight: 700;
        }
        .goal-card p {
            color: var(--text-muted);
            font-size: 1rem;
        }
    </style>
</head>
<body>
    <jsp:include page="WEB-INF/components/navbar.jsp" />

    <div class="hero">
        <h1>Fuel Your <span>Ambition</span></h1>
        <p>Premium sports nutrition and supplements tailored to your specific fitness goals. High-quality ingredients, uncompromising results.</p>
        <a href="products" class="btn-primary">Shop All Products</a>
    </div>

    <div class="goals-section">
        <h2>Shop By Your Goal</h2>
        <div class="goals-grid">
            <a href="products?goal=muscle-gain" class="goal-card">
                <h3>Muscle Gain</h3>
                <p>Whey, Mass Gainers & Creatine</p>
            </a>
            <a href="products?goal=weight-loss" class="goal-card">
                <h3>Weight Loss</h3>
                <p>Fat Burners & Lean Protein</p>
            </a>
            <a href="products?goal=endurance" class="goal-card">
                <h3>Endurance</h3>
                <p>Pre-workouts & BCAAs</p>
            </a>
            <a href="products?goal=beginner" class="goal-card">
                <h3>Beginner</h3>
                <p>Starter Stacks & Essentials</p>
            </a>
        </div>
    </div>
</body>
</html>
