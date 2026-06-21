<%@ page import="dto.Booking" %>
<%@ page import="dto.Vehicle" %>
<%@ page import="dto.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Lịch sử rửa xe – AutoWash Pro</title>
  <style>
    body { margin:0; font-family:Inter,sans-serif; background:#F0F8FF; }
    .container { max-width:1000px; margin:40px auto; padding:0 16px 40px; }
    h2 { margin-bottom:24px; color:#1A2B3C; }

    .summary-row { display:flex; gap:16px; margin-bottom:24px; flex-wrap:wrap; }
    .summary-card { flex:1; min-width:200px; background:white; border-radius:12px; padding:20px 24px;
                    box-shadow:0 2px 10px rgba(0,0,0,.06); }
    .summary-label { font-size:13px; color:#718096; margin-bottom:6px; }
    .summary-value { font-size:26px; font-weight:800; color:#1A2B3C; }
    .summary-icon { font-size:22px; margin-bottom:4px; }

    /* Search/filter form */
    .filter-box { background:white; border-radius:12px; padding:18px 22px; margin-bottom:24px;
                  box-shadow:0 2px 10px rgba(0,0,0,.06); }
    .filter-form { display:flex; gap:14px; flex-wrap:wrap; align-items:flex-end; }
    .filter-group { display:flex; flex-direction:column; gap:6px; }
    .filter-group label { font-size:12px; font-weight:700; color:#1A2B3C; }
    .filter-group input { padding:9px 12px; border:1px solid #C9DFF0; border-radius:8px; font-size:14px; }
    .filter-group input:focus { outline:none; border-color:#2979C8; box-shadow:0 0 0 3px rgba(41,121,200,.15); }
    .btn-filter { background:#2979C8; color:white; border:none; padding:10px 22px; border-radius:8px;
                  font-weight:700; cursor:pointer; font-size:14px; height:39px; }
    .btn-filter:hover { background:#1B5FA3; }
    .btn-clear { display:flex; align-items:center; color:#718096; text-decoration:none; font-size:13px;
                 font-weight:600; padding:0 6px; height:39px; }
    .btn-clear:hover { color:#E53E3E; }

    table { width:100%; border-collapse:collapse; background:white; border-radius:10px; overflow:hidden;
            box-shadow:0 2px 10px rgba(0,0,0,.07); }
    th { background:#2979C8; color:white; padding:14px 16px; text-align:left; font-size:13px; }
    td { padding:12px 16px; border-bottom:1px solid #EEF4FB; font-size:14px; color:#1A2B3C; }
    tr:last-child td { border-bottom:none; }
    tr:hover td { background:#f7fbff; }

    .badge-status { display:inline-block; padding:4px 12px; border-radius:20px; font-size:12px; font-weight:700;
                    background:#e6f4ea; color:#1e7e34; }
    .price-cell { font-weight:700; color:#1A2B3C; }
    .price-discount { font-size:12px; color:#E53E3E; text-decoration:line-through; margin-right:6px; }
    .points-badge { display:inline-block; background:#FFF8E1; color:#B7860B; padding:3px 10px;
                    border-radius:14px; font-size:12px; font-weight:700; }

    .empty { text-align:center; padding:60px; color:#718096; }
    .back { display:inline-block; margin-bottom:20px; color:#2979C8; font-size:14px; text-decoration:none; font-weight:600; }
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

    ArrayList<Booking> list = (ArrayList<Booking>) request.getAttribute("HISTORY");
    Map<Integer, Vehicle> vehicleMap = (Map<Integer, Vehicle>) request.getAttribute("VEHICLE_MAP");
    Integer totalCount = (Integer) request.getAttribute("TOTAL_COUNT");
    Double totalSpend  = (Double) request.getAttribute("TOTAL_SPEND");

    String plateKeyword = (String) request.getAttribute("PLATE_KEYWORD");
    String fromDate      = (String) request.getAttribute("FROM_DATE");
    String toDate        = (String) request.getAttribute("TO_DATE");

    boolean hasFilter = (plateKeyword != null && !plateKeyword.trim().isEmpty())
                      || (fromDate != null && !fromDate.trim().isEmpty())
                      || (toDate != null && !toDate.trim().isEmpty());

    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
%>

<div class="container">
  <a class="back" href="getcars">&larr; Quay lại danh sách xe</a>
  <h2>🧾 Lịch sử rửa xe</h2>

  <div class="summary-row">
    <div class="summary-card">
      <div class="summary-icon">🚗</div>
      <div class="summary-label">Tổng số lần rửa xe</div>
      <div class="summary-value"><%= totalCount != null ? totalCount : 0 %></div>
    </div>
    <div class="summary-card">
      <div class="summary-icon">💰</div>
      <div class="summary-label">Tổng chi tiêu</div>
      <div class="summary-value"><%= currencyFormat.format(totalSpend != null ? totalSpend : 0) %>đ</div>
    </div>
  </div>

  <!-- Form tìm kiếm + lọc -->
  <div class="filter-box">
    <form class="filter-form" action="washhistory" method="get">
      <div class="filter-group">
        <label>Biển số xe</label>
        <input type="text" name="plate" placeholder="VD: 51A"
               value="<%= plateKeyword != null ? plateKeyword : "" %>"/>
      </div>
      <div class="filter-group">
        <label>Từ ngày</label>
        <input type="date" name="fromDate" value="<%= fromDate != null ? fromDate : "" %>"/>
      </div>
      <div class="filter-group">
        <label>Đến ngày</label>
        <input type="date" name="toDate" value="<%= toDate != null ? toDate : "" %>"/>
      </div>
      <button class="btn-filter" type="submit">🔍 Tìm kiếm</button>
      <% if (hasFilter) { %>
        <a class="btn-clear" href="washhistory">✕ Xóa lọc</a>
      <% } %>
    </form>
  </div>

  <%
      if (list == null || list.isEmpty()) {
  %>
    <div class="empty">
      <p style="font-size:48px;margin-bottom:16px;">🧽</p>
      <p><%= hasFilter ? "Không tìm thấy kết quả phù hợp với bộ lọc." : "Bạn chưa có lịch sử rửa xe nào." %></p>
    </div>
  <%
      } else {
  %>
  <table>
    <tr>
      <th>Ngày</th>
      <th>Biển số xe</th>
      <th>Trạng thái</th>
      <th>Giá tiền</th>
      <th>Thanh toán</th>
      <th>Điểm thưởng</th>
    </tr>
    <% for (Booking b : list) {
         Vehicle v = vehicleMap != null ? vehicleMap.get(b.getVehicleId()) : null;
    %>
    <tr>
      <td>
        <%= b.getScheduledDate() %><br/>
        <span style="color:#718096;font-size:12px;"><%= b.getScheduledTime() %></span>
      </td>
      <td>
        <% if (v != null) { %>
          <strong><%= v.getPlate() %></strong><br/>
          <span style="color:#718096;font-size:12px;"><%= v.getBrand() %> <%= v.getModel() %></span>
        <% } else { %>
          <span style="color:#a0aec0;">Xe #<%= b.getVehicleId() %> (đã xóa)</span>
        <% } %>
      </td>
      <td><span class="badge-status">✅ Đã check-in</span></td>
      <td class="price-cell">
        <% if (b.getDiscount() > 0) { %>
          <span class="price-discount"><%= currencyFormat.format(b.getPrice()) %>đ</span><br/>
        <% } %>
        <%= currencyFormat.format(b.getPrice() - b.getDiscount()) %>đ
      </td>
      <td><%= b.getPayMethod() != null ? b.getPayMethod() : "—" %></td>
      <td>
        <% if (b.getPointsEarn() > 0) { %>
          <span class="points-badge">+<%= b.getPointsEarn() %> điểm</span>
        <% } else { %>
          —
        <% } %>
      </td>
    </tr>
    <% } %>
  </table>
  <% } %>

</div>
</body>
</html>