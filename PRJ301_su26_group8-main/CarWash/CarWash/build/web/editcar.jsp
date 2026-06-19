<%@ page import="dto.Vehicle" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>AutoWash Pro – Smart Car Wash</title>
  <style>
    body { margin:0; font-family:Inter,sans-serif; background:#F0F8FF; }
    .container { max-width:540px; margin:50px auto; padding:0 16px 40px; }
    .back { display:inline-block; margin-bottom:20px; color:#2979C8; font-size:14px; text-decoration:none; font-weight:600; }

    /* Tabs */
    .tabs { display:flex; border-radius:12px 12px 0 0; overflow:hidden; box-shadow:0 2px 10px rgba(0,0,0,.08); }
    .tab-btn { flex:1; padding:14px; background:#e8f1fb; border:none; font-size:14px; font-weight:700;
               color:#2979C8; cursor:pointer; transition:.2s; }
    .tab-btn.active { background:#2979C8; color:white; }
    .tab-btn:hover:not(.active) { background:#d0e4f7; }

    /* Card */
    .card { background:white; padding:32px; border-radius:0 0 12px 12px;
            box-shadow:0 2px 10px rgba(0,0,0,.08); }

    /* Form */
    .form-group { margin-bottom:16px; }
    label { display:block; font-weight:600; font-size:13px; margin-bottom:6px; color:#1A2B3C; }
    input[type=text] { width:100%; padding:10px 12px; border:1px solid #C9DFF0; border-radius:8px;
                       font-size:14px; box-sizing:border-box; transition:.2s; }
    input[type=text]:focus { outline:none; border-color:#2979C8; box-shadow:0 0 0 3px rgba(41,121,200,.15); }
    input[readonly] { background:#f3f7fb; color:#888; cursor:not-allowed; }

    /* Buttons */
    .btn { width:100%; padding:13px; border:none; border-radius:50px;
           font-size:15px; font-weight:700; cursor:pointer; margin-top:8px; }
    .btn-blue  { background:#2979C8; color:white; }
    .btn-blue:hover  { background:#1B5FA3; }
    .btn-green { background:#22A06B; color:white; }
    .btn-green:hover { background:#1a8057; }
    .btn-red   { background:#E53E3E; color:white; }
    .btn-red:hover   { background:#C53030; }

    /* Toast */
    .toast { padding:12px 16px; border-radius:8px; margin-bottom:18px; font-size:14px; font-weight:600; }
    .toast-ok  { background:#f0fff4; border:1px solid #9ae6b4; color:#276749; }
    .toast-err { background:#fff0f0; border:1px solid #ffcccc; color:#cc0000; }

    /* Delete confirm box */
    .delete-info { background:#fff5f5; border:1px solid #fed7d7; border-radius:8px;
                   padding:16px; margin-bottom:20px; }
    .delete-info p { margin:4px 0; font-size:14px; color:#1A2B3C; }
    .delete-info strong { color:#E53E3E; }
    .warn-text { font-size:13px; color:#718096; margin-top:12px !important; }

    /* Panel toggle */
    .panel { display:none; }
    .panel.active { display:block; }
  </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<%
    String idParam    = request.getParameter("txtid");
    String plateParam = request.getParameter("txtlicenseplate");
    String brandParam = request.getParameter("txtbrand");
    String modelParam = request.getParameter("txtmodel");
    String colorParam = request.getParameter("txtcolor");

    // Tab mặc định: nếu có id thì mở tab Sửa, không thì mở tab Thêm
    String defaultTab = (idParam != null && !idParam.isEmpty()) ? "edit" : "add";
    String errorParam = request.getParameter("error");
    if (errorParam != null) defaultTab = "add";

    String errorMsg   = (String) request.getAttribute("ERROR");
    String successMsg = (String) request.getAttribute("SUCCESS");
%>

<div class="container">
  <a class="back" href="getcars">&larr; Quay lại danh sách xe</a>

  <!-- Tabs -->
  <div class="tabs">
    <button class="tab-btn <%= "edit".equals(defaultTab) ? "active" : "" %>"
            onclick="switchTab('edit', this)">✏️ Chỉnh sửa xe</button>
    <button class="tab-btn <%= "add".equals(defaultTab) ? "active" : "" %>"
            onclick="switchTab('add', this)">➕ Thêm xe mới</button>
    <button class="tab-btn <%= "delete".equals(defaultTab) ? "active" : "" %>"
            onclick="switchTab('delete', this)">🗑️ Xóa xe</button>
  </div>

  <div class="card">

    <% if ("missing".equals(errorParam)) { %>
      <div class="toast toast-err">❌ Vui lòng nhập biển số xe và hãng xe!</div>
    <% } else if ("failed".equals(errorParam)) { %>
      <div class="toast toast-err">❌ Thêm xe thất bại. Vui lòng thử lại!</div>
    <% } %>
    <% if (errorMsg != null) { %>
      <div class="toast toast-err">❌ <%= errorMsg %></div>
    <% } %>
    <% if (successMsg != null) { %>
      <div class="toast toast-ok">✅ <%= successMsg %></div>
    <% } %>

    <!-- ========== PANEL: SỬA ========== -->
    <div id="panel-edit" class="panel <%= "edit".equals(defaultTab) ? "active" : "" %>">
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
        <button class="btn btn-blue" type="submit">💾 Lưu thay đổi</button>
      </form>
    </div>

    <!-- ========== PANEL: THÊM ========== -->
    <div id="panel-add" class="panel <%= "add".equals(defaultTab) ? "active" : "" %>">
      <form action="addcar" method="post">
        <div class="form-group">
          <label>Biển số xe <span style="color:red">*</span></label>
          <input type="text" name="txtlicenseplate" placeholder="VD: 51A-12345"/>
        </div>
        <div class="form-group">
          <label>Hãng xe <span style="color:red">*</span></label>
          <input type="text" name="txtbrand" placeholder="VD: Toyota, Honda..."/>
        </div>
        <div class="form-group">
          <label>Model</label>
          <input type="text" name="txtmodel" placeholder="VD: Camry, Civic..."/>
        </div>
        <div class="form-group">
          <label>Màu sắc</label>
          <input type="text" name="txtcolor" placeholder="VD: Trắng, Đen, Bạc..."/>
        </div>
        <button class="btn btn-green" type="submit">➕ Thêm xe</button>
      </form>
    </div>

    <!-- ========== PANEL: XÓA ========== -->
    <div id="panel-delete" class="panel <%= "delete".equals(defaultTab) ? "active" : "" %>">
      <% if (idParam != null && !idParam.isEmpty()) { %>
        <div class="delete-info">
          <p><strong>Xe sẽ bị xóa:</strong></p>
          <p>🪪 Biển số: <strong><%= plateParam != null ? plateParam : "—" %></strong></p>
          <p>🚗 Hãng / Model: <%= brandParam != null ? brandParam : "—" %> / <%= modelParam != null ? modelParam : "—" %></p>
          <p>🎨 Màu: <%= colorParam != null ? colorParam : "—" %></p>
          <p class="warn-text">⚠️ Hành động này không thể hoàn tác!</p>
        </div>
        <form action="deletecar" method="post"
              onsubmit="return confirm('Xác nhận xóa xe biển số <%= plateParam %>?');">
          <input type="hidden" name="txtid" value="<%= idParam %>"/>
          <button class="btn btn-red" type="submit">🗑️ Xác nhận xóa xe này</button>
        </form>
      <% } else { %>
        <p style="color:#718096;text-align:center;padding:30px 0;">
          Vui lòng chọn xe cần xóa từ <a href="getcars" style="color:#2979C8;font-weight:600;">danh sách xe</a>.
        </p>
      <% } %>
    </div>

  </div><!-- /card -->
</div>

<script>
  function switchTab(name, btn) {
    document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('panel-' + name).classList.add('active');
    btn.classList.add('active');
  }
</script>
</body>
</html>
