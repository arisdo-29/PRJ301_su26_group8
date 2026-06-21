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
 * addPromotion – Servlet xử lý thêm Promotion mới (points_cost = 0).
 * URL: /addPromotion
 *
 * Promotion KHÔNG yêu cầu điểm đổi (admin cấu hình, tự động áp dụng).
 * Dùng chung bảng rewards với Reward, chỉ khác ở chỗ points_cost = 0.
 *
 * GET  → hiển thị form addPromotion.jsp
 * POST → đọc dữ liệu form → gọi RewardDAO.addReward() với points_cost=0 → chuyển về manageReward
 *
 * ĐÃ SỬA: validation type ↔ value chặt hơn. Trước đây chỉ kiểm tra "có nhập
 * value hay không" nên value = 0 vẫn lọt qua. Nay bắt buộc value PHẢI > 0
 * khi type là DISC_PERCENT hoặc DISC_VND.
 */
@WebServlet(name = "addPromotion", urlPatterns = {"/addPromotion"})
public class addPromotion extends HttpServlet {

    // ── GET: hiển thị form thêm promotion ───────────────────────────
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

        request.getRequestDispatcher("addPromotion.jsp").forward(request, response);
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
        String valueStr    = request.getParameter("value");
        String tierStr     = request.getParameter("minTierId");
        String startStr    = request.getParameter("startDate");
        String endStr      = request.getParameter("endDate");
        boolean isActive   = "on".equals(request.getParameter("isActive"));

        // ── Validate bắt buộc ────────────────────────────────────────
        if (name == null || name.trim().isEmpty() || type == null || type.isEmpty()) {
            request.setAttribute("ERROR", "Vui lòng điền tên và chọn loại khuyến mãi.");
            request.getRequestDispatcher("addPromotion.jsp").forward(request, response);
            return;
        }

        // ─── VALIDATION RÀNG BUỘC type ↔ value (ĐÃ SỬA) ─────────────
        // Trước đây chỉ kiểm tra "có nhập value hay không", nên người dùng
        // vẫn có thể nhập value = 0 cho loại giảm giá → vô lý nghiệp vụ.
        // Nay kiểm tra value phải PARSE ĐƯỢC và LỚN HƠN 0.
        double value = 0;
        if (valueStr != null && !valueStr.trim().isEmpty()) {
            try {
                value = Double.parseDouble(valueStr.trim());
            } catch (NumberFormatException e) {
                request.setAttribute("ERROR", "Giá trị ưu đãi không hợp lệ, vui lòng nhập số.");
                request.getRequestDispatcher("addPromotion.jsp").forward(request, response);
                return;
            }
        }
        if (("DISC_PERCENT".equals(type) || "DISC_VND".equals(type)) && value <= 0) {
            request.setAttribute("ERROR",
                "Loại \"" + ("DISC_PERCENT".equals(type) ? "Giảm phần trăm" : "Giảm theo VND")
                + "\" bắt buộc giá trị ưu đãi phải lớn hơn 0.");
            request.getRequestDispatcher("addPromotion.jsp").forward(request, response);
            return;
        }
        // FREE_WASH không cần value → ép về 0 cho sạch dữ liệu
        if ("FREE_WASH".equals(type)) {
            value = 0;
        }

        // ── Tạo đối tượng Reward (loại Promotion) ───────────────────
        Reward r = new Reward();
        r.setName(name.trim());
        r.setDescription((description != null && !description.trim().isEmpty())
                          ? description.trim() : null);
        r.setType(type);
        r.setValue(value);

        // QUAN TRỌNG: points_cost = 0 → đây là Promotion, không cần đổi điểm
        r.setPointsCost(0);

        // (Giá trị ưu đãi đã được parse và validate ở khối phía trên, không cần lặp lại)

        // Hạng áp dụng (null = tất cả hạng)
        if (tierStr != null && !tierStr.trim().isEmpty()) {
            try {
                r.setMinTierId(Integer.parseInt(tierStr.trim()));
            } catch (NumberFormatException e) {
                r.setMinTierId(null);
            }
        }

        // Ngày bắt đầu / kết thúc
        if (startStr != null && !startStr.trim().isEmpty()) {
            r.setStartDate(java.sql.Date.valueOf(startStr.trim()));
        }
        if (endStr != null && !endStr.trim().isEmpty()) {
            r.setEndDate(java.sql.Date.valueOf(endStr.trim()));
        }

        r.setActive(isActive);

        // ── Gọi DAO để lưu vào database ─────────────────────────────
        RewardDAO dao = new RewardDAO();
        int result = dao.addReward(r);  // Cùng dùng method addReward, bảng rewards chung

        if (result > 0) {
            request.getSession().setAttribute("SUCCESS_MSG", "Thêm khuyến mãi \"" + name + "\" thành công!");
            response.sendRedirect("manageReward");
        } else {
            request.setAttribute("ERROR", "Thêm khuyến mãi thất bại! Vui lòng thử lại.");
            request.getRequestDispatcher("addPromotion.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet thêm khuyến mãi mới";
    }
}
