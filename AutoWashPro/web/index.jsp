
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AutoWash Pro - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .hero {
            background-color: #1a7fc1;
            color: white;
            padding: 60px 40px;
        }
        .hero h1 { font-size: 36px; margin: 0 0 12px 0; }
        .hero p  { font-size: 16px; margin: 0 0 24px 0; opacity: 0.9; }
        .hero a  {
            background-color: white;
            color: #1a7fc1;
            padding: 10px 24px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: bold;
        }

        .page-body {
            max-width: 400px;
            margin: 50px auto;
            padding: 0 16px;
        }

        .page-body h2 {
            text-align: center;
            margin-bottom: 4px;
        }

        .page-body .subtitle {
            text-align: center;
            color: #666;
            font-size: 14px;
            margin-bottom: 24px;
        }

        .divider {
            height: 1px;
            background: #eee;
            margin: 16px 0;
        }

        .icon-box {
            text-align: center;
            margin-bottom: 14px;
            font-size: 36px;
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
    <a href="index.jsp" class="logo"><span>&#128167;</span> AutoWash Pro</a>
    <div class="nav-links">
        <a href="index.jsp">Home</a>
        <a href="index.jsp">Services</a>
        <a href="index.jsp">Book Now</a>
        <a href="login_page.jsp" class="btn-outline">Login</a>
        <a href="register_page.jsp" class="btn-white">Register</a>
    </div>
</div>

<!-- HERO -->
<div class="hero">
    <h1>Welcome to AutoWash Pro</h1>
    <p>Book your car wash online. Fast, easy, professional.</p>
    <a href="register_page.jsp">Get Started Free</a>
</div>

</body>
</html>

