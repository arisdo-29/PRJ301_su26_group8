/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet(name = "register", urlPatterns = {"/register"})
public class register extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response){

        try {
            PrintWriter out = response.getWriter();
            out.print("<html>");
            out.print("<body>");
            out.print("</body>");
            out.print("</html>");
        }catch(Exception e){
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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        //lay value trong form
        String fullName = request.getParameter("txtfullName");
        String email = request.getParameter("txtemail");
        String password = request.getParameter("txtpassword");
        
        UserDAO d=new UserDAO();
        User u = new User();
        
        u.setFullName(fullName);
        u.setEmail(email);
        u.setLoginId(email);
        u.setPassword(password);
        u.setIsActive(true);
        Date createDate = new Date(System.currentTimeMillis());
        u.setCreateAt(createDate);
        //ham ben duoi de chen c vao DB
        User found = d.getUser(email);
        if(found==null){
            int rs=d.createNewUser(u);
            if(rs>=1){
                //chen tcong
                //mo lai file index.jsp de login
                response.sendRedirect("index.jsp");
            }
            else{
                //chen tbai
                response.getWriter().print("account Created fail!");
            }
        }
        else{
            String msg = "email is duplicated!";
            // save msg vao request 
            request.setAttribute("ERROR", msg);
             // mo trang register_page.jsp de xuat msg
             response.sendRedirect("register_page.jsp");
             request.getRequestDispatcher("register_page.jsp").forward(request, response);
        }
    }

  
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
