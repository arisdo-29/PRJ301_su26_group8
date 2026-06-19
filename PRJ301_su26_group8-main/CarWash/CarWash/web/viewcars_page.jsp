<%@ page import="dto.Vehicle" %>
<%@ page import="dto.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>AutoWash Pro – Smart Car Wash</title>
  <style>
    body { margin:0; font-family:Inter,sans-serif; background:#F0F8FF; }
    .container { max-width:900px; margin:40px auto; padding:0 16px; }
    .header-row { display:flex; align-items:center; justify-content:space-between; margin-bottom:24px; }
    h2 { margin:0; color:#1A2B3C; }
    .btn-add { background:#22A06B; color:white; border:none; padding:10px 22px; border-radius:50px;
               cursor:pointer; font-weight:700; font-size:14px; text-decoration:none; display:inline-block; }
    .btn-add:hover { background:#1a8057; }
    table { width:100%; border-collapse:collapse; background:white; border-radius:10px; overflow:hidden; box-shadow:0 2px 10px rgba(0,0,0,.07); }
    th { background:#2979C8; color:white; padding:14px 16px; text-align:left; font-size:14px; }
    td { padding:12px 16px; border-bottom:1px solid #EEF4FB; font-size:14px; color:#1A2B3C; }
    tr:last-child td { border-bottom:none; }
    tr:hover td { background:#f7fbff; }
    .btn-edit { background:#2979C8; color:white; border:none; padding:6px 16px; border-radius:20px;
                cursor:pointer; font-weight:600; font-size:13px; }
    .btn-edit:hover { background:#1B5FA3; }
    .btn-delete { background:#E53E3E; color:white; border:none; padding:6px 16px; border-radius:20px;
                  cursor:pointer; font-weight:600; font-size:13px; margin-left:6px; }
    .btn-delete:hover { background:#C53030; }
    .empty { text-align:center; padding:60px; color:#718096; }
    .toast-success { background:#f0fff4; border:1px solid #9ae6b4; color:#276749; padding:12px 18px;
                     border-radius:8px; margin-bottom:20px; font-size:14px; font-weight:600; }
    .toast-error   { background:#fff0f0; border:1px solid #ffcccc; color:#cc0000; padding:12px 18px;
                     border-radius:8px; margin-bottom:20px; font-size:14px; font-weight:600; }
  </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<%
    User user = (User) session.getAttribute("USER");
    if (user == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String msg = request.getParameter("msg");
%>

<div class="container">

  <!-- Header + nút Thêm xe -->
  <div class="header-row">
    <h2>🚗 Xe của tôi</h2>
    <a class="btn-add" href="addcar">➕ Thêm xe mới</a>
  </div>

  <!-- Toast thông báo sau khi xóa -->
  <% if ("deleted".equals(msg)) { %>
    <div class="toast-success">✅ Xóa xe thành công!</div>
  <% } else if ("added".equals(msg)) { %>
    <div class="toast-success">✅ Thêm xe thành công!</div>
  <% } else if ("error".equals(msg)) { %>
    <div class="toast-error">❌ Xóa xe thất bại. Vui lòng thử lại!</div>
  <% } %>

  <%
      ArrayList<Vehicle> list = (ArrayList<Vehicle>) request.getAttribute("LISTCARS");
      if (list == null || list.isEmpty()) {
  %>
    <div class="empty">
      <p style="font-size:48px;margin-bottom:16px;">🚘</p>
      <p>Bạn chưa có xe nào được đăng ký.</p>
      <a class="btn-add" href="addcar">➕ Thêm xe đầu tiên</a>
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
      <td><%= v.getPlate() %></td>
      <td><%= v.getBrand() %></td>
      <td><%= v.getModel() %></td>
      <td><%= v.getColor() %></td>
      <td style="white-space:nowrap;">

        <!-- Nút Sửa -->
        <form action="editcar.jsp" method="get" style="display:inline;margin:0;">
          <input type="hidden" name="txtid"           value="<%= v.getId() %>"/>
          <input type="hidden" name="txtlicenseplate" value="<%= v.getPlate() %>"/>
          <input type="hidden" name="txtbrand"        value="<%= v.getBrand() %>"/>
          <input type="hidden" name="txtmodel"        value="<%= v.getModel() %>"/>
          <input type="hidden" name="txtcolor"        value="<%= v.getColor() %>"/>
          <button class="btn-edit" type="submit">✏️ Sửa</button>
        </form>

        <!-- Nút Xóa -->
        <form action="deletecar" method="post" style="display:inline;margin:0;"
              onsubmit="return confirm('Bạn có chắc muốn xóa xe biển số <%= v.getPlate() %>?');">
          <input type="hidden" name="txtid" value="<%= v.getId() %>"/>
          <button class="btn-delete" type="submit">🗑️ Xóa</button>
        </form>

      </td>
    </tr>
    <% } %>
  </table>
  <% } %>

</div>
</body>
</html>
