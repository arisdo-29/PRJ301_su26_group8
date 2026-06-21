package dao;

import dto.Reward;
import mylib.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * RewardDAO – xử lý tất cả thao tác database cho bảng rewards.
 *
 * Bảng rewards lưu cả Reward và Promotion:
 *   points_cost > 0  →  Reward (khách đổi điểm lấy phần thưởng)
 *   points_cost = 0  →  Promotion (khuyến mãi admin cấu hình, áp dụng tự động)
 *
 * ĐÃ SỬA (bổ sung chức năng Sửa / Xóa cho trang quản lý):
 *   + getById(id)           : lấy 1 reward/promotion để hiển thị lên form sửa
 *   + updateReward(r)       : cập nhật reward/promotion theo id
 *   + deactivateReward(id)  : xóa MỀM (set is_active = 0), không DELETE cứng
 *                             để tránh vỡ khóa ngoại với bảng redemptions
 */
public class RewardDAO {

    // ─── HELPER: map 1 hàng ResultSet → đối tượng Reward ─────────────
    private Reward mapRow(ResultSet rs) throws Exception {
        Reward r = new Reward();
        r.setId(rs.getInt("id"));
        r.setName(rs.getString("name"));
        r.setDescription(rs.getString("description"));
        r.setType(rs.getString("type"));
        r.setPointsCost(rs.getInt("points_cost"));
        r.setValue(rs.getDouble("value"));

        // min_tier_id có thể NULL → dùng wasNull() để kiểm tra
        int mid = rs.getInt("min_tier_id");
        r.setMinTierId(rs.wasNull() ? null : mid);

        // Dùng tên cột mới: start_date / end_date (đã đổi tên từ valid_from / valid_to)
        r.setStartDate(rs.getDate("start_date"));
        r.setEndDate(rs.getDate("end_date"));
        r.setActive(rs.getBoolean("is_active"));
        return r;
    }

    // ─── LẤY DANH SÁCH REWARD (points_cost > 0) ──────────────────────
    public List<Reward> getAllRewards() {
        List<Reward> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT id, name, description, type, points_cost, value, "
                       + "min_tier_id, start_date, end_date, is_active "
                       + "FROM rewards WHERE points_cost > 0 ORDER BY id DESC";
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return list;
    }

    // ─── LẤY DANH SÁCH PROMOTION (points_cost = 0) ───────────────────
    public List<Reward> getAllPromotions() {
        List<Reward> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT id, name, description, type, points_cost, value, "
                       + "min_tier_id, start_date, end_date, is_active "
                       + "FROM rewards WHERE points_cost = 0 ORDER BY id DESC";
            PreparedStatement st = cn.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return list;
    }

    // ─── LẤY 1 REWARD/PROMOTION THEO ID (dùng cho trang Sửa) ─────────
    // GHI CHÚ (MỚI THÊM): phục vụ editReward.jsp - cần load dữ liệu cũ lên form
    public Reward getById(int id) {
        Reward r = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT id, name, description, type, points_cost, value, "
                       + "min_tier_id, start_date, end_date, is_active "
                       + "FROM rewards WHERE id = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                r = mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return r;
    }

    // ─── CẬP NHẬT REWARD/PROMOTION (dùng cho trang Sửa) ──────────────
    // GHI CHÚ (MỚI THÊM): UPDATE toàn bộ field theo id, dùng chung cho cả Reward và Promotion
    // (vì cùng nằm trong bảng rewards, chỉ khác points_cost)
    public int updateReward(Reward r) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE rewards SET "
                       + "name = ?, description = ?, type = ?, points_cost = ?, value = ?, "
                       + "min_tier_id = ?, start_date = ?, end_date = ?, is_active = ? "
                       + "WHERE id = ?";
            PreparedStatement st = cn.prepareStatement(sql);

            st.setString(1, r.getName());
            st.setString(2, r.getDescription());
            st.setString(3, r.getType());
            st.setInt(4, r.getPointsCost());

            if (r.getValue() > 0) {
                st.setDouble(5, r.getValue());
            } else {
                st.setNull(5, Types.DECIMAL);
            }

            if (r.getMinTierId() != null) {
                st.setInt(6, r.getMinTierId());
            } else {
                st.setNull(6, Types.INTEGER);
            }

            if (r.getStartDate() != null) {
                st.setDate(7, r.getStartDate());
            } else {
                st.setNull(7, Types.DATE);
            }
            if (r.getEndDate() != null) {
                st.setDate(8, r.getEndDate());
            } else {
                st.setNull(8, Types.DATE);
            }

            st.setBoolean(9, r.isActive());
            st.setInt(10, r.getId());

            result = st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return result;
    }

    // ─── XÓA MỀM REWARD/PROMOTION (dùng cho nút Xóa) ─────────────────
    // GHI CHÚ (MỚI THÊM): KHÔNG xóa cứng (DELETE) vì bảng redemptions có thể
    // đang tham chiếu reward_id này (khách đã đổi thưởng trước đó).
    // Thay vào đó set is_active = 0 để ẩn khỏi danh sách hiển thị nhưng
    // vẫn giữ nguyên dữ liệu lịch sử (không vi phạm khóa ngoại, không mất log).
    public int deactivateReward(int id) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "UPDATE rewards SET is_active = 0 WHERE id = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, id);
            result = st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return result;
    }

    // ─── THÊM MỚI REWARD HOẶC PROMOTION ─────────────────────────────
    /**
     * Dùng cho cả addReward và addPromotion:
     *   - Reward:    r.getPointsCost() > 0
     *   - Promotion: r.getPointsCost() = 0
     *
     * @return số hàng được insert (1 = thành công, 0 = thất bại)
     */
    public int addReward(Reward r) {
        int result = 0;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "INSERT INTO rewards "
                       + "(name, description, type, points_cost, value, min_tier_id, start_date, end_date, is_active) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement st = cn.prepareStatement(sql);

            st.setString(1, r.getName());
            st.setString(2, r.getDescription());   // có thể null
            st.setString(3, r.getType());
            st.setInt(4, r.getPointsCost());        // 0 = promotion, > 0 = reward

            // value: NULL nếu loại là FREE_WASH hoặc FREE_UPGRADE
            if (r.getValue() > 0) {
                st.setDouble(5, r.getValue());
            } else {
                st.setNull(5, Types.DECIMAL);
            }

            // min_tier_id: NULL = áp dụng cho tất cả hạng
            if (r.getMinTierId() != null) {
                st.setInt(6, r.getMinTierId());
            } else {
                st.setNull(6, Types.INTEGER);
            }

            // start_date / end_date: NULL nếu người dùng không chọn
            if (r.getStartDate() != null) {
                st.setDate(7, r.getStartDate());
            } else {
                st.setNull(7, Types.DATE);
            }
            if (r.getEndDate() != null) {
                st.setDate(8, r.getEndDate());
            } else {
                st.setNull(8, Types.DATE);
            }

            st.setBoolean(9, r.isActive());
            result = st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return result;
    }
}
