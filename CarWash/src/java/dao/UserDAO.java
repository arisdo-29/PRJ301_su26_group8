package dao;

import dto.User;
import dto.Vehicle;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import mylib.DBUtils;

/**
 * UserDAO – xử lý database cho bảng users và vehicles.
 *
 * ĐÃ SỬA so với bản gốc:
 *   getUserByPhone() : Bug cũ truyền biến "sql" (chuỗi query) làm email → đã sửa
 *                      thêm tham số password để dùng cho đăng nhập bằng SĐT
 *   getUser(email)   : Bug cũ truyền role 2 lần thay vì password → đã sửa
 *   getVehicleByPlate(): Bug cũ thiếu [type],[is_active] trong SELECT → đã sửa
 */
public class UserDAO {

    // ── TẠO USER MỚI ────────────────────────────────────────────────
    public int createNewUser(User u) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO dbo.users (phone_number, email, password, role, full_name, is_active) "
                           + "VALUES (?,?,?,?,?,?)";
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
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // ── ĐĂNG NHẬP BẰNG EMAIL + PASSWORD ─────────────────────────────
    public User getUser(String email, String password) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id],[phone_number],[email],[role],[full_name],[is_active],[created_at] "
                           + "FROM [dbo].[users] WHERE [email]=? AND [password]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                st.setString(2, password);
                ResultSet rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    result = new User(
                        rs.getInt("id"),
                        rs.getString("phone_number"),
                        email,
                        "",                         // password không trả về (bảo mật)
                        rs.getString("role"),
                        rs.getString("full_name"),
                        rs.getBoolean("is_active"),
                        rs.getDate("created_at")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // ── LẤY USER THEO EMAIL (không cần password, dùng để kiểm tra trùng) ──
    public User getUser(String email) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id],[phone_number],[email],[role],[full_name],[is_active],[created_at] "
                           + "FROM [dbo].[users] WHERE [email]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                ResultSet rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    // ĐÃ SỬA: bản gốc truyền role 2 lần, thiếu email
                    result = new User(
                        rs.getInt("id"),
                        rs.getString("phone_number"),
                        email,
                        "",                         // password để trống
                        rs.getString("role"),
                        rs.getString("full_name"),
                        rs.getBoolean("is_active"),
                        rs.getDate("created_at")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // ── ĐĂNG NHẬP BẰNG SỐ ĐIỆN THOẠI + PASSWORD ─────────────────────
    /**
     * ĐÃ SỬA: bản gốc có bug truyền biến "sql" làm email.
     * Thêm tham số password để dùng cho đăng nhập.
     */
    public User getUserByPhone(String phone, String password) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id],[phone_number],[email],[role],[full_name],[is_active],[created_at] "
                           + "FROM [dbo].[users] WHERE [phone_number]=? AND [password]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, phone);
                st.setString(2, password);
                ResultSet rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    // ĐÃ SỬA: bản gốc truyền "sql" (chuỗi query!) thay cho email
                    result = new User(
                        rs.getInt("id"),
                        rs.getString("phone_number"),
                        rs.getString("email"),      // đọc email từ DB
                        "",
                        rs.getString("role"),
                        rs.getString("full_name"),
                        rs.getBoolean("is_active"),
                        rs.getDate("created_at")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    /**
     * Overload không cần password – dùng khi KIỂM TRA TRÙNG số điện thoại
     * (ví dụ: trong register.java khi check foundPhone)
     */
    public User getUserByPhone(String phone) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id],[phone_number],[email],[role],[full_name],[is_active],[created_at] "
                           + "FROM [dbo].[users] WHERE [phone_number]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, phone);
                ResultSet rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    result = new User(
                        rs.getInt("id"),
                        rs.getString("phone_number"),
                        rs.getString("email"),
                        "",
                        rs.getString("role"),
                        rs.getString("full_name"),
                        rs.getBoolean("is_active"),
                        rs.getDate("created_at")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // ── LẤY XE THEO BIỂN SỐ (dùng cho LPR / register check) ─────────
    /**
     * ĐÃ SỬA: bản gốc thiếu [type] và [is_active] trong SELECT
     * nhưng lại gọi rs.getString("type") → SQLException lúc runtime.
     * Thêm AND is_active = 1 để không trả xe đã bị xóa mềm.
     */
    public Vehicle getVehicleByPlate(String plate) {
        Vehicle result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // ĐÃ SỬA: thêm [type], [is_active] vào SELECT
                String sql = "SELECT [id],[user_id],[plate],[type],[brand],[model],[color],[is_active],[created_at] "
                           + "FROM [dbo].[vehicles] WHERE [plate]=? AND [is_active]=1";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, plate);
                ResultSet rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    result = new Vehicle(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("plate"),
                        rs.getString("type"),
                        rs.getString("brand"),
                        rs.getString("model"),
                        rs.getString("color"),
                        rs.getBoolean("is_active"),
                        rs.getDate("created_at")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // ── CẬP NHẬT PROFILE ─────────────────────────────────────────────
    public int updateProfile(User u) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "UPDATE dbo.users SET full_name=?, phone_number=? WHERE id=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, u.getFullName());
                st.setString(2, u.getPhoneNumber());
                st.setInt(3, u.getId());
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // ── TẠO LOYALTY ACCOUNT KHI ĐĂNG KÝ ──────────────────────────────
    public int createLoyaltyAccount(int userId) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO dbo.loyalty_accounts "
                           + "(user_id, tier_id, points, total_points, total_spend, total_washes, tier_since) "
                           + "VALUES(?, 1, 0, 0, 0, 0, CAST(GETDATE() AS DATE))";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setInt(1, userId);
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }
}
