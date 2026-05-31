<%@page import="dbo.Vehicle"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dbo.Customer"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vehicle List</title>
</head>
<body>

<%
    Customer user = (Customer) session.getAttribute("User");

    if(user == null){
        response.sendRedirect("index.jsp");
        return;
    }
%>

<jsp:include page="menu.jsp"/>

<h2>My Vehicles</h2>

<%
    ArrayList<Vehicle> list =
            (ArrayList<Vehicle>) request.getAttribute("LISTCARS");

    if(list == null || list.isEmpty()){
%>

    <h3>You have no vehicles.</h3>

<%
    } else {
%>

<table border="1">

    <tr>
        <th>ID</th>
        <th>License Plate</th>
        <th>Brand</th>
        <th>Model</th>
        <th>Color</th>
        <th>Action</th>
    </tr>

<%
    for(Vehicle v : list){
%>

<tr>

    <td><%= v.getId() %></td>
    <td><%= v.getLicensePlate() %></td>
    <td><%= v.getBrand() %></td>
    <td><%= v.getModel() %></td>
    <td><%= v.getColor() %></td>

    <td>

        <form action="editcar" method="get">

            <input type="hidden"
                   name="txtid"
                   value="<%= v.getId() %>"/>

            <input type="hidden"
                   name="txtlicenseplate"
                   value="<%= v.getLicensePlate() %>"/>

            <input type="hidden"
                   name="txtbrand"
                   value="<%= v.getBrand() %>"/>

            <input type="hidden"
                   name="txtmodel"
                   value="<%= v.getModel() %>"/>

            <input type="hidden"
                   name="txtcolor"
                   value="<%= v.getColor() %>"/>

            <input type="submit"
                   value="Edit"/>

        </form>

    </td>

</tr>

<%
    }
%>

</table>

<%
    }
%>

</body>
</html>