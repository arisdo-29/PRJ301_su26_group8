package dao;

import dto.User;
import dto.Vehicle;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import mylib.DBUtils;

/**
 * THAY ĐỔI so với v1:
 *
 *   createNewUser() : bỏ login_id khỏi INSERT
 *   getUser(email, password)  : bỏ login_id khỏi SELECT, cập nhật constructor User
 *   getUser(email)            : bỏ login_id khỏi SELECT, cập nhật constructor User
 *   getUserByPhone()          : bỏ login_id khỏi SELECT, cập nhật constructor User
 *   getVehicleByPlate()       : SỬA BUG – thêm [type] và [is_active] vào SELECT
 *                               cập nhật constructor Vehicle (thêm isActive)
 */
public class UserDAO {

    // ── Helper: map ResultSet → User (dùng chung) ───────────
    private User mapUser(ResultSet rs, String email) throws Exception {
        int     uid      = rs.getInt("id");
        String  phone    = rs.getString("phone_number");
        String  role     = rs.getString("role");
        String  fullName = rs.getString("full_name");
        String  mail     = (email != null) ? email : rs.getString("email");
        boolean active   = rs.getBoolean("is_active");
        Date    date     = rs.getDate("created_at");
        // THAY ĐỔI: constructor mới không có loginId
        return new User(uid, phone, mail, "", role, fullName, active, date);
    }

    // ── TẠO USER MỚI ────────────────────────────────────────
    /**
     * THAY ĐỔI: xóa login_id khỏi câu INSERT.
     * Thứ tự param: phone_number, password, role, full_name, email, is_active
     */
    public int createNewUser(User u) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // THAY ĐỔI: bỏ login_id
                String sql = "INSERT INTO dbo.users(phone_number, email, password, role, full_name, is_active) "
                           + "VALUES(?,?,?,?,?,?)";
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

    // ── ĐĂNG NHẬP BẰNG EMAIL + PASSWORD ─────────────────────
    /**
     * THAY ĐỔI: bỏ login_id khỏi SELECT, cập nhật cách tạo User object.
     */
    public User getUser(String email, String password) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // THAY ĐỔI: bỏ [login_id]
                String sql = "SELECT [id],[role],[full_name],[email],[phone_number],[is_active],[created_at] "
                           + "FROM [dbo].[users] "
                           + "WHERE [email]=? AND [password]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                st.setString(2, password);
                ResultSet rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    result = mapUser(rs, email);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // ── LẤY USER THEO EMAIL (không cần password) ─────────────
    /**
     * THAY ĐỔI: bỏ login_id khỏi SELECT.
     */
    public User getUser(String email) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // THAY ĐỔI: bỏ [login_id]
                String sql = "SELECT [id],[role],[full_name],[email],[phone_number],[is_active],[created_at] "
                           + "FROM [dbo].[users] "
                           + "WHERE [email]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, email);
                ResultSet rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    result = mapUser(rs, email);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // ── ĐĂNG NHẬP BẰNG SỐ ĐIỆN THOẠI ───────────────────────
    /**
     * THAY ĐỔI: bỏ login_id khỏi SELECT, cập nhật cách tạo User object.
     * Dùng cho CUSTOMER đăng nhập bằng phone_number + password.
     */
    public User getUserByPhone(String phone, String password) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // THAY ĐỔI: bỏ [login_id], thêm AND [password]=?
                String sql = "SELECT [id],[role],[full_name],[email],[phone_number],[is_active],[created_at] "
                           + "FROM [dbo].[users] "
                           + "WHERE [phone_number]=? AND [password]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, phone);
                st.setString(2, password);
                ResultSet rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    result = mapUser(rs, null);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    /** Overload không cần password – dùng khi tra cứu nội bộ */
    public User getUserByPhone(String phone) {
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "SELECT [id],[role],[full_name],[email],[phone_number],[is_active],[created_at] "
                           + "FROM [dbo].[users] WHERE [phone_number]=?";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, phone);
                ResultSet rs = st.executeQuery();
                if (rs != null && rs.next()) {
                    result = mapUser(rs, null);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) {}
        }
        return result;
    }

    // ── LẤY XE THEO BIỂN SỐ (dùng cho LPR camera) ───────────
    /**
     * SỬA BUG + THAY ĐỔI:
     *   Bug cũ: cột [type] không có trong SELECT nhưng constructor Vehicle lại đọc type
     *           → ném SQLException lúc runtime.
     *   Fix: thêm [type] và [is_active] vào SELECT.
     *   Cập nhật: constructor Vehicle mới có thêm tham số isActive.
     *
     * Lưu ý: chỉ trả xe đang active (is_active = 1).
     */
    public Vehicle getVehicleByPlate(String plate) {
        Vehicle result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                // SỬA BUG: thêm [type], [is_active]
                String sql = "SELECT [id],[user_id],[plate],[type],[brand],[model],[color],[is_active],[created_at] "
                           + "FROM [dbo].[vehicles] "
                           + "WHERE [plate]=? AND [is_active]=1";
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
                        rs.getBoolean("is_active"),   // THÊM MỚI
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

    // ── CẬP NHẬT PROFILE ────────────────────────────────────
    /** Không thay đổi so với v1. */
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

    // ── TẠO LOYALTY ACCOUNT KHI ĐĂNG KÝ ────────────────────
    /** Không thay đổi so với v1. */
    public int createLoyaltyAccount(int userId) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if (cn != null) {
                String sql = "INSERT INTO dbo.loyalty_accounts"
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
