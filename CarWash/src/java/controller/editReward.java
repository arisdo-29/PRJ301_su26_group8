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
 * editReward – Servlet xử lý SỬA Reward hoặc Promotion (MỚI THÊM).
 * URL: /editReward?id=...
 *
 * Dùng chung cho cả Reward và Promotion vì cả 2 đều là 1 dòng trong bảng
 * rewards, chỉ khác nhau ở points_cost (0 = Promotion, > 0 = Reward).
 * Form sẽ tự lấy điểm cũ lên, nếu là Promotion thì field "Số điểm đổi"
 * sẽ không có (giữ nguyên points_cost = 0 khi submit), tương tự addPromotion.
 *
 * GET  → load dữ liệu cũ theo id → forward sang editReward.jsp
 * POST → đọc dữ liệu form → validate → gọi RewardDAO.updateReward() → về manageReward
 */
@WebServlet(name = "editReward", urlPatterns = {"/editReward"})
public class editReward extends HttpServlet {

    // ── GET: hiển thị form sửa, có sẵn dữ liệu cũ ───────────────────
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

        // Lấy id từ URL: /editReward?id=5
        String idStr = request.getParameter("id");
        int id = -1;
        try { id = Integer.parseInt(idStr); } catch (Exception e) { /* id không hợp lệ */ }

        if (id <= 0) {
            response.sendRedirect("manageReward");
            return;
        }

        RewardDAO dao = new RewardDAO();
        Reward r = dao.getById(id);

        if (r == null) {
            response.sendRedirect("manageReward");
            return;
        }

        request.setAttribute("reward", r);
        request.getRequestDispatcher("editReward.jsp").forward(request, response);
    }

    // ── POST: xử lý dữ liệu form, cập nhật vào database ─────────────
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
        String idStr       = request.getParameter("id");
        String name        = request.getParameter("name");
        String description = request.getParameter("description");
        String type        = request.getParameter("type");
        String pointsStr    = request.getParameter("pointsCost"); // có thể null nếu là Promotion
        String valueStr     = request.getParameter("value");
        String tierStr      = request.getParameter("minTierId");
        String startStr     = request.getParameter("startDate");
        String endStr       = request.getParameter("endDate");
        boolean isActive    = "on".equals(request.getParameter("isActive"));

        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (Exception e) {
            response.sendRedirect("manageReward");
            return;
        }

        // ── Validate bắt buộc ────────────────────────────────────────
        if (name == null || name.trim().isEmpty() || type == null || type.isEmpty()) {
            request.setAttribute("ERROR", "Vui lòng điền tên và chọn loại.");
            forwardBackToEdit(request, response, id);
            return;
        }

        // pointsCost: nếu form có gửi (trường hợp Reward) thì parse,
        // nếu không gửi (trường hợp Promotion) thì giữ = 0
        int pointsCost = 0;
        if (pointsStr != null && !pointsStr.trim().isEmpty()) {
            try {
                pointsCost = Integer.parseInt(pointsStr.trim());
                if (pointsCost < 0) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR", "Số điểm đổi phải là số nguyên không âm.");
                forwardBackToEdit(request, response, id);
                return;
            }
        }

        // Giá trị ưu đãi
        double value = 0;
        if (valueStr != null && !valueStr.trim().isEmpty()) {
            try {
                value = Double.parseDouble(valueStr.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR", "Giá trị ưu đãi không hợp lệ, vui lòng nhập số.");
                forwardBackToEdit(request, response, id);
                return;
            }
        }

        // ─── VALIDATION RÀNG BUỘC type ↔ value (YÊU CẦU MỚI) ────────
        // Với DISC_PERCENT và DISC_VND, giá trị ưu đãi bắt buộc phải > 0.
        // Ví dụ: chọn loại "Giảm theo VND" mà giá trị ưu đãi = 0 thì không hợp lý.
        if (("DISC_PERCENT".equals(type) || "DISC_VND".equals(type)) && value <= 0) {
            request.setAttribute("ERROR", "Loại \"" + type + "\" bắt buộc giá trị ưu đãi phải lớn hơn 0.");
            forwardBackToEdit(request, response, id);
            return;
        }
        // Với FREE_WASH / FREE_UPGRADE, không cần value → ép về 0 cho sạch dữ liệu
        if ("FREE_WASH".equals(type) || "FREE_UPGRADE".equals(type)) {
            value = 0;
        }

        // ── Tạo đối tượng Reward để cập nhật ─────────────────────────
        Reward r = new Reward();
        r.setId(id);
        r.setName(name.trim());
        r.setDescription((description != null && !description.trim().isEmpty())
                          ? description.trim() : null);
        r.setType(type);
        r.setPointsCost(pointsCost);
        r.setValue(value);

        if (tierStr != null && !tierStr.trim().isEmpty()) {
            try {
                r.setMinTierId(Integer.parseInt(tierStr.trim()));
            } catch (NumberFormatException e) {
                r.setMinTierId(null);
            }
        } else {
            r.setMinTierId(null);
        }

        if (startStr != null && !startStr.trim().isEmpty()) {
            r.setStartDate(java.sql.Date.valueOf(startStr.trim()));
        }
        if (endStr != null && !endStr.trim().isEmpty()) {
            r.setEndDate(java.sql.Date.valueOf(endStr.trim()));
        }

        r.setActive(isActive);

        // ── Gọi DAO để cập nhật database ─────────────────────────────
        RewardDAO dao = new RewardDAO();
        int result = dao.updateReward(r);

        if (result > 0) {
            request.getSession().setAttribute("SUCCESS_MSG",
                    "Cập nhật \"" + name + "\" thành công!");
            response.sendRedirect("manageReward");
        } else {
            request.setAttribute("ERROR", "Cập nhật thất bại! Vui lòng thử lại.");
            forwardBackToEdit(request, response, id);
        }
    }

    // ── Hàm tiện ích: load lại dữ liệu và quay về form khi có lỗi ───
    private void forwardBackToEdit(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        RewardDAO dao = new RewardDAO();
        Reward r = dao.getById(id);
        request.setAttribute("reward", r);
        request.getRequestDispatcher("editReward.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet sửa phần thưởng hoặc khuyến mãi";
    }
}
