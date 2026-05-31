<%-- 
    Document   : navbar
    Created on : May 30, 2026, 7:41:39 PM
    Author     : NKLT
--%>

<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
    User user = (User) session.getAttribute("user");
    %>

    <nav>

        <% if(user == null){ %>

            <a href="index.jsp">Home</a>
            <a href="login_page.jsp">Login</a>
            <a href="register_page.jsp">Register</a>

        <% } else if("ADMIN".equals(user.getRole())) { %>

            <a href="dashboard">Dashboard</a>
            <a href="manageUsers">Users</a>
            <a href="logout">Logout</a>

        <% } else { %>

            <a href="index.jsp">Home</a>
            <a href="booking">Booking</a>
            <a href="myVehicles">My Vehicles</a>
            <a href="profile">Profile</a>
            <a href="logout">Logout</a>

        <% } %>

        </nav>
    </body>
</html>
