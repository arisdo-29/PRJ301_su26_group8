package dao;

import dto.Vehicle;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import mylib.DBUtils;

public class VehicleDao {

    public ArrayList<Vehicle> getCars(int userId) {
        ArrayList<Vehicle> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id], [user_id], [plate],[type], [brand], [model], [color], [created_at] "
                           + "FROM [dbo].[vehicles] WHERE [user_id] = ?";
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

    public int addCar(int userId, String plate, String type, String brand, String model, String color) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO [dbo].[vehicles] ([user_id],[plate], [type], [brand],[model],[color],[created_at]) "
                           + "VALUES (?,?,?,?,?,?,GETDATE())";
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

    public int deleteCar(int carId, int userId) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // Xóa chỉ theo id — không cần check user_id nữa vì đã check ở servlet
                String sql = "DELETE FROM [dbo].[vehicles] WHERE [id] = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, carId);
                result = st.executeUpdate();
                System.out.println("[deleteCar] carId=" + carId + " | rows affected=" + result);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return result;
    }

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