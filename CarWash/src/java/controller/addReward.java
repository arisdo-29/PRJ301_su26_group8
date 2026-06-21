package controller;

import dao.RewardDAO;
import dto.Reward;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * addReward – Servlet xử lý thêm Reward mới (points_cost > 0).
 * URL: /addReward
 *
 * GET  → hiển thị form addReward.jsp
 * POST → đọc dữ liệu form → gọi RewardDAO.addReward() → chuyển về manageReward
 *
 * ĐÃ SỬA: thêm validation ràng buộc type ↔ value. Nếu type là DISC_PERCENT
 * hoặc DISC_VND (loại giảm giá) thì value bắt buộc phải > 0, tránh trường
 * hợp tạo reward giảm giá nhưng giá trị ưu đãi = 0 (vô nghĩa về nghiệp vụ).
 */
@WebServlet(name = "addReward", urlPatterns = {"/addReward"})
public class addReward extends HttpServlet {

    // ── GET: hiển thị form thêm reward ──────────────────────────────
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập và quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        User user = (User) session.getAttribute("USER");
        if ("CUSTOMER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Chuyển sang trang form
        request.getRequestDispatcher("addReward.jsp").forward(request, response);
    }

    // ── POST: xử lý dữ liệu form, lưu vào database ──────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect("index.jsp");
            return;
        }
        User user = (User) session.getAttribute("USER");
        if ("CUSTOMER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        // ── Đọc dữ liệu từ form ─────────────────────────────────────
        String name        = request.getParameter("name");
        String description = request.getParameter("description");
        String type        = request.getParameter("type");
        String pointsStr   = request.getParameter("pointsCost");
        String valueStr    = request.getParameter("value");
        String tierStr     = request.getParameter("minTierId");
        String startStr    = request.getParameter("startDate");
        String endStr      = request.getParameter("endDate");
        // Checkbox: nếu được tick → "on", không tick → null
        boolean isActive = "on".equals(request.getParameter("isActive"));

        // ── Validate bắt buộc ────────────────────────────────────────
        if (name == null || name.trim().isEmpty() || type == null || pointsStr == null) {
            request.setAttribute("ERROR", "Vui lòng điền đầy đủ các trường bắt buộc.");
            request.getRequestDispatcher("addReward.jsp").forward(request, response);
            return;
        }

        int pointsCost;
        try {
            pointsCost = Integer.parseInt(pointsStr.trim());
            if (pointsCost <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            request.setAttribute("ERROR", "Số điểm đổi phải là số nguyên dương (> 0).");
            request.getRequestDispatcher("addReward.jsp").forward(request, response);
            return;
        }

        // Giá trị (ví dụ: 10 cho giảm 10%, 50000 cho giảm 50.000đ)
        double value = 0;
        if (valueStr != null && !valueStr.trim().isEmpty()) {
            try {
                value = Double.parseDouble(valueStr.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR", "Giá trị ưu đãi không hợp lệ, vui lòng nhập số.");
                request.getRequestDispatcher("addReward.jsp").forward(request, response);
                return;
            }
        }

        // ─── VALIDATION RÀNG BUỘC type ↔ value (MỚI THÊM) ───────────
        // Yêu cầu: nếu type là loại giảm giá (DISC_PERCENT / DISC_VND)
        // thì value bắt buộc phải > 0. Ví dụ: chọn "Giảm theo VND" nhưng
        // để giá trị ưu đãi = 0 (hoặc bỏ trống) thì không hợp lý nghiệp vụ.
        if (("DISC_PERCENT".equals(type) || "DISC_VND".equals(type)) && value <= 0) {
            request.setAttribute("ERROR",
                "Loại \"" + ("DISC_PERCENT".equals(type) ? "Giảm phần trăm" : "Giảm theo VND")
                + "\" bắt buộc giá trị ưu đãi phải lớn hơn 0.");
            request.getRequestDispatcher("addReward.jsp").forward(request, response);
            return;
        }
        // FREE_WASH / FREE_UPGRADE không cần value → ép về 0 cho sạch dữ liệu
        if ("FREE_WASH".equals(type) || "FREE_UPGRADE".equals(type)) {
            value = 0;
        }

        // ── Tạo đối tượng Reward ────────────────────────────────────
        Reward r = new Reward();
        r.setName(name.trim());
        r.setDescription((description != null && !description.trim().isEmpty())
                          ? description.trim() : null);
        r.setType(type);
        r.setPointsCost(pointsCost);   // > 0 vì đây là Reward
        r.setValue(value);

        // Hạng tối thiểu (null = tất cả hạng)
        if (tierStr != null && !tierStr.trim().isEmpty()) {
            try {
                r.setMinTierId(Integer.parseInt(tierStr.trim()));
            } catch (NumberFormatException e) {
                r.setMinTierId(null);
            }
        }

        // Ngày bắt đầu / kết thúc – input type="date" trả về "yyyy-MM-dd"
        // java.sql.Date.valueOf() chuyển chuỗi "yyyy-MM-dd" thành java.sql.Date
        if (startStr != null && !startStr.trim().isEmpty()) {
            r.setStartDate(java.sql.Date.valueOf(startStr.trim()));
        }
        if (endStr != null && !endStr.trim().isEmpty()) {
            r.setEndDate(java.sql.Date.valueOf(endStr.trim()));
        }

        r.setActive(isActive);

        // ── Gọi DAO để lưu vào database ─────────────────────────────
        RewardDAO dao = new RewardDAO();
        int result = dao.addReward(r);

        if (result > 0) {
            // Thành công → chuyển về trang quản lý với thông báo
            request.getSession().setAttribute("SUCCESS_MSG", "Thêm phần thưởng \"" + name + "\" thành công!");
            response.sendRedirect("manageReward");
        } else {
            // Thất bại → báo lỗi, giữ lại form
            request.setAttribute("ERROR", "Thêm phần thưởng thất bại! Vui lòng thử lại.");
            request.getRequestDispatcher("addReward.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet thêm phần thưởng mới";
    }
}
