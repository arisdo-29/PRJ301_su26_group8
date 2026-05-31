package controller;

import dao.UserDAO;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "SaveProfile",
        urlPatterns = {"/SaveProfile"})
public class SaveProfile extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(
                request.getParameter("txtUserId"));

        String fullName =
                request.getParameter("txtFullName");

        String phone =
                request.getParameter("txtPhone");

        User u = new User();

        u.setId(id);
        u.setFullName(fullName);
        u.setPhoneNumber(phone);

        UserDAO dao = new UserDAO();

        int result = dao.updateProfile(u);

        if (result > 0) {

            User sessionUser =
                    (User) request.getSession()
                            .getAttribute("USER");

            if (sessionUser != null) {
                sessionUser.setFullName(fullName);
                sessionUser.setPhoneNumber(phone);
            }

            response.sendRedirect("dashboard");

        } else {

            response.sendRedirect("editprofile.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Save Profile Servlet";
    }
}