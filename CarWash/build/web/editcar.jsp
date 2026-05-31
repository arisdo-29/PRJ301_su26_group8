<%@ page import="dto.Vehicle" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Chỉnh sửa xe – AutoWash Pro</title>
  <style>
    body { margin:0; font-family:Inter,sans-serif; background:#F0F8FF; }
    .container { max-width:500px; margin:60px auto; background:white; padding:40px; border-radius:12px; box-shadow:0 2px 16px rgba(0,0,0,.08); }
    h2 { margin-bottom:24px; color:#1A2B3C; }
    .form-group { margin-bottom:16px; }
    label { display:block; font-weight:600; font-size:14px; margin-bottom:6px; color:#1A2B3C; }
    input[type=text] { width:100%; padding:10px 12px; border:1px solid #C9DFF0; border-radius:8px; font-size:14px; box-sizing:border-box; }
    input[readonly] { background:#f3f7fb; color:#888; }
    .btn { width:100%; padding:13px; background:#2979C8; color:white; border:none; border-radius:50px; font-size:16px; font-weight:700; cursor:pointer; margin-top:8px; }
    .btn:hover { background:#1B5FA3; }
    .back { display:inline-block; margin-bottom:20px; color:#2979C8; font-size:14px; text-decoration:none; font-weight:600; }
  </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<%
    // Lấy thông tin xe từ request attribute (truyền từ servlet editcar nếu có)
    // hoặc từ query params khi submit từ viewcars_page.jsp
    String idParam    = request.getParameter("txtid");
    String plateParam = request.getParameter("txtlicenseplate");
    String brandParam = request.getParameter("txtbrand");
    String modelParam = request.getParameter("txtmodel");
    String colorParam = request.getParameter("txtcolor");
%>

<div class="container">
  <a class="back" href="getcars">&larr; Quay lại danh sách xe</a>
  <h2>✏️ Chỉnh sửa thông tin xe</h2>

  <form action="savecar" method="post">

    <div class="form-group">
      <label>ID</label>
      <input type="text" name="txtid" value="<%= idParam != null ? idParam : "" %>" readonly/>
    </div>

    <div class="form-group">
      <label>Biển số xe</label>
      <input type="text" name="txtlicenseplate" value="<%= plateParam != null ? plateParam : "" %>"/>
    </div>

    <div class="form-group">
      <label>Hãng xe</label>
      <input type="text" name="txtbrand" value="<%= brandParam != null ? brandParam : "" %>"/>
    </div>

    <div class="form-group">
      <label>Model</label>
      <input type="text" name="txtmodel" value="<%= modelParam != null ? modelParam : "" %>"/>
    </div>

    <div class="form-group">
      <label>Màu sắc</label>
      <input type="text" name="txtcolor" value="<%= colorParam != null ? colorParam : "" %>"/>
    </div>

    <button class="btn" type="submit">Lưu thay đổi</button>
  </form>
</div>

</body>
</html>
