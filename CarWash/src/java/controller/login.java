package controller;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * login – Servlet xử lý đăng nhập.
 * URL: /login
 *
 * ĐÃ SỬA: hỗ trợ đăng nhập bằng email HOẶC số điện thoại.
 * Bản gốc chỉ đăng nhập được bằng email.
 *
 * Logic:
 *   - Nếu identifier chứa '@' → đăng nhập bằng email
 *   - Ngược lại              → đăng nhập bằng số điện thoại
 */
@WebServlet("/login")
public class login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Form dùng chung 1 ô nhập (email hoặc phone)
            String identifier = request.getParameter("txtemail");   // tên input giữ nguyên để không sửa JSP
            String password   = request.getParameter("txtpassword");

            UserDAO dao = new UserDAO();
            User rs = null;

            // ĐÃ SỬA: phân biệt email vs phone
            if (identifier != null && identifier.contains("@")) {
                // Đăng nhập bằng email
                rs = dao.getUser(identifier, password);
            } else {
                // Đăng nhập bằng số điện thoại
                rs = dao.getUserByPhone(identifier, password);
            }

            if (rs == null) {
                request.setAttribute("ERROR", "Email/SĐT hoặc mật khẩu không đúng!");
                request.getRequestDispatcher("login_page.jsp").forward(request, response);
            } else {
                if (rs.isIsActive()) {
                    request.getSession().setAttribute("USER", rs);
                    if (!"CUSTOMER".equalsIgnoreCase(rs.getRole())) {
                        response.sendRedirect("admin_page.jsp");
                    } else {
                        response.sendRedirect("HomeMember_page.jsp");
                    }
                } else {
                    request.setAttribute("ERROR", "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.");
                    request.getRequestDispatcher("login_page.jsp").forward(request, response);
                }
            }
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
    public String getServletInfo() { return "Servlet xử lý đăng nhập"; }
}
