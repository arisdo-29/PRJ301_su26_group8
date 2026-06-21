package controller;

import dao.VehicleDao;
import dto.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet(name = "deletecar", urlPatterns = {"/deletecar"})
public class deletecar extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra đăng nhập
        User user = (User) request.getSession().getAttribute("USER");
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String idParam = request.getParameter("txtid");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("getcars");
            return;
        }

        try {
            int carId = Integer.parseInt(idParam.trim());

            VehicleDao dao = new VehicleDao();
            // Truyền cả userId để đảm bảo user chỉ xóa được xe của chính mình
            int result = dao.deleteCar(carId, user.getId());

            if (result > 0) {
                response.sendRedirect("getcars?msg=deleted");
            } else {
                response.sendRedirect("getcars?msg=error");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("getcars");
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
}
