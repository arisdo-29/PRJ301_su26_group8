
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


@WebServlet(name = "login", urlPatterns = {"/login"})
public class login extends HttpServlet {

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response){
            
        try {
            // lay email va password trong form login ra
            String email = request.getParameter("txtemail");
            String password =request.getParameter("txtpassword");
            UserDAO u = new UserDAO();
            User rs = u.getUser(email, password);
            
            if(rs==null){
                String msg ="Email or password is invalid";
                //save msg vao request de dung no trong trang login_page.jsp
                request.setAttribute("ERROR",msg);
                //response.sendRedirect("login_page.jsp");
                //chuyen trang bang ham tren la ko phu hop,
                //vi req, res cua trang login.java va login_page.jsp la khac nhau
                request.getRequestDispatcher("login_page.jsp").forward(request, response);
                }else{
                if(rs.isIsActive()){
                   //can luu rs vao session de su dung
                   // data nay trong nhieu chuc nang tiep theo
                   request.getSession().setAttribute("USER", rs);
                   //mo file 
                   response.sendRedirect("MemberDashboard.jsp");// chuyen vao trang home sau dang nhap
                }else{
                   response.getWriter().print("access deny!!!!");
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
