package dao;

import dto.Vehicle;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import mylib.DBUtils;

/**
 * VehicleDao – xử lý database cho bảng vehicles.
 *
 * ĐÃ SỬA so với bản gốc:
 *   getCars()   : thêm AND is_active = 1 → chỉ lấy xe chưa bị xóa
 *   addCar()    : thêm is_active = 1 tường minh khi INSERT
 *   deleteCar() : ĐỔI từ DELETE thật → UPDATE is_active = 0 (soft delete)
 *                 → dữ liệu booking cũ không bị mất
 *   updateCar() : không thay đổi
 *   Constructor Vehicle : thêm tham số isActive
 */
public class VehicleDao {

    // ── LẤY DANH SÁCH XE (chỉ xe còn hoạt động) ─────────────────────
    public ArrayList<Vehicle> getCars(int userId) {
        ArrayList<Vehicle> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // ĐÃ SỬA: thêm [is_active] vào SELECT và WHERE
                String sql = "SELECT [id],[user_id],[plate],[type],[brand],[model],[color],[is_active],[created_at] "
                           + "FROM [dbo].[vehicles] WHERE [user_id]=? AND [is_active]=1";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, userId);
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
                    list.add(new Vehicle(
                        rs.getInt("id"),
                        userId,
                        rs.getString("plate"),
                        rs.getString("type"),
                        rs.getString("brand"),
                        rs.getString("model"),
                        rs.getString("color"),
                        rs.getBoolean("is_active"),  // THÊM MỚI
                        rs.getDate("created_at")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return list;
    }

    // ── THÊM XE MỚI ─────────────────────────────────────────────────
    public int addCar(int userId, String plate, String type, String brand, String model, String color) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // ĐÃ SỬA: thêm is_active = 1 tường minh
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

    // ── XÓA XE – SOFT DELETE ────────────────────────────────────────
    /**
     * ĐÃ SỬA: KHÔNG còn DELETE thật nữa.
     * Chỉ đặt is_active = 0 → xe bị ẩn khỏi giao diện
     * nhưng booking cũ của xe vẫn còn trong database.
     *
     * Trước (bản gốc): DELETE FROM vehicles WHERE id = ?
     * Sau  (đã sửa)  : UPDATE vehicles SET is_active = 0 WHERE id = ?
     */
    public int deleteCar(int carId, int userId) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // ĐÃ SỬA: soft delete thay vì xóa thật
                String sql = "UPDATE [dbo].[vehicles] SET [is_active]=0 WHERE [id]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, carId);
                result = st.executeUpdate();
                System.out.println("[deleteCar] carId=" + carId + " → is_active=0 (soft delete)");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return result;
    }

    // ── CẬP NHẬT THÔNG TIN XE ───────────────────────────────────────
    public int updateCar(String id, String plate, String brand, String model, String color) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE [dbo].[vehicles] "
                           + "SET [plate]=?, [brand]=?, [model]=?, [color]=? WHERE [id]=?";
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
