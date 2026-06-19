<%-- 
    Document   : admin_page
    Created on : May 31, 2026, 8:55:20 AM
    Author     : NKLT
--%>

<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("USER");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard - AutoWash Pro</title>
    </head>
    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family: Arial, sans-serif;
        }

        body{
            background:#f4f6f9;
        }

        .navbar{
            background:#1f2937;
            color:white;
            padding:15px 30px;
            display:flex;
            justify-content:space-between;
            align-items:center;
        }

        .navbar a{
            color:white;
            text-decoration:none;
            margin-left:20px;
        }

        .container{
            width:90%;
            margin:30px auto;
        }

        .welcome{
            background:white;
            padding:20px;
            border-radius:10px;
            margin-bottom:20px;
            box-shadow:0 2px 5px rgba(0,0,0,0.1);
        }

        .cards{
            display:grid;
            grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
            gap:20px;
        }

        .card{
            background:white;
            padding:25px;
            border-radius:10px;
            text-align:center;
            box-shadow:0 2px 5px rgba(0,0,0,0.1);
        }

        .card h2{
            color:#2563eb;
            margin-bottom:10px;
        }

        .card a{
            text-decoration:none;
            color:#2563eb;
            font-weight:bold;
        }
    </style>
</head>

<body>

    <div class="navbar">
        <h2>AutoWash Pro - Admin</h2>

        <div>
            <span>Welcome, <%= user.getFullName() %></span>

            <a href="admin_page.jsp">Home</a>
            <a href="logout">Logout</a>
        </div>
    </div>

    <div class="container">

        <div class="welcome">
            <h1>Admin Dashboard</h1>
            <p>Manage AutoWash Pro System</p>
        </div>

        <div class="cards">

            <div class="card">
                <h2>Users</h2>
                <p>Manage user accounts</p>
                <a href="UserManagementServlet">View</a>
            </div>

            <div class="card">
                <h2>Customers</h2>
                <p>Manage customer information</p>
                <a href="CustomerManagementServlet">View</a>
            </div>

            <div class="card">
                <h2>Services</h2>
                <p>Manage wash services</p>
                <a href="ServiceManagementServlet">View</a>
            </div>

            <div class="card">
                <h2>Promotions</h2>
                <p>Manage promotions</p>
                <a href="PromotionManagementServlet">View</a>
            </div>

            <div class="card">
                <h2>Bookings</h2>
                <p>Manage bookings</p>
                <a href="BookingManagementServlet">View</a>
            </div>

            <div class="card">
                <h2>Reports</h2>
                <p>View system reports</p>
                <a href="ReportServlet">View</a>
            </div>

        </div>

    </div>

</body>
</html>