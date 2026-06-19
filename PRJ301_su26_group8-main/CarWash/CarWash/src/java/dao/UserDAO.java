package dao;

import dto.User;
import dto.Vehicle;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import mylib.DBUtils;

public class UserDAO {

    public int createNewUser(User u) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "insert into [dbo].[users] ([phone_number], [email], [password], [role], [full_name], [is_active]) values (?,?,?,?,?,?)";
                PreparedStatement st = cn.prepareStatement(sql);
                
                st.setString(1, u.getPhoneNumber()); 
                st.setString(2, u.getEmail());
                st.setString(3, u.getPassword());
                st.setString(4, "CUSTOMER");
                st.setString(5, u.getFullName());
                st.setBoolean(6, true);
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
            }
        }
        return result;
    }

    public User getUser(String email, String password) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select [id], [phone_number], [email], [password], [role], [full_name], [is_active], [created_at]\n" +
                            "from [dbo].[users]\n" +
                            "where [email] =? and [password] = ?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                st.setString(2, password);
                ResultSet table = st.executeQuery();
                if (table != null && table.next()) {
                    int uid = table.getInt("id");
                    
                    String role = table.getString("role");
                    String fullName = table.getString("full_name");
                    String phoneName = table.getString("phone_number");
                    boolean isActive = table.getBoolean("is_active");
                    Date date = table.getDate("created_at");
                    result = new User(uid, phoneName, email, password, role, fullName, isActive, date);
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
            }
        }
        return result;
    }

    public User getUser(String email) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "select [id], [phone_number], [email], [password], [role], [full_name], [is_active], [created_at]\n" +
                            "from [dbo].[users]\n" +
                            "where [email] =?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                ResultSet table = st.executeQuery();
                if (table != null && table.next()) {
                    int uid = table.getInt("id");
                    String phoneName = table.getString("phone_number");                   
                    String role = table.getString("role");
                    String fullName = table.getString("full_name");
                    boolean isActive = table.getBoolean("is_active");
                    Date date = table.getDate("created_at");
                    result = new User(uid, phoneName, email, role, role, fullName, isActive, date);
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
            }
        }
        return result;
    }
    
    public User getUserByPhone(String phone){
        User result = null;
        Connection cn = null;
        try{
            cn = DBUtils.getConnection();
            if(cn!=null){
                String sql="select [id], [phone_number], [email], [password], [role], [full_name], [is_active], [created_at]\n" +
                            "from [dbo].[users]\n" +
                            "where [phone_number]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, phone);
                ResultSet table = st.executeQuery();
                if(table != null && table.next()){
                    int uid = table.getInt("id");
                    String phoneName = table.getString("phone_number");                   
                    String role = table.getString("role");
                    String fullName = table.getString("full_name");
                    boolean isActive = table.getBoolean("is_active");
                    Date date = table.getDate("created_at");
                    result = new User(uid, phoneName, sql, phone, role, fullName, isActive, date);
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            try{
                if(cn!=null){
                    cn.close();
                }
            }catch(Exception e){
                
            }
        }
        
        return result;
    }
    
    public Vehicle getVehicleByPlate(String plate) {
        Vehicle result = null;
        Connection cn = null;

        try {
            cn = DBUtils.getConnection();

            if(cn != null){
                String sql =
                    "select [id], [user_id], [plate], [brand], [model], [color], [created_at]\n" +
                    "from [dbo].[vehicles]\n" +
                    "where [plate] =?";

                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, plate);

                ResultSet rs = st.executeQuery();

                if(rs != null && rs.next()){
                    result = new Vehicle(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("plate"),
                        rs.getString("type"),
                        rs.getString("brand"),
                        rs.getString("model"),
                        rs.getString("color"),
                        
                        rs.getDate("created_at")
                    );
                }
            }
        } catch(Exception e){
            e.printStackTrace();
        } finally{
            try{
                if(cn != null) cn.close();
            }catch(Exception e){}
        }

        return result;
}

    public int updateProfile(User u) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE dbo.users SET full_name=?, phone_number=? WHERE id=?";
                PreparedStatement pst = cn.prepareStatement(sql);
                pst.setString(1, u.getFullName());
                pst.setString(2, u.getPhoneNumber());
                pst.setInt(3, u.getId());
                result = pst.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
            } catch (Exception e) {
            }
        }
        return result;
    }
    
    

    public int createLoyaltyAccount(int userId) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO dbo.loyalty_accounts(user_id, tier_id, points, total_points, total_spend, total_washes, tier_since) "
                        + "VALUES(?, 1, 0, 0, 0, 0, CAST(GETDATE() AS DATE))";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, userId);
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
            }
        }
        return result;
    }
}
