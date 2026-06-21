<%@ page import="dto.User" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%--
    addPromotion.jsp – Form thêm Khuyến mãi mới (points_cost = 0)

    Khác với addReward.jsp:
      - Không có trường "Số điểm đổi" (vì khuyến mãi luôn có points_cost = 0)
      - "Giá trị ưu đãi" là bắt buộc (phải biết giảm bao nhiêu %)
      - Loại bao gồm cả FREE_WASH (rửa miễn phí trong chương trình khuyến mãi)

    ── JSP Standard Action ──
    <jsp:include page="navbar.jsp"/>

    ── Expression Language (EL) ──
    ${sessionScope.USER.fullName} : tên admin
    ${requestScope.ERROR}         : thông báo lỗi
--%>

<%-- Chặn truy cập nếu không phải admin --%>
<%
    User user = (User) session.getAttribute("USER");
    if (user == null || "CUSTOMER".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Khuyến mãi – AutoWash Pro</title>

    <%-- ĐÃ SỬA: thêm Google Fonts "Inter" để khắc phục lỗi phông chữ. --%>
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

        /* Banner giải thích khuyến mãi */
        .promo-info {
            background: #EBF3FB; border-left: 4px solid #2979C8;
            border-radius: 8px; padding: 14px 18px; margin-bottom: 24px; font-size: 14px; color: #1A2B3C;
        }
        .promo-info strong { color: #2979C8; }

        .card { background: white; border-radius: 12px; padding: 32px;
                box-shadow: 0 2px 10px rgba(0,0,0,.08); }

        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 700; font-size: 13px; color: #1A2B3C; margin-bottom: 7px; }
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
            width: 100%; padding: 14px; background: #059669; color: white;
            border: none; border-radius: 50px; font-size: 16px; font-weight: 700;
            cursor: pointer; margin-top: 10px; transition: background .2s;
        }
        .btn-submit:hover { background: #047857; }

        .toast-err { background: #FEF2F2; border: 1px solid #FECACA; color: #DC2626;
                     padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; }

        .divider { border: none; border-top: 1px solid #EEF4FB; margin: 20px 0; }
    </style>
</head>
<body>

<%-- JSP Standard Action: nhúng navbar --%>
<jsp:include page="navbar.jsp"/>

<div class="container">

    <a href="manageReward" class="back">← Quay lại Quản lý Phần thưởng</a>

    <div class="page-title">🏷️ Thêm Khuyến mãi mới</div>

    <%--
        EL: đọc tên admin từ session
        ${sessionScope.USER.fullName} = session.getAttribute("USER").getFullName()
    --%>
    <div class="page-sub">Đang thêm bởi: <strong>${sessionScope.USER.fullName}</strong></div>

    <%-- Banner giải thích sự khác biệt khuyến mãi vs phần thưởng --%>
    <div class="promo-info">
        💡 <strong>Khuyến mãi</strong> được admin cấu hình và áp dụng <strong>tự động</strong>
        trong khoảng thời gian nhất định – khách hàng <strong>không cần dùng điểm</strong> để đổi.
        <br>Khác với Phần thưởng (Reward), vốn yêu cầu khách tích điểm rồi tự đổi.
    </div>

    <%-- Thông báo lỗi từ servlet --%>
    <%-- EL: ${requestScope.ERROR} = request.getAttribute("ERROR") --%>
    <% String errorMsg = (String) request.getAttribute("ERROR");
       if (errorMsg != null) { %>
        <div class="toast-err">⚠️ <%= errorMsg %></div>
    <% } %>

    <div class="card">
        <%--
            Form POST → /addPromotion (addPromotion.java doPost)
        --%>
        <form action="addPromotion" method="post">

            <%-- Tên khuyến mãi --%>
            <div class="form-group">
                <label>Tên khuyến mãi <span class="required">*</span></label>
                <input type="text" name="name" placeholder="Ví dụ: Summer Sale 2026" required>
            </div>

            <%-- Mô tả --%>
            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description" placeholder="Mô tả ngắn về chương trình khuyến mãi (không bắt buộc)"></textarea>
            </div>

            <hr class="divider">

            <%-- Loại khuyến mãi --%>
            <div class="form-group">
                <label>Loại khuyến mãi <span class="required">*</span></label>
                <select name="type" required>
                    <option value="">-- Chọn loại --</option>
                    <option value="DISC_PERCENT">% Giảm phần trăm (DISC_PERCENT)</option>
                    <option value="DISC_VND">đ Giảm theo số tiền (DISC_VND)</option>
                    <option value="FREE_WASH">🚿 Tặng rửa xe miễn phí (FREE_WASH)</option>
                </select>
            </div>

            <%--
                Giá trị ưu đãi – bắt buộc với DISC_PERCENT và DISC_VND
                ĐÃ SỬA: servlet (addPromotion.java) nay kiểm tra value PHẢI > 0,
                không chỉ "có nhập" như trước. Hint cập nhật cho rõ ràng.
            --%>
            <div class="form-group">
                <label>Giá trị ưu đãi <span class="required">*</span></label>
                <input type="number" name="value" placeholder="Ví dụ: 10 (cho giảm 10%) hoặc 50000" min="0" step="any">
                <p class="hint">Nhập 10 nếu giảm 10% · Nhập 50000 nếu giảm 50.000đ · <strong>Bắt buộc lớn hơn 0</strong> với loại Giảm phần trăm / Giảm theo VND · Để trống nếu là FREE_WASH.</p>
            </div>

            <%-- KHÔNG có trường "Số điểm đổi" – vì khuyến mãi luôn points_cost = 0 --%>
            <%-- Servlet sẽ tự set points_cost = 0 khi lưu vào database --%>

            <hr class="divider">

            <%-- Hạng áp dụng --%>
            <div class="form-group">
                <label>Hạng thành viên áp dụng</label>
                <select name="minTierId">
                    <option value="">Tất cả hạng</option>
                    <option value="1">🥉 Member trở lên</option>
                    <option value="2">🥈 Silver trở lên</option>
                    <option value="3">🥇 Gold trở lên</option>
                    <option value="4">💎 Platinum</option>
                </select>
                <p class="hint">Chọn "Tất cả hạng" để áp dụng cho mọi khách hàng.</p>
            </div>

            <%--
                Ngày bắt đầu và kết thúc
                input type="date" → trình duyệt hiển thị lịch (date picker)
                Giá trị trả về: "yyyy-MM-dd" → java.sql.Date.valueOf() xử lý được
            --%>
            <div class="row-2">
                <div class="form-group">
                    <label>Ngày bắt đầu <span class="required">*</span></label>
                    <input type="date" name="startDate" required>
                </div>
                <div class="form-group">
                    <label>Ngày kết thúc <span class="required">*</span></label>
                    <input type="date" name="endDate" required>
                </div>
            </div>
            <p class="hint" style="margin-top:-12px; margin-bottom:20px;">
                Khuyến mãi nên có ngày bắt đầu và kết thúc rõ ràng.
            </p>

            <%-- Trạng thái --%>
            <div class="form-group">
                <div class="check-group">
                    <input type="checkbox" name="isActive" id="isActive" checked>
                    <label for="isActive">Kích hoạt ngay (is_active = true)</label>
                </div>
            </div>

            <button type="submit" class="btn-submit">💾 Lưu khuyến mãi</button>

        </form>
    </div>
</div>
</body>
</html>
