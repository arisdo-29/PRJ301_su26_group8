package controller;

import dao.VehicleDao;
import dto.User;
import dto.Vehicle;
import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet(name = "getcars", urlPatterns = {"/getcars"})
public class getcars extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("USER");
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        VehicleDao dao = new VehicleDao();
        ArrayList<Vehicle> list = dao.getCars(user.getId());

        request.setAttribute("LISTCARS", list);
        request.getRequestDispatcher("viewcars_page.jsp").forward(request, response);
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
}
