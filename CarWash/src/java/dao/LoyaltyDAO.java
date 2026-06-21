package dao;

import dto.LoyaltyAccount;
import dto.PointLog;
import dto.Reward;
import mylib.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * LoyaltyDAO – DAO cho loyalty_accounts, point_logs, rewards, redemptions.
 *
 * ĐÃ SỬA (để khớp với schema v2 và Reward.java mới):
 *   - Tên cột SQL: valid_from → start_date, valid_to → end_date
 *   - Method call: setValidFrom() → setStartDate(), setValidTo() → setEndDate()
 *   - Thêm đọc cột description từ rewards
 *   - Thêm lọc points_cost > 0 trong getActiveRewards()
 */
public class LoyaltyDAO {

    // ── GET LOYALTY ACCOUNT BY USER_ID ──────────────────────────────
    public LoyaltyAccount getByUserId(int userId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT la.id, la.user_id, la.tier_id, t.name AS tier_name, "
                       + "la.points, la.total_points, la.total_spend, la.total_washes, "
                       + "la.tier_since, la.next_review, la.free_wash_used, la.free_upg_used, la.updated_at "
                       + "FROM loyalty_accounts la "
                       + "JOIN tiers t ON la.tier_id = t.id "
                       + "WHERE la.user_id = ?";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                LoyaltyAccount la = new LoyaltyAccount();
                la.setId(rs.getInt("id"));
                la.setUserId(rs.getInt("user_id"));
                la.setTierId(rs.getInt("tier_id"));
                la.setTierName(rs.getString("tier_name"));
                la.setPoints(rs.getInt("points"));
                la.setTotalPoints(rs.getInt("total_points"));
                la.setTotalSpend(rs.getLong("total_spend"));
                la.setTotalWashes(rs.getInt("total_washes"));
                la.setTierSince(rs.getDate("tier_since"));
                la.setNextReview(rs.getDate("next_review"));
                la.setFreeWashUsed(rs.getBoolean("free_wash_used"));
                la.setFreeUpgUsed(rs.getBoolean("free_upg_used"));
                la.setUpdatedAt(rs.getTimestamp("updated_at"));
                return la;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return null;
    }

