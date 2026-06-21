package controller;

import dao.LoyaltyDAO;
import dao.RewardDAO;
import dto.LoyaltyAccount;
import dto.PointLog;
import dto.Reward;
import dto.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * ĐÃ SỬA (MỚI): trang "Đổi thưởng" của customer (my_points.jsp) trước đây
 * chỉ hiển thị Reward (LoyaltyDAO.getActiveRewards() chỉ lấy points_cost > 0),
 * KHÔNG hiển thị Promotion (points_cost = 0) → khách không thấy khuyến mãi
 * đang chạy. Nay bổ sung lấy thêm danh sách Promotion qua RewardDAO.getAllPromotions()
 * và lọc lại chỉ giữ Promotion đang active + còn hạn, set vào request attribute
 * "promotions" để my_points.jsp hiển thị thêm 1 khu vực riêng.
 */
@WebServlet(name = "ViewPoints", urlPatterns = {"/my-points"})
public class ViewPoints extends HttpServlet {

    public void processRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("USER") == null) {
                response.sendRedirect("login_page.jsp");
                return;
            }

            User user = (User) session.getAttribute("USER");
            LoyaltyDAO d = new LoyaltyDAO();

            String action = request.getParameter("action");

            // REDEEM 
            if ("redeem".equals(action)) {
                int rewardId = -1;
                try { rewardId = Integer.parseInt(request.getParameter("rewardId")); } catch (Exception ex) {}

                LoyaltyAccount acc = d.getByUserId(user.getId());

                if (rewardId <= 0 || acc == null) {
                    request.setAttribute("ERROR", "Phần thưởng không hợp lệ.");
                } else {
                    String result = d.redeem(acc.getId(), rewardId, acc.getTierId());
                    if ("OK".equals(result)) {
                        request.setAttribute("SUCCESS", "Đổi thưởng thành công! Kiểm tra Lịch sử để biết chi tiết.");
                    } else {
                        request.setAttribute("ERROR", result);
                    }
                }
            }

            // LOAD DATA & FORWARD 
            LoyaltyAccount account = d.getByUserId(user.getId());
            List<PointLog> logs    = null;
            List<Reward>   rewards = null;

            if (account != null) {
                logs    = d.getRecentLogs(account.getId(), 10);
                rewards = d.getActiveRewards(account.getTierId());
            }

            // ── MỚI THÊM: lấy danh sách Promotion đang active để hiển thị ──
            // Dùng RewardDAO.getAllPromotions() (points_cost = 0), sau đó lọc
            // tay lại chỉ giữ những promotion: is_active = true VÀ còn hạn
            // (start_date <= hôm nay <= end_date, hoặc không giới hạn ngày).
            // Lọc ở Java thay vì sửa SQL trong DAO để không ảnh hưởng tới
            // các chỗ khác đang dùng getAllPromotions() (ví dụ trang admin
            // cần xem TẤT CẢ promotion kể cả đã tắt).
            RewardDAO rewardDAO = new RewardDAO();
            List<Reward> allPromotions = rewardDAO.getAllPromotions();
            java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
            List<Reward> promotions = new java.util.ArrayList<>();
            for (Reward p : allPromotions) {
                if (!p.isActive()) continue;
                if (p.getStartDate() != null && p.getStartDate().after(today)) continue;
                if (p.getEndDate()   != null && p.getEndDate().before(today))  continue;
                promotions.add(p);
            }

            request.setAttribute("account", account);
            request.setAttribute("logs",    logs);
            request.setAttribute("rewards", rewards);
            request.setAttribute("promotions", promotions); // MỚI THÊM

            request.getRequestDispatcher("my_points.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}

