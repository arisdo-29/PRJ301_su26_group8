
package dao;

import dto.User;
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
                String sql = "INSERT INTO dbo.users(login_id, password, role, full_name, email, is_active) "
                           + "VALUES(?,?,?,?,?,?)";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, u.getLoginId());
                st.setString(2, u.getPassword());
                st.setString(3, "CUSTOMER");
                st.setString(4, u.getFullName());
                st.setString(5, u.getEmail());
                st.setBoolean(6, true);
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    public User getUser(String email, String password) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id],[login_id],[role],[full_name],[email],[phone_number],[is_active],[created_at] "
                           + "FROM [dbo].[users] "
                           + "WHERE [email]=? AND [password]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                st.setString(2, password);
                ResultSet table = st.executeQuery();
                if (table != null && table.next()) {
                    int uid = table.getInt("id");
                    String logid = table.getString("login_id");
                    String role = table.getString("role");
                    String fullName = table.getString("full_name");
                    String phoneName = table.getString("phone_number");
                    boolean isActive = table.getBoolean("is_active");
                    Date date = table.getDate("created_at");
                    result = new User(uid, logid, "", role, fullName, email, phoneName, isActive, date);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    public User getUser(String email) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id],[login_id],[role],[full_name],[email],[phone_number],[is_active],[created_at] "
                           + "FROM [dbo].[users] "
                           + "WHERE [email]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                ResultSet table = st.executeQuery();
                if (table != null && table.next()) {
                    int uid = table.getInt("id");
                    String logid = table.getString("login_id");
                    String role = table.getString("role");
                    String fullName = table.getString("full_name");
                    String phoneName = table.getString("phone_number");
                    boolean isActive = table.getBoolean("is_active");
                    Date date = table.getDate("created_at");
                    result = new User(uid, logid, "", role, fullName, email, phoneName, isActive, date);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
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
            try { if (cn != null) cn.close(); } catch (Exception e) {}
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
                if (cn != null) cn.close();   
            } catch (Exception e) {
            }
        }
        return result;
    }
}