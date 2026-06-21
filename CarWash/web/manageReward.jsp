<%@ page import="dto.User" %>
<%@ page import="dto.Reward" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
    manageReward.jsp - Trang quan ly Phan thuong & Khuyen mai (danh cho Admin)
    Du lieu duoc load boi servlet manageReward.java

    -- JSP Standard Action dung trong trang nay --
    <jsp:include page="navbar.jsp"/> : nhung thanh dieu huong vao trang

    -- Expression Language (EL) + JSTL dung trong trang nay --
    ${sessionScope.USER.fullName}     : lay ten nguoi dung tu session
    ${requestScope.rewards.size()}    : dem so phan thuong tu request
    ${requestScope.promotions.size()} : dem so khuyen mai tu request
    ${requestScope.SUCCESS}           : hien thi thong bao thanh cong

    -- DA SUA (theo yeu cau) --
    1) Loi phong chu: trang cu dung font-family: Inter nhung KHONG import
       Google Fonts nen trinh duyet fallback ve font he thong xau.
       -> Da them <link> Google Fonts "Inter" vao <head>.
    2) Loi giao dien "Dang hoat dong" bi tach dong do badge qua hep
       khong du cho chua chu tren 1 dong.
       -> Da sua CSS .badge-active/.badge-inactive: them white-space: nowrap,
          dong thoi boc bang trong .table-scroll (overflow-x: auto) de bang
          co the cuon ngang tren man hinh nho thay vi bi vo layout.
    3) Cot so thu tu (#): truoc day lay r.getId() / p.getId() (ID that
       trong database, co the nhay so khi xoa du lieu). Theo yeu cau,
       doi sang dem tuan tu bang JSTL <c:forEach varStatus="status">
       va in ra ${status.count}, bat dau tu 1 va luon lien tuc bat ke
       ID goc trong DB la gi.
       -> Toan bo vong lap hien thi bang duoc chuyen tu scriptlet
          (<% for (...) %>) sang JSTL <c:forEach> de dung duoc varStatus.
    4) Them cot "Thao tac" voi 2 nut Sua / Xoa cho tung dong (yeu cau moi):
       - Nut "Sua" -> lien ket toi editReward?id=... (servlet editReward MOI THEM)
       - Nut "Xoa" -> lien ket toi deleteReward?id=... (servlet deleteReward
         MOI THEM), co xac nhan (confirm) bang JavaScript truoc khi xoa.
       Luu y: nut Xoa thuc chat goi servlet deleteReward de XOA MEM
       (set is_active = 0), khong xoa cung khoi database, de khong vo
       khoa ngoai voi bang redemptions.
--%>

