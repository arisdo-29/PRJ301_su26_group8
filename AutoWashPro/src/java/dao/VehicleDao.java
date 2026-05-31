package dao;

import dbo.Vehicle;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import lib.DBUtils;

public class VehicleDao {

    // Lấy danh sách xe của một user
    public ArrayList<Vehicle> getCars(int userId) {

        ArrayList<Vehicle> list = new ArrayList<>();

        Connection cn = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql = "SELECT id, user_id, plate, brand, model, color, created_at "
                           + "FROM vehicles "
                           + "WHERE user_id = ?";

                PreparedStatement st = cn.prepareStatement(sql);

                st.setInt(1, userId);

                ResultSet rs = st.executeQuery();

                while (rs.next()) {

                    int id = rs.getInt("id");

                    String plate = rs.getString("plate");

                    String brand = rs.getString("brand");

                    String model = rs.getString("model");

                    String color = rs.getString("color");

                    Date createdAt = rs.getDate("created_at");

                   Vehicle v = new Vehicle(
                            id,
                            userId,
                            plate,
                            brand,
                            model,
                            color,
                            createdAt
                        );
                    list.add(v);
                }
            }

        } catch (Exception e) {

            e.printStackTrace();

        } finally {

            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return list;
    }

    // Cập nhật thông tin xe
    public int updateCar(String id,
                         String plate,
                         String brand,
                         String model,
                         String color) {

        int result = 0;

        Connection cn = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql = "UPDATE vehicles "
                           + "SET plate = ?, "
                           + "brand = ?, "
                           + "model = ?, "
                           + "color = ? "
                           + "WHERE id = ?";

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

            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return result;
    }

}