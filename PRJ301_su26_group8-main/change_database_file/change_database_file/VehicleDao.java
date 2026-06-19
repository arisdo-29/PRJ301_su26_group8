package dao;

import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import mylib.DBUtils;

/**
 * THAY ĐỔI so với v1:
 *
 *   getCars()   : thêm WHERE is_active = 1 → chỉ trả xe chưa bị xóa
 *   deleteCar() : KHÔNG còn DELETE thật, thay bằng UPDATE is_active = 0 (soft delete)
 *                 → dữ liệu booking cũ vẫn còn nguyên vẹn
 *   addCar()    : thêm is_active = 1 tường minh
 *   updateCar() : không thay đổi
 *
 *   Constructor Vehicle: thêm tham số isActive (rs.getBoolean("is_active"))
 */
public class VehicleDao {

    // Helper: map một hàng ResultSet thành Vehicle object
    private Vehicle mapRow(ResultSet rs, int userId) throws Exception {
        return new Vehicle(
            rs.getInt("id"),
            userId,
            rs.getString("plate"),
            rs.getString("type"),
            rs.getString("brand"),
            rs.getString("model"),
            rs.getString("color"),
            rs.getBoolean("is_active"),   // THÊM MỚI
            rs.getDate("created_at")
        );
    }

    /**
     * Lấy danh sách xe của user.
     * THAY ĐỔI: thêm "AND is_active = 1" → không hiển thị xe đã "xóa".
     */
    public ArrayList<Vehicle> getCars(int userId) {
        ArrayList<Vehicle> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // THAY ĐỔI: thêm AND is_active = 1
                String sql = "SELECT [id],[user_id],[plate],[type],[brand],[model],[color],[is_active],[created_at] "
                           + "FROM [dbo].[vehicles] "
                           + "WHERE [user_id] = ? AND [is_active] = 1";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, userId);
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
                    list.add(mapRow(rs, userId));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return list;
    }

    /**
     * Thêm xe mới.
     * THAY ĐỔI: tường minh is_active = 1
     */
    public int addCar(int userId, String plate, String type, String brand, String model, String color) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO [dbo].[vehicles] "
                           + "([user_id],[plate],[type],[brand],[model],[color],[is_active],[created_at]) "
                           + "VALUES (?,?,?,?,?,?,1,GETDATE())";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, userId);
                st.setString(2, plate);
                st.setString(3, type);
                st.setString(4, brand);
                st.setString(5, model);
                st.setString(6, color);
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return result;
    }

    /**
     * Xóa xe – SOFT DELETE: chỉ đặt is_active = 0, KHÔNG xóa dòng.
     *
     * THAY ĐỔI: đổi từ "DELETE ... WHERE id=?" thành "UPDATE ... SET is_active=0 WHERE id=?"
     * → Toàn bộ booking cũ của xe này vẫn còn nguyên trong DB.
     */
    public int deleteCar(int carId, int userId) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // THAY ĐỔI: soft delete thay vì DELETE thật
                String sql = "UPDATE [dbo].[vehicles] SET [is_active] = 0 WHERE [id] = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, carId);
                result = st.executeUpdate();
                System.out.println("[deleteCar] carId=" + carId + " | rows updated=" + result + " (soft delete)");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return result;
    }

    /**
     * Cập nhật thông tin xe.
     * Không thay đổi so với v1.
     */
    public int updateCar(String id, String plate, String brand, String model, String color) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE [dbo].[vehicles] "
                           + "SET [plate]=?, [brand]=?, [model]=?, [color]=? "
                           + "WHERE [id]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, plate);
                st.setString(2, brand);
                st.setString(3, model);
                st.setString(4, color);
                st.setInt(5, Integer.parseInt(id));
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return result;
    }
}
