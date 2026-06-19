
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class MainController extends HttpServlet {   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      
        try {
            String ac=request.getParameter("action");
            String url="index.jsp";
            if(ac==null){
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
            }
            switch (ac) {
                case "login":
                    url="login";
                    break;
                case "logout":
                    url="logout";
                    break;
                case "register":
                    url="register";
                    break;
                case "dashboard":
                url = "dashboard";
                break;

                case "viewCars":
                    url = "getcars";
                    break;

                case "myPoints":
                    url = "my-points";
                    break;

                case "editProfile":
                    url = "EditProfile";
                    break;

                case "saveProfile":
                    url = "SaveProfile";
                    break;

                case "saveCar":
                    url = "savecar";
                    break;
                case "showLogin":
                    url = "login_page.jsp";
                    break;

                case "showRegister":
                    url = "register_page.jsp";
                    break;

                case "home":
                    url = "HomeMember_page.jsp";
                    break;    
            }
            request.getRequestDispatcher(url).forward(request, response);
        }catch(Exception e){
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
