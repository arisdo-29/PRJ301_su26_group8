
<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User navbarUser = (User) session.getAttribute("USER");
%>

<nav style="background:#2979C8;padding:0 2rem;height:56px;display:flex;align-items:center;justify-content:space-between;">
  <a href="index.jsp" style="color:white;font-weight:800;font-size:1.1rem;text-decoration:none;">💧 AutoWash Pro</a>
  <div style="display:flex;gap:1.5rem;align-items:center;">
    <% if (navbarUser == null) { %>
      <a href="index.jsp" style="color:white;text-decoration:none;font-weight:600;">Trang chủ</a>
      <a href="login_page.jsp" style="color:white;text-decoration:none;font-weight:600;">Đăng nhập</a>
      <a href="register_page.jsp" style="background:white;color:#2979C8;padding:6px 18px;border-radius:50px;font-weight:700;text-decoration:none;">Đăng ký</a>
    <% } else if (!"CUSTOMER".equalsIgnoreCase(navbarUser.getRole())) { %>
      <a href="admin_page.jsp" style="color:white;text-decoration:none;font-weight:600;">Dashboard</a>
      <a href="admin_page.jsp" style="color:white;text-decoration:none;font-weight:600;">Quản lý phần thưởng và khuyến mãi</a>
      <a href="admin_page.jsp" style="color:white;text-decoration:none;font-weight:600;">Lịch sử đổi thưởng</a>     
      <a href="logout" style="color:white;text-decoration:none;font-weight:600;">Đăng xuất</a>
    <% } else { %>
      <a href="HomeMember_page.jsp" style="color:white;text-decoration:none;font-weight:600;">Trang chủ</a>
      <a href="EditProfile" style="color:white;text-decoration:none;font-weight:600;">Chỉnh sửa hồ sơ</a>
      <a href="getcars" style="color:white;text-decoration:none;font-weight:600;">Xe của tôi</a>
      <a href="my-points" style="color:white;text-decoration:none;font-weight:600;">Điểm thưởng</a>
      <a href="logout" style="background:rgba(255,255,255,0.2);color:white;padding:6px 18px;border-radius:50px;font-weight:700;text-decoration:none;">Đăng xuất</a>
    <% } %>
  </div>
</nav>
