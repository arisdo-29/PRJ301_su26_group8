
package controller;

import dao.UserDAO;
import dao.VehicleDao;
import dto.User;
import dto.Vehicle;
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
            request.getRequestDispatcher("register_page.jsp").forward(request, response);
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
   
        String fullName = request.getParameter("txtfullName");
        String email = request.getParameter("txtemail");
        String password = request.getParameter("txtpassword");
        String phone    = request.getParameter("txtphone");
        String licensePlate = request.getParameter("txtlicensePlate");
        String brand = request.getParameter("txtBrand");
        
        UserDAO d=new UserDAO();
        User u = new User();
        
        u.setFullName(fullName);
        u.setEmail(email);
        
        u.setPassword(password);
        u.setPhoneName(phone);
        u.setIsActive(true);
        Date createDate = new Date(System.currentTimeMillis());
        u.setCreateAt(createDate);
        
        User found = d.getUser(email);
        User foundPhone = d.getUserByPhone(phone);
        Vehicle foundPlate = d.getVehicleByPlate(licensePlate);
        if(found==null && foundPhone == null && foundPlate == null){
            int rs=d.createNewUser(u);
            if(rs>=1){
                
                User newUser = d.getUser(email);
                if (newUser != null) {
                d.createLoyaltyAccount(newUser.getId());
                VehicleDao vd = new VehicleDao();
                vd.addCar(
                    newUser.getId(),
                    licensePlate,
                    "",           // type (để trống)
                    brand,        // brand - đúng vị trí
                    "",           // model
                    ""            // color
                );
            }
                response.sendRedirect("index.jsp");
            }
            else{
                response.getWriter().print("account Created fail!");
            }
        }
        else{
            if(found != null){
                request.setAttribute("ERROR", "email is duplicated!");
            }
            else if(foundPhone != null){
                request.setAttribute("ERROR", "phone number is duplicated!");
            }
            else{
                request.setAttribute("ERROR", "license plate is duplicated!");
            }
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("licensePlate", licensePlate);
            request.getRequestDispatcher("register_page.jsp").forward(request, response);
        }
        
    }

  
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