<%-- Chan truy cap: chua dang nhap hoac khong phai admin -> ve trang chu --%>
<%
    User user = (User) session.getAttribute("USER");
    if (user == null || "CUSTOMER".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Lay danh sach tu request (da duoc servlet set vao)
    List<Reward> rewards    = (List<Reward>) request.getAttribute("rewards");
    List<Reward> promotions = (List<Reward>) request.getAttribute("promotions");
    String successMsg = (String) request.getAttribute("SUCCESS");
    String errorMsg   = (String) request.getAttribute("ERROR");

    // Dua list vao pageContext de JSTL <c:forEach> doc duoc qua EL
    pageContext.setAttribute("rewardList", rewards);
    pageContext.setAttribute("promoList", promotions);
%>

<%--
    Khai bao ham tien ich (JSP Declaration Block <%! %>)
    Cac ham nay co the goi tu bat ky cho nao trong trang.
--%>
<%!
    // Chuyen ma type thanh ten tieng Viet de doc
    private String getTypeName(String type) {
        if (type == null) return "-";
        switch (type) {
            case "FREE_WASH":    return "🚿 Rửa miễn phí";
            case "DISC_PERCENT": return "% Giảm phần trăm";
            case "DISC_VND":     return "đ Giảm theo VND";
            case "FREE_UPGRADE": return "⬆ Nâng cấp";
            default:             return type;
        }
    }

    // Hien thi gia tri giam theo loai
    private String getValueDisplay(String type, double value) {
        if ("DISC_PERCENT".equals(type)) return (int) value + "%";
        if ("DISC_VND".equals(type))     return String.format("%,.0f đ", value);
        return "-";
    }

    // Chuyen min_tier_id thanh ten hang
    private String getTierName(Integer tierId) {
        if (tierId == null) return "Tất cả";
        switch (tierId) {
            case 1: return "🥉 Member";
            case 2: return "🥈 Silver";
            case 3: return "🥇 Gold";
            case 4: return "💎 Platinum";
            default: return "Hạng " + tierId;
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Phần thưởng – AutoWash Pro</title>

    <%-- DA SUA: them Google Fonts "Inter" de khac phuc loi phong chu. --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', Arial, sans-serif; background: #f4f6f9; }

        .container { max-width: 1400px; margin: 30px auto; padding: 0 18px 60px; }

        .toast-ok  { background: #ECFDF5; border: 1px solid #6EE7B7; color: #065F46;
                     padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; }
        .toast-err { background: #FEF2F2; border: 1px solid #FECACA; color: #DC2626;
                     padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; }

        .page-header { background: white; border-radius: 10px; padding: 24px 28px;
                       box-shadow: 0 2px 8px rgba(0,0,0,.06); margin-bottom: 28px; }
        .page-header h1 { font-size: 22px; font-weight: 800; color: #1A2B3C; }
        .page-header .sub { color: #718096; font-size: 14px; margin-top: 4px; }

        .section { background: white; border-radius: 10px;
                   box-shadow: 0 2px 8px rgba(0,0,0,.06); margin-bottom: 32px; overflow: hidden; }

        .section-header {
            display: flex; align-items: center; justify-content: space-between;
            padding: 18px 24px; border-bottom: 2px solid #EEF4FB;
        }
        .section-header h2 { font-size: 17px; font-weight: 800; color: #1A2B3C; }
        .section-header .count { font-size: 13px; color: #718096; font-weight: 600;
                                 margin-left: 8px; }

        .btn-add {
            padding: 9px 20px; background: #2979C8; color: white;
            border-radius: 50px; font-size: 13px; font-weight: 700;
            text-decoration: none; transition: background .2s; white-space: nowrap;
        }
        .btn-add:hover { background: #1B5FA3; }

        /* Bang du lieu - cho phep cuon ngang tren man hinh nho thay vi vo layout */
        .table-scroll { overflow-x: auto; margin: 0 -18px; padding: 0 18px; }
        table { width: 100%; border-collapse: collapse; table-layout: auto; }
        thead th {
            background: #2979C8; color: white;
            padding: 12px 16px; text-align: left; font-size: 13px; font-weight: 700;
            white-space: normal;
        }
        tbody td { padding: 12px 16px; border-bottom: 1px solid #EEF4FB;
                   font-size: 14px; color: #1A2B3C; white-space: normal;
                   overflow-wrap: break-word; word-wrap: break-word; }
        .col-description { max-width: 320px; min-width: 200px; }
        tbody tr:last-child td { border-bottom: none; }
        tbody tr:hover { background: #F7FBFF; }

        /* DA SUA: Badge trang thai - them white-space:nowrap */
        .badge-active   { background: #D1FAE5; color: #065F46; padding: 4px 12px;
                          border-radius: 50px; font-size: 12px; font-weight: 700;
                          white-space: nowrap; display: inline-block; }
        .badge-inactive { background: #FEE2E2; color: #991B1B; padding: 4px 12px;
                          border-radius: 50px; font-size: 12px; font-weight: 700;
                          white-space: nowrap; display: inline-block; }
        td.col-status { white-space: nowrap; }

        .empty-row td { text-align: center; padding: 40px; color: #718096; font-size: 14px; }

        /* MOI THEM: cot Thao tac (Sua / Xoa) */
        td.col-actions { white-space: nowrap; }
        .btn-action {
            display: inline-block; padding: 6px 14px; border-radius: 50px;
            font-size: 12px; font-weight: 700; text-decoration: none;
            margin-right: 6px; border: none; cursor: pointer; font-family: inherit;
        }
        .btn-edit   { background: #FEF3C7; color: #92400E; }
        .btn-edit:hover   { background: #FDE68A; }
        .btn-delete { background: #FEE2E2; color: #991B1B; }
        .btn-delete:hover { background: #FECACA; }

        /* Modal confirm tạm dừng */
        .modal-backdrop {
            position: fixed; inset: 0; display: none; align-items: center; justify-content: center;
            background: rgba(15, 23, 42, 0.35); z-index: 1000;
        }
        .modal-card {
            width: min(520px, calc(100% - 32px)); background: white; border-radius: 18px;
            padding: 24px; box-shadow: 0 24px 60px rgba(15, 23, 42, 0.18); line-height: 1.6;
        }
        .modal-card h3 { margin-bottom: 12px; font-size: 18px; color: #111827; }
        .modal-card p { margin-bottom: 20px; color: #4B5563; font-size: 14px; }
        .modal-actions { display: flex; justify-content: flex-end; gap: 12px; }
        .btn-modal-cancel, .btn-modal-confirm {
            border: none; border-radius: 999px; padding: 10px 18px; font-weight: 700;
            cursor: pointer; font-family: inherit;
        }
        .btn-modal-cancel { background: #F3F4F6; color: #111827; }
        .btn-modal-confirm { background: #DC2626; color: white; }
    </style>
</head>
<body>

<jsp:include page="navbar.jsp"/>

<div class="container">

    <% if (successMsg != null) { %><div class="toast-ok">✅ <%= successMsg %></div><% } %>
    <% if (errorMsg   != null) { %><div class="toast-err">⚠️ <%= errorMsg %></div><% } %>

    <div class="page-header">
        <h1>🎁 Quản lý Phần thưởng & Khuyến mãi</h1>
        <p class="sub">Xin chào, <strong>${sessionScope.USER.fullName}</strong>
            &nbsp;·&nbsp; Quản lý tất cả phần thưởng và chương trình khuyến mãi</p>
    </div>

    <%-- BANG 1: REWARD (points_cost > 0) --%>
    <div class="section">
        <div class="section-header">
            <div>
                <h2>⭐ Phần thưởng đổi điểm</h2>
                <span class="count">${requestScope.rewards.size()} phần thưởng</span>
            </div>
            <a href="addReward" class="btn-add">+ Thêm Reward</a>
        </div>

        <div class="table-scroll">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Tên phần thưởng</th>
                    <th class="col-description">Mô tả</th>
                    <th>Loại</th>
                    <th>Điểm đổi</th>
                    <th>Giá trị</th>
                    <th>Hạng tối thiểu</th>
                    <th>Ngày bắt đầu</th>
                    <th>Ngày kết thúc</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty rewardList}">
                        <tr class="empty-row"><td colspan="11">Chưa có phần thưởng nào. Nhấn "+ Thêm Reward" để tạo mới.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="r" items="${rewardList}" varStatus="status">
                        <tr>
                            <td>${status.count}</td>
                            <td><strong>${r.name}</strong></td>
                            <td class="col-description">${not empty r.description ? r.description : "-"}</td>
                            <td><%= getTypeName(((Reward) pageContext.getAttribute("r")).getType()) %></td>
                            <td><strong style="color:#2979C8;">${r.pointsCost} điểm</strong></td>
                            <td><%= getValueDisplay(((Reward) pageContext.getAttribute("r")).getType(),
                                                     ((Reward) pageContext.getAttribute("r")).getValue()) %></td>
                            <td><%= getTierName(((Reward) pageContext.getAttribute("r")).getMinTierId()) %></td>
                            <td>${not empty r.startDate ? r.startDate : "-"}</td>
                            <td>${not empty r.endDate ? r.endDate : "-"}</td>
                            <td class="col-status">
                                <c:choose>
                                    <c:when test="${r.active}">
                                        <span class="badge-active">Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-inactive">Tạm dừng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="col-actions">
                                <a href="editReward?id=${r.id}" class="btn-action btn-edit">✏️ Sửa</a>
                                <a href="#" class="btn-action btn-delete"
                                   onclick="confirmPause('phần thưởng', '${r.name}', 'deleteReward?id=${r.id}'); return false;">⏸️ Tạm dừng</a>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        </div>
    </div>

    <%-- BANG 2: PROMOTION (points_cost = 0) --%>
    <div class="section">
        <div class="section-header">
            <div>
                <h2>🏷️ Khuyến mãi</h2>
                <span class="count">${requestScope.promotions.size()} khuyến mãi</span>
            </div>
            <a href="addPromotion" class="btn-add">+ Thêm Khuyến mãi</a>
        </div>

        <div class="table-scroll">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Tên khuyến mãi</th>
                    <th class="col-description">Mô tả</th>
                    <th>Loại</th>
                    <th>Giá trị ưu đãi</th>
                    <th>Hạng áp dụng</th>
                    <th>Ngày bắt đầu</th>
                    <th>Ngày kết thúc</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty promoList}">
                        <tr class="empty-row"><td colspan="10">Chưa có khuyến mãi nào. Nhấn "+ Thêm Khuyến mãi" để tạo mới.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${promoList}" varStatus="status">
                        <tr>
                            <td>${status.count}</td>
                            <td><strong>${p.name}</strong></td>
                            <td class="col-description">${not empty p.description ? p.description : "-"}</td>
                            <td><%= getTypeName(((Reward) pageContext.getAttribute("p")).getType()) %></td>
                            <td><strong style="color:#059669;"><%= getValueDisplay(((Reward) pageContext.getAttribute("p")).getType(),
                                                     ((Reward) pageContext.getAttribute("p")).getValue()) %></strong></td>
                            <td><%= getTierName(((Reward) pageContext.getAttribute("p")).getMinTierId()) %></td>
                            <td>${not empty p.startDate ? p.startDate : "-"}</td>
                            <td>${not empty p.endDate ? p.endDate : "-"}</td>
                            <td class="col-status">
                                <c:choose>
                                    <c:when test="${p.active}">
                                        <span class="badge-active">Đang hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-inactive">Tạm dừng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="col-actions">
                                <a href="editReward?id=${p.id}" class="btn-action btn-edit">✏️ Sửa</a>
                                <a href="#" class="btn-action btn-delete"
                                   onclick="confirmPause('khuyến mãi', '${p.name}', 'deleteReward?id=${p.id}'); return false;">⏸️ Tạm dừng</a>
                            </td>
                        </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
        </div>
    </div>

    <a href="adminDashboard" style="color:#2979C8; font-weight:600; font-size:14px; text-decoration:none;">
        ← Về trang Admin Dashboard
    </a>

</div>

<div class="modal-backdrop" id="pause-modal">
    <div class="modal-card">
        <h3 id="pause-modal-title">Xác nhận tạm dừng</h3>
        <p id="pause-modal-text">Xác nhận tạm dừng mục này? Sau khi tạm dừng, mục này sẽ ngừng hiển thị nhưng dữ liệu liên quan vẫn được giữ lại.</p>
        <div class="modal-actions">
            <button type="button" class="btn-modal-cancel" onclick="closePauseModal()">Hủy</button>
            <button type="button" class="btn-modal-confirm" onclick="doPause()">Tạm dừng</button>
        </div>
        <input type="hidden" id="pause-confirm-url" value="">
    </div>
</div>

<script>
    function confirmPause(kind, name, url) {
        document.getElementById('pause-modal-title').textContent = 'Xác nhận tạm dừng ' + kind;
        document.getElementById('pause-modal-text').textContent =
            'Xác nhận tạm dừng ' + kind + ' "' + name + '"? Sau khi tạm dừng, mục này sẽ ngừng hiển thị nhưng dữ liệu liên quan vẫn được giữ lại.';
        document.getElementById('pause-confirm-url').value = url;
        document.getElementById('pause-modal').style.display = 'flex';
    }
    function closePauseModal() {
        document.getElementById('pause-modal').style.display = 'none';
    }
    function doPause() {
        var url = document.getElementById('pause-confirm-url').value;
        if (url) {
            window.location.href = url;
        }
    }
</script>
</body>
</html>
