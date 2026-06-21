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
 * deleteReward – Servlet xử lý tạm dừng Reward hoặc Promotion (soft delete).
 * URL: /deleteReward?id=...
 *
 * LƯU Ý QUAN TRỌNG: đây là TẠM DỪNG MỀM, KHÔNG xóa hẳn dòng trong database.
 * Servlet chỉ set is_active = 0 (thông qua RewardDAO.deactivateReward()).
 *
 * Lý do dùng xóa mềm thay vì DELETE FROM rewards:
 *   - Bảng redemptions có cột reward_id tham chiếu khóa ngoại tới rewards.id
 *   - Nếu khách hàng đã từng đổi reward này (có dòng trong redemptions),
 *     xóa cứng sẽ làm vỡ ràng buộc khóa ngoại hoặc mất lịch sử đổi thưởng.
 *   - Sau khi tạm dừng, reward/promotion sẽ KHÔNG còn hiển thị active
 *     trong manageReward.jsp, my_points.jsp (vì các DAO chỉ lấy is_active=1),
 *     nhưng dữ liệu cũ trong redemptions vẫn còn nguyên vẹn để tra cứu.
 *
 * Chỉ dùng method GET (gọi từ nút "Tạm dừng" có confirm bằng JavaScript),
 * không cần form/POST vì không có input phức tạp.
 */
@WebServlet(name = "deleteReward", urlPatterns = {"/deleteReward"})
public class deleteReward extends HttpServlet {

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

        String idStr = request.getParameter("id");
        int id = -1;
        try { id = Integer.parseInt(idStr); } catch (Exception e) { /* id không hợp lệ */ }

        if (id > 0) {
            RewardDAO dao = new RewardDAO();
            Reward item = dao.getById(id);
            int result = dao.deactivateReward(id);
            if (result > 0) {
                if (item != null) {
                    String typeLabel = item.getPointsCost() == 0 ? "khuyến mãi" : "phần thưởng";
                    request.getSession().setAttribute("SUCCESS_MSG",
                        "Đã tạm dừng " + typeLabel + " \"" + item.getName() + "\" thành công.");
                } else {
                    request.getSession().setAttribute("SUCCESS_MSG", "Đã tạm dừng thành công.");
                }
            } else {
                request.getSession().setAttribute("SUCCESS_MSG", "Tạm dừng thất bại, vui lòng thử lại.");
            }
        }

        response.sendRedirect("manageReward");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xóa (mềm) phần thưởng hoặc khuyến mãi";
    }
}
