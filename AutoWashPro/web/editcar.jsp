<%@page import="dbo.Vehicle"%>

<%
    Vehicle car =
            (Vehicle)request.getAttribute("CAR");
%>

<h1>Edit Vehicle</h1>

<form action="savecar" method="post">

    <p>
        ID:
        <input type="text"
               name="txtid"
               value="<%=car.getId()%>"
               readonly />
    </p>

    <p>
        License Plate:
        <input type="text"
               name="txtlicenseplate"
               value="<%=car.getLicesePlate()%>" />
    </p>

    <p>
        Brand:
        <input type="text"
               name="txtbrand"
               value="<%=car.getBrand()%>" />
    </p>

    <p>
        Model:
        <input type="text"
               name="txtmodel"
               value="<%=car.getModel()%>" />
    </p>

    <p>
        Color:
        <input type="text"
               name="txtcolor"
               value="<%=car.getColor()%>" />
    </p>

    <input type="submit"
           value="Save"/>

</form>