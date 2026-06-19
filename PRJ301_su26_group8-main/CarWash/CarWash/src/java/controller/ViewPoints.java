package controller;

import dao.LoyaltyDAO;
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

            request.setAttribute("account", account);
            request.setAttribute("logs",    logs);
            request.setAttribute("rewards", rewards);

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
