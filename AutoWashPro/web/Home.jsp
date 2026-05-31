<%-- 
    Document   : Home
    Created on : May 29, 2026, 9:18:50 PM
    Author     : NKLT
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>AutoWash Pro</title>
    </head>
    <style>
/*Create a shared color variable- tạo biến màu dùng chung*/
:root{
    --primary:#1A8FE3;
    --primary-dark:#0D6EAF;
    --primary-light:#E3F3FF;

    --bg:#F0F8FF;
    --card:#FFFFFF;
    --border:#C9DFF0;

    --text:#1A2B3C;
    --text-light:#5A7080;

    --success:#2ECC71;
    --error:#E53E3E;

    --radius-card:10px;
    --radius-input:8px;
    --radius-btn:24px;
}

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:Inter,sans-serif;
}

body{
    background:var(--bg);
    color:var(--text);
}

.container{
    width:90%;
    max-width:1200px;
    margin:auto;
}

/* NAVBAR */

.navbar{
    height:60px;
    background:var(--primary);
    color:white;
}

.nav-content{
    height:100%;
    display:flex;
    align-items:center;
    justify-content:space-between;
}

.logo{
    font-size:22px;
    font-weight:700;
}

.nav-links{
    display:flex;
    gap:30px;
}

.nav-links a{
    color:white;
    text-decoration:none;
    font-weight:500;
}

.nav-actions{
    display:flex;
    gap:10px;
}

.btn{
    padding:10px 22px;
    border:none;
    cursor:pointer;
    border-radius:24px;
    text-decoration:none;
    font-weight:600;
}

.btn-white{
    background:white;
    color:var(--primary);
}

.btn-outline{
    border:1px solid white;
    background:transparent;
    color:white;
}

/* HERO */

.hero{
    background:linear-gradient(
        135deg,
        #1A8FE3,
        #5EB9FF
    );
    color:white;
    padding:80px 0;
}

.hero-content{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:50px;
}

.hero-left{
    flex:1;
}

.hero-left h1{
    font-size:52px;
    margin-bottom:20px;
}

.hero-left p{
    font-size:18px;
    margin-bottom:30px;
}

.hero-buttons{
    display:flex;
    gap:15px;
}

.hero-image{
    flex:1;
    text-align:center;
    font-size:180px;
}

/* PROMO */

.promo{
    margin:40px auto;
}

.banner{
    background:white;
    border:1px solid var(--border);
    border-left:5px solid var(--primary);
    padding:20px;
    border-radius:10px;
}

/* SERVICES */

.section-title{
    text-align:center;
    margin-bottom:40px;
}

.services{
    padding:40px 0 80px;
}

.service-grid{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(250px,1fr));
    gap:25px;
}

.card{
    background:white;
    border:1px solid var(--border);
    border-radius:10px;
    padding:25px;
}

.card-icon{
    font-size:40px;
    margin-bottom:15px;
}

.card h3{
    margin-bottom:10px;
}

.card p{
    color:var(--text-light);
    margin-bottom:15px;
}

.price{
    color:var(--primary);
    font-size:24px;
    font-weight:700;
    margin-bottom:15px;
}

.book-btn{
    width:100%;
    background:var(--primary);
    color:white;
}

/* FOOTER */

footer{
    background:white;
    padding:20px;
    text-align:center;
    border-top:1px solid var(--border);
}

/* RESPONSIVE */

@media(max-width:768px){

.hero-content{
    flex-direction:column;
    text-align:center;
}

.nav-links{
    display:none;
}

.hero-left h1{
    font-size:36px;
}

}

</style>


<body>

<!-- NAVBAR -->

<nav class="navbar">
    <div class="container nav-content">

        <div class="logo">AutoWash Pro</div>

        <div class="nav-links">
            <a href="Home.jsp">Home</a>
            <a href="#services">Services</a>
            <a href="booking">Book Now</a>
        </div>

        <div class="nav-actions">
            <a href="login.jsp" class="btn btn-outline">
                Login
            </a>

            <a href="register_page.jsp" class="btn btn-white">
                Create Account
            </a>
        </div>

    </div>
</nav>

<!-- HERO -->

<section class="hero">

    <div class="container hero-content">

        <div class="hero-left">

            <h1>Smart Car Wash, Anytime</h1>

            <p>
                Book your car wash online in seconds.
                Fast, convenient and professional service.
            </p>

            <div class="hero-buttons">

                <a href="booking" class="btn btn-white">
                    Book Now
                </a>

                <a href="#services" class="btn btn-outline">
                    View Services
                </a>

            </div>

        </div>

        <div class="hero-image">
            🚗
        </div>

    </div>

</section>

<!-- PROMOTION -->

<div class="container promo">
    <div class="banner">
        🎉 Summer Promotion: Get 20% OFF Premium Polish and Nano Coating this month!
    </div>
</div>

<!-- SERVICES -->

<section class="services" id="services">

<div class="container">

<h2 class="section-title">
Our Services
</h2>

<div class="service-grid">

<div class="card">
    <div class="card-icon">🚿</div>
    <h3>Basic Wash</h3>
    <p>Exterior wash and quick clean.</p>
    <div class="price">50.000đ</div>
    <button class="btn book-btn">
        Book Now
    </button>
</div>

<div class="card">
    <div class="card-icon">🧹</div>
    <h3>Wash + Vacuum</h3>
    <p>Exterior wash plus interior vacuum.</p>
    <div class="price">80.000đ</div>
    <button class="btn book-btn">
        Book Now
    </button>
</div>

<div class="card">
    <div class="card-icon">✨</div>
    <h3>Premium Polish</h3>
    <p>Professional polish and shine.</p>
    <div class="price">150.000đ</div>
    <button class="btn book-btn">
        Book Now
    </button>
</div>

<div class="card">
    <div class="card-icon">🛡️</div>
    <h3>Nano Coating</h3>
    <p>Long-lasting paint protection.</p>
    <div class="price">200.000đ</div>
    <button class="btn book-btn">
        Book Now
    </button>
</div>

</div>

</div>

</section>

<footer>
    © 2026 AutoWash Pro. All rights reserved.
</footer>

</body>
</html>