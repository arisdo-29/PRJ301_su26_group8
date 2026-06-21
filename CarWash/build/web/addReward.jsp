<%@ page import="dto.User" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<%--
    addReward.jsp – Form thêm Reward mới (phần thưởng đổi điểm)

    ── JSP Standard Action ──
    <jsp:include page="navbar.jsp"/> : nhúng thanh điều hướng

    ── Expression Language (EL) ──
    ${sessionScope.USER.fullName} : tên admin hiển thị trên trang
    ${requestScope.ERROR}         : thông báo lỗi từ servlet
--%>

<%-- Chặn truy cập nếu chưa đăng nhập hoặc không phải admin --%>
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
    <title>Thêm Reward – AutoWash Pro</title>

    <%-- ĐÃ SỬA: thêm Google Fonts "Inter" để khắc phục lỗi phông chữ
         (trang trước đây khai báo font-family: Inter trong CSS nhưng
         không import font này nên trình duyệt hiển thị bằng font mặc định). --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Inter', Arial, sans-serif; background: #F0F8FF; }

        .container { max-width: 600px; margin: 40px auto; padding: 0 16px 60px; }

        /* Nút quay lại */
        .back { display: inline-block; margin-bottom: 20px; color: #2979C8;
                font-size: 14px; text-decoration: none; font-weight: 600; }
        .back:hover { text-decoration: underline; }

        /* Tiêu đề */
        .page-title { font-size: 22px; font-weight: 800; color: #1A2B3C; margin-bottom: 6px; }
        .page-sub   { color: #718096; font-size: 14px; margin-bottom: 28px; }

        /* Thẻ form */
        .card { background: white; border-radius: 12px; padding: 32px;
                box-shadow: 0 2px 10px rgba(0,0,0,.08); }

        /* Nhóm field */
        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: 700; font-size: 13px;
                color: #1A2B3C; margin-bottom: 7px; }
        .required { color: #E53E3E; }  /* dấu * */

        /* Input / select / textarea */
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

        /* Hai cột cạnh nhau (ngày bắt đầu / kết thúc) */
        .row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }

        /* Ghi chú nhỏ dưới field */
        .hint { font-size: 12px; color: #718096; margin-top: 5px; }

        /* Checkbox */
        .check-group { display: flex; align-items: center; gap: 10px; }
        .check-group input[type=checkbox] { width: 18px; height: 18px; cursor: pointer; }
        .check-group label { margin: 0; font-weight: 600; }

        /* Nút Submit */
        .btn-submit {
            width: 100%; padding: 14px; background: #2979C8; color: white;
            border: none; border-radius: 50px; font-size: 16px; font-weight: 700;
            cursor: pointer; margin-top: 10px; transition: background .2s;
        }
        .btn-submit:hover { background: #1B5FA3; }

        /* Toast lỗi */
        .toast-err { background: #FEF2F2; border: 1px solid #FECACA; color: #DC2626;
                     padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-weight: 600; }

        /* Divider */
        .divider { border: none; border-top: 1px solid #EEF4FB; margin: 20px 0; }
    </style>
</head>
<body>

<%-- JSP Standard Action: nhúng navbar --%>
<jsp:include page="navbar.jsp"/>

<div class="container">

    <a href="manageReward" class="back">← Quay lại Quản lý Phần thưởng</a>

    <%--
        EL Expression: hiển thị tên admin
        ${sessionScope.USER.fullName} → Java: ((User)session.getAttribute("USER")).getFullName()
    --%>
    <div class="page-title">⭐ Thêm Phần thưởng mới</div>
    <div class="page-sub">Đang thêm bởi: <strong>${sessionScope.USER.fullName}</strong></div>

    <%--
        EL: hiển thị lỗi từ servlet
        ${requestScope.ERROR} → Java: request.getAttribute("ERROR")
    --%>
    <% String errorMsg = (String) request.getAttribute("ERROR");
       if (errorMsg != null) { %>
        <div class="toast-err">⚠️ <%= errorMsg %></div>
    <% } %>

    <div class="card">
        <%--
            Form POST → addReward (tên servlet trong @WebServlet)
            Dữ liệu sẽ được xử lý bởi addReward.java doPost()
        --%>
        <form action="addReward" method="post">

            <%-- Tên phần thưởng --%>
            <div class="form-group">
                <label>Tên phần thưởng <span class="required">*</span></label>
                <input type="text" name="name" placeholder="Ví dụ: Miễn phí 1 lần rửa" required>
            </div>

            <%-- Mô tả --%>
            <div class="form-group">
                <label>Mô tả</label>
                <textarea name="description" placeholder="Mô tả ngắn về phần thưởng này (không bắt buộc)"></textarea>
            </div>

            <hr class="divider">

            <%-- Loại phần thưởng --%>
            <div class="form-group">
                <label>Loại phần thưởng <span class="required">*</span></label>
                <select name="type" required>
                    <option value="">-- Chọn loại --</option>
                    <option value="FREE_WASH">🚿 Rửa miễn phí (FREE_WASH)</option>
                    <option value="DISC_PERCENT">% Giảm phần trăm (DISC_PERCENT)</option>
                    <option value="DISC_VND">đ Giảm theo số tiền (DISC_VND)</option>
                    <option value="FREE_UPGRADE">⬆ Nâng cấp dịch vụ (FREE_UPGRADE)</option>
                </select>
                <p class="hint">FREE_WASH / FREE_UPGRADE: để trống ô "Giá trị" bên dưới.</p>
            </div>

            <%-- Số điểm cần đổi – bắt buộc > 0 cho Reward --%>
            <div class="form-group">
                <label>Số điểm cần đổi <span class="required">*</span></label>
                <input type="number" name="pointsCost" placeholder="Ví dụ: 500" min="1" required>
                <p class="hint">Phải lớn hơn 0. Khách cần tích đủ số điểm này để đổi thưởng.</p>
            </div>

            <%-- Giá trị giảm (cho DISC_PERCENT và DISC_VND) --%>
            <%-- ĐÃ SỬA: cập nhật hint rõ ràng hơn, khớp với validation mới
                 ở server (addReward.java): bắt buộc > 0 với loại giảm giá. --%>
            <div class="form-group">
                <label>Giá trị ưu đãi</label>
                <input type="number" name="value" placeholder="Ví dụ: 10 (cho giảm 10%) hoặc 50000" min="0" step="any">
                <p class="hint">Nhập 10 nếu giảm 10% · Nhập 50000 nếu giảm 50.000đ · <strong>Bắt buộc lớn hơn 0</strong> nếu loại là Giảm phần trăm / Giảm theo VND · Để trống nếu là FREE_WASH / FREE_UPGRADE.</p>
            </div>

            <hr class="divider">

            <%-- Hạng tối thiểu --%>
            <div class="form-group">
                <label>Hạng thành viên tối thiểu</label>
                <select name="minTierId">
                    <option value="">Tất cả hạng</option>
                    <option value="1">🥉 Member</option>
                    <option value="2">🥈 Silver</option>
                    <option value="3">🥇 Gold</option>
                    <option value="4">💎 Platinum</option>
                </select>
                <p class="hint">Chọn "Tất cả hạng" để áp dụng cho mọi khách hàng.</p>
            </div>

            <%--
                Ngày bắt đầu và kết thúc – dùng input type="date"
                Trình duyệt sẽ hiển thị lịch để chọn (không cần tự nhập)
            --%>
            <div class="row-2">
                <div class="form-group">
                    <label>Ngày bắt đầu</label>
                    <input type="date" name="startDate">
                    <p class="hint">Để trống = không giới hạn ngày bắt đầu.</p>
                </div>
                <div class="form-group">
                    <label>Ngày kết thúc</label>
                    <input type="date" name="endDate">
                    <p class="hint">Để trống = không giới hạn ngày kết thúc.</p>
                </div>
            </div>

            <%-- Trạng thái hoạt động --%>
            <div class="form-group">
                <div class="check-group">
                    <%-- Mặc định checked = đang hoạt động ngay khi tạo --%>
                    <input type="checkbox" name="isActive" id="isActive" checked>
                    <label for="isActive">Kích hoạt ngay</label>
                </div>
            </div>

            <button type="submit" class="btn-submit">💾 Lưu phần thưởng</button>

        </form>
    </div>
</div>
</body>
</html>
