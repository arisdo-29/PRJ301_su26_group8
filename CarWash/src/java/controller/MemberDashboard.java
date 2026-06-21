package controller;

import dao.LoyaltyDAO;
import dto.LoyaltyAccount;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet(name = "MemberDashboard", urlPatterns = {"/dashboard"})
public class MemberDashboard extends HttpServlet {

    public void processRequest(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("USER") == null) {
                response.sendRedirect("login_page.jsp");
                return;
            }

            User user = (User) session.getAttribute("USER");

            // Load loyalty account để hiển thị điểm + tier trên dashboard
            LoyaltyDAO loyaltyDAO = new LoyaltyDAO();
            LoyaltyAccount account = loyaltyDAO.getByUserId(user.getId());
            request.setAttribute("account", account);

            request.getRequestDispatcher("MemberDashboard_page.jsp").forward(request, response);

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
