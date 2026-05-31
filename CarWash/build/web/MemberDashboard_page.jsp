<%@ page import="dto.User" %>
<%@ page import="dto.LoyaltyAccount" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Dashboard – AutoWash Pro</title>
  <style>
    body { margin:0; font-family:Inter,sans-serif; background:#F0F8FF; }
    .container { max-width:960px; margin:40px auto; padding:0 16px; }
    .welcome { font-size:24px; font-weight:700; color:#1A2B3C; margin-bottom:6px; }
    .sub { color:#718096; font-size:15px; margin-bottom:32px; }
    .cards { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:20px; }
    .card { background:white; border-radius:12px; padding:28px; box-shadow:0 2px 12px rgba(0,0,0,.06); }
    .card-icon { font-size:32px; margin-bottom:12px; }
    .card-label { font-size:13px; color:#718096; margin-bottom:6px; font-weight:600; text-transform:uppercase; letter-spacing:.05em; }
    .card-value { font-size:28px; font-weight:800; color:#1A2B3C; }
    .card-sub { font-size:13px; color:#718096; margin-top:4px; }
    .actions { margin-top:32px; display:flex; gap:14px; flex-wrap:wrap; }
    .btn { padding:12px 24px; border:none; border-radius:50px; font-weight:700; font-size:15px; cursor:pointer; text-decoration:none; display:inline-block; }
    .btn-primary { background:#2979C8; color:white; }
    .btn-primary:hover { background:#1B5FA3; }
    .btn-outline { background:white; color:#2979C8; border:2px solid #2979C8; }
    .btn-outline:hover { background:#EBF3FB; }
    .tier-badge { display:inline-block; padding:4px 14px; border-radius:50px; font-size:13px; font-weight:700; margin-left:10px; }
    .tier-bronze  { background:#F5E6D3; color:#8B5E3C; }
    .tier-silver  { background:#E8E8F0; color:#5A5A7A; }
    .tier-gold    { background:#FEF9E7; color:#B8860B; }
    .tier-platinum{ background:#EAF7FF; color:#1A6FA8; }
  </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<%
    User currentUser = (User) session.getAttribute("USER");
    if (currentUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    LoyaltyAccount account = (LoyaltyAccount) request.getAttribute("account");

    String tierName  = (account != null) ? account.getTierName()  : "Bronze";
    int    points    = (account != null) ? account.getPoints()     : 0;
    int    totalWash = (account != null) ? account.getTotalWashes(): 0;

    String tierCss = "tier-bronze";
    if ("Silver".equalsIgnoreCase(tierName))   tierCss = "tier-silver";
    else if ("Gold".equalsIgnoreCase(tierName)) tierCss = "tier-gold";
    else if ("Platinum".equalsIgnoreCase(tierName)) tierCss = "tier-platinum";
%>

<div class="container">
  <div class="welcome">
    Xin chào, <%= currentUser.getFullName() %>!
    <span class="tier-badge <%= tierCss %>"><%= tierName %></span>
  </div>
  <p class="sub">Chào mừng bạn quay lại AutoWash Pro ✨</p>

  <div class="cards">
    <div class="card">
      <div class="card-icon">⭐</div>
      <div class="card-label">Điểm hiện tại</div>
      <div class="card-value"><%= points %></div>
      <div class="card-sub">điểm thưởng</div>
    </div>
    <div class="card">
      <div class="card-icon">🚿</div>
      <div class="card-label">Tổng lần rửa</div>
      <div class="card-value"><%= totalWash %></div>
      <div class="card-sub">lượt rửa xe</div>
    </div>
    <div class="card">
      <div class="card-icon">🏆</div>
      <div class="card-label">Hạng thành viên</div>
      <div class="card-value"><%= tierName %></div>
      <div class="card-sub">hạng hiện tại</div>
    </div>
    <div class="card">
      <div class="card-icon">📧</div>
      <div class="card-label">Email</div>
      <div class="card-value" style="font-size:16px;word-break:break-all;"><%= currentUser.getEmail() %></div>
    </div>
  </div>

  <div class="actions">
    <a href="getcars"   class="btn btn-primary">🚗 Xe của tôi</a>
    <a href="my-points" class="btn btn-outline">⭐ Điểm thưởng</a>
    <a href="logout"    class="btn btn-outline">Đăng xuất</a>
  </div>
</div>

</body>
</html>
