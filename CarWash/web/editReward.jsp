<%@ page import="dto.User" %>
<%@ page import="dto.Reward" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>


<%--
    editReward.jsp - Form SUA Reward hoac Promotion (MOI THEM)


    Dung CHUNG cho ca Reward (pointsCost > 0) va Promotion (pointsCost = 0),
    vi ca 2 deu la 1 dong trong bang rewards, chi khac points_cost.
    Trang nay tu nhan dien dang la Reward hay Promotion dua vao
    reward.isPromotion() (tuc reward.pointsCost == 0) de:
      - Hien/an truong "So diem can doi"
      - Doi mau nut Luu (xanh duong cho Reward, xanh la cho Promotion)


    -- JSP Standard Action --
    <jsp:include page="navbar.jsp"/> : nhung thanh dieu huong


    -- Expression Language (EL) --
    ${sessionScope.USER.fullName}      : ten admin hien thi tren trang
    ${requestScope.ERROR}              : thong bao loi tu servlet
    ${requestScope.reward.xxx}         : du lieu cu de fill san vao form


    -- Validation MOI THEM (theo yeu cau) --
    Servlet editReward.java se kiem tra: neu type la DISC_PERCENT hoac
    DISC_VND (loai giam gia) thi gia tri uu dai (value) bat buoc phai > 0.
    Vi du: chon "Giam theo VND" nhung de gia tri uu dai = 0 se bi tu choi.
--%>


<%-- Chan truy cap neu chua dang nhap hoac khong phai admin --%>
<%
    User user = (User) session.getAttribute("USER");
    if (user == null || "CUSTOMER".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }


    Reward reward = (Reward) request.getAttribute("reward");
    if (reward == null) {
        response.sendRedirect("manageReward");
        return;
    }


    boolean isPromotion = reward.isPromotion(); // true neu pointsCost == 0


    // Dinh dang lai ngay thang ve "yyyy-MM-dd" de do vao input type="date"
    String startDateStr = (reward.getStartDate() != null) ? reward.getStartDate().toString() : "";
    String endDateStr   = (reward.getEndDate()   != null) ? reward.getEndDate().toString()   : "";
