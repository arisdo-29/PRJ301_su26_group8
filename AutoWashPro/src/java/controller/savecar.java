package controller;

import dao.VehicleDao;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "savecar", urlPatterns = {"/savecar"})
public class savecar extends HttpServlet {

    protected void processRequest(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("txtid");
        String plate = request.getParameter("txtlicenseplate");
        String brand = request.getParameter("txtbrand");
        String model = request.getParameter("txtmodel");
        String color = request.getParameter("txtcolor");

        VehicleDao dao = new VehicleDao();

        int result = dao.updateCar(
                id,
                plate,
                brand,
                model,
                color
        );

        if (result > 0) {
            response.sendRedirect("getcars");
        } else {
            response.sendRedirect("editcar.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}