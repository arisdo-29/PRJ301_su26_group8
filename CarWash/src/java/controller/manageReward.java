package controller;

import dao.RewardDAO;
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
 * manageReward – Servlet điều khiển trang quản lý phần thưởng & khuyến mãi.
 * URL: /manageReward
 *
 * Luồng xử lý:
 *   1. Kiểm tra đăng nhập + quyền admin
 *   2. Lấy danh sách Reward và Promotion từ database qua RewardDAO
 *   3. Set vào request rồi forward sang manageReward.jsp để hiển thị
 */
@WebServlet(name = "manageReward", urlPatterns = {"/manageReward"})
public class manageReward extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── BƯỚC 1: Kiểm tra đăng nhập ──────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("USER") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Chỉ ADMIN / MANAGER mới được vào, không cho CUSTOMER
        User user = (User) session.getAttribute("USER");
        if ("CUSTOMER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        // ── BƯỚC 2: Lấy dữ liệu từ database ─────────────────────────
        RewardDAO rewardDAO = new RewardDAO();
        List<Reward> rewards    = rewardDAO.getAllRewards();     // points_cost > 0
        List<Reward> promotions = rewardDAO.getAllPromotions();  // points_cost = 0

        // ── BƯỚC 3: Đưa dữ liệu vào request, chuyển sang JSP ────────
        request.setAttribute("rewards",    rewards);
        request.setAttribute("promotions", promotions);

        request.getRequestDispatcher("manageReward.jsp").forward(request, response);
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
        return "Servlet quản lý phần thưởng và khuyến mãi";
    }
}
