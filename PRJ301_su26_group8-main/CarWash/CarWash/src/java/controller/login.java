package controller;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/login")
public class login extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) {

        try {
            
            //lay du lieu tu form
            String email = request.getParameter("txtemail");
            String password = request.getParameter("txtpassword");
            UserDAO u = new UserDAO();
            User rs = u.getUser(email, password);

            if (rs == null) {
                String msg = "Email hoặc mật khẩu nhập sai!";
                request.setAttribute("ERROR", msg);
                request.getRequestDispatcher("login_page.jsp").forward(request, response);
            } else {
                if (rs.isIsActive()) {
                    request.getSession().setAttribute("USER", rs);
                    if (!rs.getRole().equalsIgnoreCase("CUSTOMER")) {
                        response.sendRedirect("admin_page.jsp");
                    } else {
                        response.sendRedirect("HomeMember_page.jsp");
                    }
                } else {
                    String msg = "Tài khoản của bạn đã bị khóa. Vui lòng liên hệ quản trị viên.";
                    request.setAttribute("ERROR", msg);
                    request.getRequestDispatcher("login_page.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
