package dao;

import dto.Vehicle;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import mylib.DBUtils;

/**
 * DAO cho bảng [dbo].[vehicles]
 *
 * Sửa lỗi so với file gốc:
 *   - import dbo.Vehicle  → dto.Vehicle  (chuẩn hoá về package dto)
 *   - import lib.DBUtils  → mylib.DBUtils
 *   - rs.getString("plate") map vào setLicensePlate() cho khớp với Vehicle.java
 */
public class VehicleDao {

    /**
     * Lấy danh sách xe của một user theo userId.
     */
    public ArrayList<Vehicle> getCars(int userId) {
        ArrayList<Vehicle> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id], [user_id], [plate], [brand], [model], [color], [created_at] "
                           + "FROM [dbo].[vehicles] "
                           + "WHERE [user_id] = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, userId);
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
                    int    id         = rs.getInt("id");
                    String plate      = rs.getString("plate");
                    String brand      = rs.getString("brand");
                    String model      = rs.getString("model");
                    String color      = rs.getString("color");
                    Date   createdAt  = rs.getDate("created_at");
                    list.add(new Vehicle(id, userId, plate, brand, model, color, createdAt));
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
     * Cập nhật thông tin xe theo id.
     * @return số dòng bị ảnh hưởng (1 = thành công, 0 = thất bại)
     */
    public int updateCar(String id, String plate, String brand, String model, String color) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE [dbo].[vehicles] "
                           + "SET [plate] = ?, [brand] = ?, [model] = ?, [color] = ? "
                           + "WHERE [id] = ?";
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