%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa <%= isPromotion ? "Khuyến mãi" : "Phần thưởng" %> – AutoWash Pro</title>


    <%-- DA SUA: them Google Fonts "Inter" giong addReward.jsp / addPromotion.jsp
         de dong bo va tranh loi phong chu. --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">


    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', Arial, sans-serif; background: #F0F8FF; }


        .container { max-width: 600px; margin: 40px auto; padding: 0 16px 60px; }


        .back { display: inline-block; margin-bottom: 20px; color: #2979C8;
                font-size: 14px; text-decoration: none; font-weight: 600; }
        .back:hover { text-decoration: underline; }


        .page-title { font-size: 22px; font-weight: 800; color: #1A2B3C; margin-bottom: 6px; }
        .page-sub   { color: #718096; font-size: 14px; margin-bottom: 28px; }


        .card { background: white; border-radius: 12px; padding: 32px;
                box-shadow: 0 2px 10px rgba(0,0,0,.08); }


        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 700; font-size: 13px;
                color: #1A2B3C; margin-bottom: 7px; }
        .required { color: #E53E3E; }


        input[type=text], input[type=number], input[type=date],
        select, textarea {
            width: 100%; padding: 11px 14px; border: 1.5px solid #C9DFF0;
            border-radius: 8px; font-size: 14px; font-family: inherit;
            transition: border-color .2s;
        }
        input:focus, select:focus, textarea:focus {
            outline: none; border-color: #2979C8;
            box-shadow: 0 0 0 3px rgba(41,121,200,.12);
        }
        textarea { height: 80px; resize: vertical; }


        .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }


        .hint { font-size: 12px; color: #718096; margin-top: 5px; }


        .check-group { display: flex; align-items: center; gap: 10px; }
        .check-group input[type=checkbox] { width: 18px; height: 18px; cursor: pointer; }
        .check-group label { margin: 0; font-weight: 600; }


        .btn-submit {
            width: 100%; padding: 14px; color: white;
            border: none; border-radius: 50px; font-size: 16px; font-weight: 700;
            cursor: pointer; margin-top: 10px; transition: background .2s;
        }
        /* Mau nut khac nhau cho Reward (xanh duong) va Promotion (xanh la) */
        .btn-submit.reward   { background: #2979C8; }
        .btn-submit.reward:hover   { background: #1B5FA3; }
        .btn-submit.promotion { background: #059669; }
        .btn-submit.promotion:hover { background: #047857; }


        .toast-err { background: #FEF2F2; border: 1px solid #FECACA; color: #DC2626;
                     padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; }


        .divider { border: none; border-top: 1px solid #EEF4FB; margin: 20px 0; }


        .badge-type {
            display: inline-block; padding: 4px 12px; border-radius: 50px;
            font-size: 12px; font-weight: 700; margin-bottom: 20px;
        }
        .badge-type.reward    { background: #EBF3FB; color: #2979C8; }
        .badge-type.promotion { background: #ECFDF5; color: #059669; }
    </style>
</head>
<body>


<jsp:include page="navbar.jsp"/>


<div class="container">


    <a href="manageReward" class="back">← Quay lại Quản lý Phần thưởng</a>


    <% if (isPromotion) { %>
        <span class="badge-type promotion">🏷️ Khuyến mãi</span>
        <div class="page-title">Sửa Khuyến mãi</div>
    <% } else { %>
        <span class="badge-type reward">⭐ Phần thưởng</span>
        <div class="page-title">Sửa Phần thưởng</div>
    <% } %>


    <div class="page-sub">Đang sửa bởi: <strong>${sessionScope.USER.fullName}</strong> &nbsp;·&nbsp; ID: #<%= reward.getId() %></div>


    <% String errorMsg = (String) request.getAttribute("ERROR");
       if (errorMsg != null) { %>
        <div class="toast-err">⚠️ <%= errorMsg %></div>
    <% } %>


    <div class="card">
        <%-- Form POST -> editReward (servlet editReward.java doPost) --%>
        <form action="editReward" method="post">


            <%-- Truong an: id cua reward/promotion dang sua --%>
            <input type="hidden" name="id" value="<%= reward.getId() %>">


            <div class="form-group">
                <label>Tên <%= isPromotion ? "khuyến mãi" : "phần thưởng" %> <span class="required">*</span></label>
                <input type="text" name="name" value="<%= reward.getName() %>" required>
            </div>


            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description" placeholder="Mô tả ngắn (không bắt buộc)"><%= reward.getDescription() != null ? reward.getDescription() : "" %></textarea>
            </div>


            <hr class="divider">


            <div class="form-group">
                <label>Loại <span class="required">*</span></label>
                <select name="type" required>
                    <option value="FREE_WASH"    <%= "FREE_WASH".equals(reward.getType())    ? "selected" : "" %>>🚿 Rửa miễn phí (FREE_WASH)</option>
                    <option value="DISC_PERCENT" <%= "DISC_PERCENT".equals(reward.getType()) ? "selected" : "" %>>% Giảm phần trăm (DISC_PERCENT)</option>
                    <option value="DISC_VND"     <%= "DISC_VND".equals(reward.getType())     ? "selected" : "" %>>đ Giảm theo số tiền (DISC_VND)</option>
                    <% if (!isPromotion) { %>
                    <option value="FREE_UPGRADE" <%= "FREE_UPGRADE".equals(reward.getType()) ? "selected" : "" %>>⬆ Nâng cấp dịch vụ (FREE_UPGRADE)</option>
                    <% } %>
                </select>
                <p class="hint">FREE_WASH / FREE_UPGRADE: để trống ô "Giá trị" bên dưới.</p>
            </div>


            <% if (!isPromotion) { %>
            <%-- Chi hien thi truong nay cho Reward. Voi Promotion, KHONG render
                 input nay -> servlet se nhan pointsStr = null -> giu pointsCost = 0 --%>
            <div class="form-group">
                <label>Số điểm cần đổi <span class="required">*</span></label>
                <input type="number" name="pointsCost" value="<%= reward.getPointsCost() %>" min="1" required>
                <p class="hint">Phải lớn hơn 0. Khách cần tích đủ số điểm này để đổi thưởng.</p>
            </div>
            <% } %>


            <%-- ĐÃ SỬA (validation MỚI): giá trị ưu đãi bắt buộc > 0 khi type
                 là DISC_PERCENT/DISC_VND. Servlet sẽ kiểm tra lại lần nữa ở
                 phía server (không chỉ dựa vào required ở client). --%>
            <div class="form-group">
                <label>Giá trị ưu đãi</label>
                <input type="number" name="value" value="<%= reward.getValue() > 0 ? String.valueOf(reward.getValue()) : "" %>" min="0" step="any">
                <p class="hint">Nhập 10 nếu giảm 10% · Nhập 50000 nếu giảm 50.000đ · Bắt buộc &gt; 0 với loại giảm giá · Để trống nếu là FREE_WASH / FREE_UPGRADE.</p>
            </div>


            <hr class="divider">


            <div class="form-group">
                <label>Hạng thành viên <%= isPromotion ? "áp dụng" : "tối thiểu" %></label>
                <select name="minTierId">
                    <option value=""                                                      <%= reward.getMinTierId() == null ? "selected" : "" %>>Tất cả hạng</option>
                    <option value="1" <%= reward.getMinTierId() != null && reward.getMinTierId() == 1 ? "selected" : "" %>>🥉 Member</option>
                    <option value="2" <%= reward.getMinTierId() != null && reward.getMinTierId() == 2 ? "selected" : "" %>>🥈 Silver</option>
                    <option value="3" <%= reward.getMinTierId() != null && reward.getMinTierId() == 3 ? "selected" : "" %>>🥇 Gold</option>
                    <option value="4" <%= reward.getMinTierId() != null && reward.getMinTierId() == 4 ? "selected" : "" %>>💎 Platinum</option>
                </select>
                <p class="hint">Chọn "Tất cả hạng" để áp dụng cho mọi khách hàng.</p>
            </div>


            <div class="row-2">
                <div class="form-group">
                    <label>Ngày bắt đầu</label>
                    <input type="date" name="startDate" value="<%= startDateStr %>">
                </div>
                <div class="form-group">
                    <label>Ngày kết thúc</label>
                    <input type="date" name="endDate" value="<%= endDateStr %>">
                </div>
            </div>


            <div class="form-group">
                <div class="check-group">
                    <input type="checkbox" name="isActive" id="isActive" <%= reward.isActive() ? "checked" : "" %>>
                    <label for="isActive">Đang kích hoạt</label>
                </div>
            </div>


            <button type="submit" class="btn-submit <%= isPromotion ? "promotion" : "reward" %>">
                💾 Lưu thay đổi
            </button>


        </form>
    </div>
</div>
</body>
</html>
