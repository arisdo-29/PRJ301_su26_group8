<%@ page import="dto.LoyaltyAccount" %>
<%@ page import="dto.PointLog" %>
<%@ page import="dto.Reward" %>
<%@ page import="dto.User" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Điểm thưởng – AutoWash Pro</title>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: Inter, sans-serif; background: #F0F8FF; }
    .container { max-width: 960px; margin: 36px auto; padding: 0 16px; }

    /* TOAST */
    .toast-ok  { background:#ECFDF5; border:1px solid #6EE7B7; color:#065F46; padding:12px 16px; border-radius:8px; margin-bottom:20px; font-weight:600; }
    .toast-err { background:#FEF2F2; border:1px solid #FECACA; color:#DC2626; padding:12px 16px; border-radius:8px; margin-bottom:20px; font-weight:600; }

    /* HEADER CARD */
    .account-card {
      background: linear-gradient(135deg, #2979C8, #5BA4F5);
      border-radius: 14px; padding: 32px; color: white;
      display: flex; justify-content: space-between; align-items: center;
      margin-bottom: 24px; flex-wrap: wrap; gap: 20px;
    }
    .account-card h2 { font-size: 22px; font-weight: 800; margin-bottom: 6px; }
    .account-card .sub { opacity: 0.85; font-size: 14px; }
    .points-big { font-size: 56px; font-weight: 900; line-height: 1; }
    .points-lbl { font-size: 13px; opacity: 0.8; margin-top: 4px; }

    /* STATS ROW */
    .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 16px; margin-bottom: 28px; }
    .stat-card { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,.06); }
    .stat-card .lbl { font-size: 12px; color: #718096; font-weight: 700; text-transform: uppercase; letter-spacing:.05em; margin-bottom:6px; }
    .stat-card .val { font-size: 24px; font-weight: 800; color: #1A2B3C; }

    /* SECTION TITLE */
    .section-title { font-size: 17px; font-weight: 800; color: #1A2B3C; margin-bottom: 14px; margin-top: 32px; }

    /* REWARDS GRID */
    .rewards-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px; margin-bottom: 32px; }
    .reward-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 2px 8px rgba(0,0,0,.06); display: flex; flex-direction: column; gap: 10px; }
    .reward-name { font-weight: 800; font-size: 15px; color: #1A2B3C; }
    .reward-cost { font-size: 22px; font-weight: 900; color: #2979C8; }
    .reward-cost span { font-size: 13px; font-weight: 600; color: #718096; }
    .reward-type { font-size: 12px; background: #EBF3FB; color: #2979C8; padding: 3px 10px; border-radius: 50px; font-weight: 700; display: inline-block; width: fit-content; }
    .btn-redeem {
      margin-top: auto; padding: 9px; background: #2979C8; color: white;
      border: none; border-radius: 50px; font-weight: 700; font-size: 14px;
      cursor: pointer; transition: background .2s;
    }
    .btn-redeem:hover { background: #1B5FA3; }
    .btn-redeem:disabled { background: #CBD5E0; cursor: not-allowed; }

    /* LOG TABLE */
    .log-table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,.06); }
    .log-table th { background: #2979C8; color: white; padding: 12px 16px; text-align: left; font-size: 13px; }
    .log-table td { padding: 11px 16px; border-bottom: 1px solid #EEF4FB; font-size: 14px; color: #1A2B3C; }
    .log-table tr:last-child td { border-bottom: none; }
    .amount-earn   { color: #059669; font-weight: 700; }
    .amount-redeem { color: #DC2626; font-weight: 700; }
    .empty-state { text-align: center; padding: 48px; color: #718096; font-size: 15px; }
  </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<%
    User user       = (User) session.getAttribute("USER");
    if (user == null) { response.sendRedirect("index.jsp"); return; }

    LoyaltyAccount account = (LoyaltyAccount) request.getAttribute("account");
    List<PointLog>  logs    = (List<PointLog>)  request.getAttribute("logs");
    List<Reward>    rewards = (List<Reward>)    request.getAttribute("rewards");

    String successMsg = (String) request.getAttribute("SUCCESS");
    String errorMsg   = (String) request.getAttribute("ERROR");
%>

<div class="container">

  <%-- TOAST --%>
  <% if (successMsg != null) { %><div class="toast-ok">✅ <%= successMsg %></div><% } %>
  <% if (errorMsg   != null) { %><div class="toast-err">⚠️ <%= errorMsg %></div><% } %>

  <%-- ACCOUNT HEADER --%>
  <% if (account != null) { %>
  <div class="account-card">
    <div>
      <h2>Điểm thưởng của bạn</h2>
      <div class="sub">Hạng: <strong><%= account.getTierName() %></strong> &nbsp;·&nbsp; Tổng đã tích: <%= account.getTotalPoints() %> điểm</div>
    </div>
    <div style="text-align:right;">
      <div class="points-big"><%= account.getPoints() %></div>
      <div class="points-lbl">điểm khả dụng</div>
    </div>
  </div>

  <%-- STATS --%>
  <div class="stats">
    <div class="stat-card"><div class="lbl">Tổng lần rửa</div><div class="val"><%= account.getTotalWashes() %></div></div>
    <div class="stat-card"><div class="lbl">Tổng chi tiêu</div><div class="val"><%= String.format("%,d", account.getTotalSpend()) %>đ</div></div>
    <div class="stat-card"><div class="lbl">Hạng</div><div class="val"><%= account.getTierName() %></div></div>
  </div>
  <% } else { %>
  <div class="empty-state">⭐ Tài khoản điểm thưởng của bạn chưa được khởi tạo.</div>
  <% } %>

  <%-- REWARDS --%>
  <% if (rewards != null && !rewards.isEmpty()) { %>
  <div class="section-title">🎁 Đổi thưởng</div>
  <div class="rewards-grid">
    <% for (Reward r : rewards) {
         boolean canRedeem = (account != null && account.getPoints() >= r.getPointsCost());
    %>
    <div class="reward-card">
      <div class="reward-name"><%= r.getName() %></div>
      <div class="reward-type"><%= r.getType() %></div>
      <div class="reward-cost"><%= r.getPointsCost() %> <span>điểm</span></div>
      <form action="my-points" method="post" style="margin:0;">
        <input type="hidden" name="action"   value="redeem"/>
        <input type="hidden" name="rewardId" value="<%= r.getId() %>"/>
        <button class="btn-redeem" type="submit" <%= canRedeem ? "" : "disabled" %>>
          <%= canRedeem ? "Đổi ngay" : "Không đủ điểm" %>
        </button>
      </form>
    </div>
    <% } %>
  </div>
  <% } %>

  <%-- POINT LOGS --%>
  <div class="section-title">📋 Lịch sử điểm (10 gần nhất)</div>
  <% if (logs == null || logs.isEmpty()) { %>
  <div class="empty-state">Chưa có lịch sử điểm nào.</div>
  <% } else { %>
  <table class="log-table">
    <tr>
      <th>Thời gian</th>
      <th>Loại</th>
      <th>Điểm</th>
      <th>Số dư</th>
      <th>Ghi chú</th>
    </tr>
    <% for (PointLog log : logs) { %>
    <tr>
      <td><%= log.getCreatedAt() %></td>
      <td><%= log.getType() %></td>
      <td class="<%= log.getAmount() >= 0 ? "amount-earn" : "amount-redeem" %>">
        <%= log.getAmount() >= 0 ? "+" : "" %><%= log.getAmount() %>
      </td>
      <td><%= log.getBalance() %></td>
      <td><%= log.getNote() != null ? log.getNote() : "-" %></td>
    </tr>
    <% } %>
  </table>
  <% } %>

</div>
</body>
</html>
