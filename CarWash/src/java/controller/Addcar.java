package controller;

import dao.VehicleDao;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "addcar", urlPatterns = {"/addcar"})
public class Addcar extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("USER");
        if (user == null) { response.sendRedirect("index.jsp"); return; }
        // Mở editcar.jsp ở tab Thêm xe (không truyền txtid → defaultTab = "add")
        response.sendRedirect("editcar.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("USER");
        if (user == null) { response.sendRedirect("index.jsp"); return; }

        String plate = request.getParameter("txtlicenseplate");
        String type = request.getParameter("txttype");
        String brand = request.getParameter("txtbrand");
        String model = request.getParameter("txtmodel");
        String color = request.getParameter("txtcolor");

        // Validate
        if (plate == null || plate.trim().isEmpty()
                || brand == null || brand.trim().isEmpty()) {
            // Thiếu thông tin → quay lại editcar.jsp tab Thêm
            response.sendRedirect("editcar.jsp?error=missing");
            return;
        }

        VehicleDao dao = new VehicleDao();
        int result = dao.addCar(user.getId(),
                plate.trim(),type, brand.trim(),
                model  != null ? model.trim()  : "",
                color  != null ? color.trim()  : "");

        if (result > 0) {
            response.sendRedirect("getcars?msg=added");
        } else {
            response.sendRedirect("editcar.jsp?error=failed");
        }
    }
}