    // ── GET LAST N POINT LOGS ────────────────────────────────────────
    public List<PointLog> getRecentLogs(int accountId, int limit) {
        List<PointLog> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            String sql = "SELECT TOP (?) id, account_id, booking_id, type, amount, balance, "
                       + "note, expires_at, created_at "
                       + "FROM point_logs WHERE account_id = ? ORDER BY created_at DESC";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, limit);
            st.setInt(2, accountId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                PointLog log = new PointLog();
                log.setId(rs.getInt("id"));
                log.setAccountId(rs.getInt("account_id"));
                int bid = rs.getInt("booking_id");
                log.setBookingId(rs.wasNull() ? null : bid);
                log.setType(rs.getString("type"));
                log.setAmount(rs.getInt("amount"));
                log.setBalance(rs.getInt("balance"));
                log.setNote(rs.getString("note"));
                log.setExpiresAt(rs.getDate("expires_at"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(log);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return list;
    }

    // ── GET ACTIVE REWARDS (chỉ loại đổi điểm, points_cost > 0) ────
    public List<Reward> getActiveRewards(int userTierId) {
        List<Reward> list = new ArrayList<>();
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            // ĐÃ SỬA: valid_from → start_date | valid_to → end_date
            // THÊM: points_cost > 0 (không lấy Promotion) | đọc thêm description
            String sql = "SELECT id, name, description, type, points_cost, value, min_tier_id, "
                       + "       start_date, end_date, is_active "
                       + "FROM rewards "
                       + "WHERE is_active = 1 "
                       + "AND points_cost > 0 "
                       + "AND (start_date IS NULL OR start_date <= CAST(GETDATE() AS DATE)) "
                       + "AND (end_date   IS NULL OR end_date   >= CAST(GETDATE() AS DATE)) "
                       + "AND (min_tier_id IS NULL OR min_tier_id <= ?) "
                       + "ORDER BY points_cost ASC";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, userTierId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Reward r = new Reward();
                r.setId(rs.getInt("id"));
                r.setName(rs.getString("name"));
                r.setDescription(rs.getString("description"));
                r.setType(rs.getString("type"));
                r.setPointsCost(rs.getInt("points_cost"));
                r.setValue(rs.getDouble("value"));
                int mid = rs.getInt("min_tier_id");
                r.setMinTierId(rs.wasNull() ? null : mid);
                r.setStartDate(rs.getDate("start_date"));   // ĐÃ SỬA
                r.setEndDate(rs.getDate("end_date"));       // ĐÃ SỬA
                r.setActive(rs.getBoolean("is_active"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return list;
    }

    // ── REDEEM REWARD ────────────────────────────────────────────────
    public String redeem(int accountId, int rewardId, int userTierId) {
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            cn.setAutoCommit(false);

            // 1. Lấy thông tin reward – ĐÃ SỬA tên cột
            PreparedStatement stReward = cn.prepareStatement(
                "SELECT points_cost, min_tier_id, is_active, start_date, end_date FROM rewards WHERE id=?");
            stReward.setInt(1, rewardId);
            ResultSet rsR = stReward.executeQuery();
            if (!rsR.next()) { cn.rollback(); return "Phần thưởng không tồn tại."; }

            int  pointsCost        = rsR.getInt("points_cost");
            int  minTierId         = rsR.getInt("min_tier_id");
            boolean minTierIsNull  = rsR.wasNull();
            boolean isActive       = rsR.getBoolean("is_active");
            java.sql.Date startDate = rsR.getDate("start_date");  // ĐÃ SỬA
            java.sql.Date endDate   = rsR.getDate("end_date");    // ĐÃ SỬA
            stReward.close();

            java.sql.Date today = new java.sql.Date(System.currentTimeMillis());

            if (!isActive)                                   { cn.rollback(); return "Phần thưởng đã hết hiệu lực."; }
            if (pointsCost == 0)                             { cn.rollback(); return "Đây là khuyến mãi, không thể đổi điểm."; }
            if (startDate != null && startDate.after(today)) { cn.rollback(); return "Chương trình chưa bắt đầu."; }
            if (endDate   != null && endDate.before(today))  { cn.rollback(); return "Phần thưởng đã hết hạn."; }
            if (!minTierIsNull && userTierId < minTierId)    { cn.rollback(); return "Bậc thành viên chưa đủ điều kiện."; }

            // 2. Lấy điểm hiện tại
            PreparedStatement stAcc = cn.prepareStatement(
                "SELECT points FROM loyalty_accounts WHERE id=?");
            stAcc.setInt(1, accountId);
            ResultSet rsA = stAcc.executeQuery();
            if (!rsA.next()) { cn.rollback(); return "Không tìm thấy tài khoản điểm."; }
            int currentPoints = rsA.getInt("points");
            stAcc.close();

            if (currentPoints < pointsCost) {
                cn.rollback();
                return "Điểm không đủ. Bạn có " + currentPoints + " điểm, cần " + pointsCost + " điểm.";
            }
            int newBalance = currentPoints - pointsCost;

            // 3. INSERT redemptions
            PreparedStatement stRed = cn.prepareStatement(
                "INSERT INTO redemptions (account_id, reward_id, booking_id, points_spent, status, expires_at) "
              + "VALUES (?, ?, NULL, ?, 'PENDING', DATEADD(day, 30, CAST(GETDATE() AS DATE)))");
            stRed.setInt(1, accountId); stRed.setInt(2, rewardId); stRed.setInt(3, pointsCost);
            stRed.executeUpdate(); stRed.close();

            // 4. UPDATE loyalty_accounts.points
            PreparedStatement stUpd = cn.prepareStatement(
                "UPDATE loyalty_accounts SET points=?, updated_at=GETDATE() WHERE id=?");
            stUpd.setInt(1, newBalance); stUpd.setInt(2, accountId);
            stUpd.executeUpdate(); stUpd.close();

            // 5. INSERT point_logs
            PreparedStatement stLog = cn.prepareStatement(
                "INSERT INTO point_logs (account_id, type, amount, balance, note) VALUES (?, 'REDEEM', ?, ?, ?)");
            stLog.setInt(1, accountId); stLog.setInt(2, -pointsCost);
            stLog.setInt(3, newBalance); stLog.setString(4, "Đổi thưởng reward #" + rewardId);
            stLog.executeUpdate(); stLog.close();

            cn.commit();
            return "OK";

        } catch (Exception e) {
            e.printStackTrace();
            if (cn != null) try { cn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            return "Lỗi hệ thống, vui lòng thử lại.";
        } finally {
            try { if (cn != null) cn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
