<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User navbarUser = (User) session.getAttribute("USER");

    // Lấy thông báo thành công từ session (nếu có, sau khi add reward/promotion)
    String navSuccessMsg = (String) session.getAttribute("SUCCESS_MSG");
    if (navSuccessMsg != null) {
        session.removeAttribute("SUCCESS_MSG"); // Xóa sau khi đọc, tránh hiển thị lại
    }
%>

<%-- Hiển thị toast thành công nếu có (dùng sau khi addReward/addPromotion redirect về manageReward) --%>
<% if (navSuccessMsg != null) { %>
<div style="background:#ECFDF5;border:1px solid #6EE7B7;color:#065F46;
            padding:10px 20px;text-align:center;font-size:14px;font-weight:600;">
    ✅ <%= navSuccessMsg %>
</div>
<% } %>

<nav style="background:#2979C8;padding:0 2rem;height:56px;display:flex;align-items:center;justify-content:space-between;">
  <a href="index.jsp" style="color:white;font-weight:800;font-size:1.1rem;text-decoration:none;">💧 AutoWash Pro</a>
  <div style="display:flex;gap:1.5rem;align-items:center;">
    <% if (navbarUser == null) { %>
      <a href="index.jsp"         style="color:white;text-decoration:none;font-weight:600;">Trang chủ</a>
      <a href="login_page.jsp"    style="color:white;text-decoration:none;font-weight:600;">Đăng nhập</a>
      <a href="register_page.jsp" style="background:white;color:#2979C8;padding:6px 18px;border-radius:50px;font-weight:700;text-decoration:none;">Đăng ký</a>

    <% } else if (!"CUSTOMER".equalsIgnoreCase(navbarUser.getRole())) { %>
      <%-- Menu cho ADMIN / MANAGER / STAFF --%>
      <a href="admin_page.jsp" style="color:white;text-decoration:none;font-weight:600;">Dashboard</a>

      <%-- ĐÃ SỬA: đổi href từ "admin_page.jsp" sang "manageReward" (servlet mới) --%>
      <a href="manageReward"   style="color:white;text-decoration:none;font-weight:600;">Phần thưởng & KM</a>

      <a href="logout"         style="color:white;text-decoration:none;font-weight:600;">Đăng xuất</a>

    <% } else { %>
      <%-- Menu cho CUSTOMER --%>
      <a href="HomeMember_page.jsp" style="color:white;text-decoration:none;font-weight:600;">Trang chủ</a>
      <a href="EditProfile"         style="color:white;text-decoration:none;font-weight:600;">Hồ sơ</a>
      <a href="getcars"             style="color:white;text-decoration:none;font-weight:600;">Xe của tôi</a>
      <a href="my-points"           style="color:white;text-decoration:none;font-weight:600;">Điểm thưởng</a>
      <a href="logout" style="background:rgba(255,255,255,0.2);color:white;padding:6px 18px;border-radius:50px;font-weight:700;text-decoration:none;">Đăng xuất</a>
    <% } %>
  </div>
</nav>
