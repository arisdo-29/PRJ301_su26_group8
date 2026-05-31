<%@ page import="dto.Vehicle" %>
<%@ page import="dto.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Xe của tôi – AutoWash Pro</title>
  <style>
    body { margin:0; font-family:Inter,sans-serif; background:#F0F8FF; }
    .container { max-width:900px; margin:40px auto; padding:0 16px; }
    h2 { margin-bottom:24px; color:#1A2B3C; }
    table { width:100%; border-collapse:collapse; background:white; border-radius:10px; overflow:hidden; box-shadow:0 2px 10px rgba(0,0,0,.07); }
    th { background:#2979C8; color:white; padding:14px 16px; text-align:left; font-size:14px; }
    td { padding:12px 16px; border-bottom:1px solid #EEF4FB; font-size:14px; color:#1A2B3C; }
    tr:last-child td { border-bottom:none; }
    tr:hover td { background:#f7fbff; }
    .btn-edit { background:#2979C8; color:white; border:none; padding:6px 16px; border-radius:20px; cursor:pointer; font-weight:600; font-size:13px; }
    .btn-edit:hover { background:#1B5FA3; }
    .empty { text-align:center; padding:60px; color:#718096; }
  </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<%
    // Kiểm tra session — dùng key "USER" thống nhất
    User user = (User) session.getAttribute("USER");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<div class="container">
  <h2>🚗 Xe của tôi</h2>

  <%
      ArrayList<Vehicle> list = (ArrayList<Vehicle>) request.getAttribute("LISTCARS");
      if (list == null || list.isEmpty()) {
  %>
    <div class="empty">
      <p style="font-size:48px;margin-bottom:16px;">🚘</p>
      <p>Bạn chưa có xe nào được đăng ký.</p>
    </div>
  <%
      } else {
  %>
  <table>
    <tr>
      <th>ID</th>
      <th>Biển số</th>
      <th>Hãng xe</th>
      <th>Model</th>
      <th>Màu sắc</th>
      <th>Thao tác</th>
    </tr>
    <% for (Vehicle v : list) { %>
    <tr>
      <td><%= v.getId() %></td>
      <td><%= v.getPlate() %></td>   <%-- dùng getPlate() khớp với Vehicle.java --%>
      <td><%= v.getBrand() %></td>
      <td><%= v.getModel() %></td>
      <td><%= v.getColor() %></td>
      <td>
        <form action="editcar.jsp" method="get" style="margin:0;">
          <input type="hidden" name="txtid"          value="<%= v.getId() %>"/>
          <input type="hidden" name="txtlicenseplate" value="<%= v.getPlate() %>"/>
          <input type="hidden" name="txtbrand"        value="<%= v.getBrand() %>"/>
          <input type="hidden" name="txtmodel"        value="<%= v.getModel() %>"/>
          <input type="hidden" name="txtcolor"        value="<%= v.getColor() %>"/>
          <button class="btn-edit" type="submit">Sửa</button>
        </form>
      </td>
    </tr>
    <% } %>
  </table>
  <% } %>
</div>

</body>
</html>
