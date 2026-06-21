package controller;

import dao.BookingDAO;
import dao.VehicleDao;
import dto.Booking;
import dto.User;
import dto.Vehicle;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet hiển thị lịch sử rửa xe của user đang đăng nhập.
 * Dùng BookingDAO.getWashHistory() có sẵn — lấy các booking có status = 'CHECKIN'.
 * Hỗ trợ tìm kiếm theo biển số xe và lọc theo khoảng ngày (lọc ở tầng Java
 * vì BookingDAO gốc không có sẵn hàm filter).
 *
 * GET /washhistory
 * GET /washhistory?plate=51A&fromDate=2026-06-01&toDate=2026-06-30
 */
@WebServlet(name = "washhistory", urlPatterns = {"/washhistory"})
public class washhistory extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("USER");
        if (user == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        BookingDAO bookingDao = new BookingDAO();
        ArrayList<Booking> historyList = bookingDao.getWashHistory(user.getId());

        // Lấy danh sách xe của user để map vehicleId -> Vehicle (biển số, hãng, model)
        VehicleDao vehicleDao = new VehicleDao();
        ArrayList<Vehicle> vehicles = vehicleDao.getCars(user.getId());
        Map<Integer, Vehicle> vehicleMap = new HashMap<>();
        for (Vehicle v : vehicles) {
            vehicleMap.put(v.getId(), v);
        }

        // ===== Đọc tham số tìm kiếm / lọc =====
        String plateKeyword = request.getParameter("plate");
        String fromDateStr  = request.getParameter("fromDate");
        String toDateStr    = request.getParameter("toDate");

        Date fromDate = parseDate(fromDateStr);
        Date toDate   = parseDate(toDateStr);

        // ===== Lọc danh sách theo biển số + khoảng ngày =====
        ArrayList<Booking> filteredList = new ArrayList<>();
        for (Booking b : historyList) {
            Vehicle v = vehicleMap.get(b.getVehicleId());

            // Lọc theo biển số (nếu có nhập từ khóa)
            if (plateKeyword != null && !plateKeyword.trim().isEmpty()) {
                if (v == null || v.getPlate() == null
                        || !v.getPlate().toUpperCase().contains(plateKeyword.trim().toUpperCase())) {
                    continue; // bỏ qua dòng không khớp biển số
                }
            }

            // Lọc theo ngày bắt đầu
            if (fromDate != null && b.getScheduledDate() != null
                    && b.getScheduledDate().before(fromDate)) {
                continue;
            }

            // Lọc theo ngày kết thúc
            if (toDate != null && b.getScheduledDate() != null
                    && b.getScheduledDate().after(toDate)) {
                continue;
            }

            filteredList.add(b);
        }

        // Tính tổng số lần rửa + tổng tiền đã chi (dựa trên danh sách ĐÃ LỌC)
        int totalCount = filteredList.size();
        double totalSpend = 0;
        for (Booking b : filteredList) {
            totalSpend += (b.getPrice() - b.getDiscount());
        }

        request.setAttribute("HISTORY", filteredList);
        request.setAttribute("VEHICLE_MAP", vehicleMap);
        request.setAttribute("TOTAL_COUNT", totalCount);
        request.setAttribute("TOTAL_SPEND", totalSpend);

        // Giữ lại giá trị đã nhập để hiển thị lại trên form tìm kiếm
        request.setAttribute("PLATE_KEYWORD", plateKeyword);
        request.setAttribute("FROM_DATE", fromDateStr);
        request.setAttribute("TO_DATE", toDateStr);

        request.getRequestDispatcher("washhistory.jsp").forward(request, response);
    }

    /**
     * Chuyển chuỗi "yyyy-MM-dd" (định dạng input type=date) thành java.sql.Date.
     * Trả về null nếu chuỗi rỗng hoặc sai định dạng.
     */
    private Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return null;
        try {
            return Date.valueOf(dateStr.trim()); // yêu cầu đúng định dạng yyyy-MM-dd
        } catch (IllegalArgumentException e) {
            return null;
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