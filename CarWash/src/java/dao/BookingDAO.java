
package dao;


import dto.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import mylib.DBUtils;

public class BookingDAO {
    public int createBooking(Booking b){
        int rs=0;
        Connection cn = null;
        try{
            cn = DBUtils.getConnection();
            if(cn!=null){
                String sql ="insert into [dbo].[bookings]([user_id], [vehicle_id], [service_id], [scheduled_date],"
                    + " [scheduled_time], [status], [priority], [notes])"
                    + " values (?,?,?,?,?,?,?,?)";
            PreparedStatement st = cn.prepareStatement(sql);
            st.setInt(1, b.getUserId());
            st.setInt(2, b.getVehicleId());
            st.setInt(3, b.getServiceId());
            st.setDate(4, b.getScheduledDate());
            st.setTime(5, b.getScheduledTime());
            st.setString(6, "PENDING");
            st.setInt(7, b.getPriority());
            st.setString(8, b.getNotes());
           
            rs = st.executeUpdate();
            }
            
            
            
        }catch(Exception e){
            e.printStackTrace();
        } finally {
        try {
            if (cn != null) {
                cn.close();
            }
        } catch (Exception e) {
        }
    }
        return rs;
    }
    
    public Booking getBookingById(int bookingId){
        Booking b = null;
        Connection cn = null;
        try{
            cn = DBUtils.getConnection();
            if(cn!=null){
                String sql = "select *\n" +
                        "from [dbo].[bookings]\n" +
                        "where [id]=?";
            PreparedStatement st = cn.prepareStatement(sql);

            st.setInt(1, bookingId);

            ResultSet rs = st.executeQuery();
            if(rs.next()){
                b = new Booking();
                
                b.setId(rs.getInt("id"));
                b.setUserId(rs.getInt("user_id"));
                b.setVehicleId(rs.getInt("vehicle_id"));
                b.setServiceId(rs.getInt("service_id"));

                b.setScheduledDate(rs.getDate("scheduled_date"));
                b.setScheduledTime(rs.getTime("scheduled_time"));

                b.setStatus(rs.getString("status"));
                b.setPriority(rs.getInt("priority"));
                b.setNotes(rs.getString("notes"));

                b.setPrice(rs.getDouble("price"));
                b.setDiscount(rs.getDouble("discount"));
                b.setPayMethod(rs.getString("pay_method"));
                b.setPointsEarn(rs.getInt("points_earn"));

                b.setCheckinAt(rs.getTimestamp("checkin_at"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                b.setUpdatedAt(rs.getTimestamp("updated_at"));
            }

            }
            
        }catch(Exception e){
            e.printStackTrace();
            
        } finally {
        try {
            if (cn != null) {
                cn.close();
            }
        } catch (Exception e) {
        }
    }

        return b;
        
    }
    public ArrayList<Booking> getBookingsByUser(int userId) {

        ArrayList<Booking> list = new ArrayList<>();
        Connection cn = null;

        try {

            cn = DBUtils.getConnection();

            if (cn != null) {

                String sql =
                        "SELECT * FROM bookings "
                        + "WHERE user_id=? "
                        + "ORDER BY scheduled_date DESC, scheduled_time DESC";

                PreparedStatement st = cn.prepareStatement(sql);

                st.setInt(1, userId);

                ResultSet rs = st.executeQuery();

                while (rs.next()) {

                    Booking b = new Booking();

                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getInt("user_id"));
                    b.setVehicleId(rs.getInt("vehicle_id"));
                    b.setServiceId(rs.getInt("service_id"));

                    b.setScheduledDate(rs.getDate("scheduled_date"));
                    b.setScheduledTime(rs.getTime("scheduled_time"));

                    b.setStatus(rs.getString("status"));
                    b.setPriority(rs.getInt("priority"));
                    b.setNotes(rs.getString("notes"));

                    list.add(b);
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

        return list;
    }
    
    public int updateBooking(Booking b) {

        int rs = 0;

        try {

            Connection cn = DBUtils.getConnection();

            String sql =
                    "UPDATE bookings "
                    + "SET vehicle_id=?,"
                    + "service_id=?,"
                    + "scheduled_date=?,"
                    + "scheduled_time=?,"
                    + "priority=?,"
                    + "notes=?,"
                    + "updated_at=GETDATE() "
                    + "WHERE id=?";

            PreparedStatement st = cn.prepareStatement(sql);

            st.setInt(1, b.getVehicleId());
            st.setInt(2, b.getServiceId());
            st.setDate(3, b.getScheduledDate());
            st.setTime(4, b.getScheduledTime());
            st.setInt(5, b.getPriority());
            st.setString(6, b.getNotes());
            st.setInt(7, b.getId());

            rs = st.executeUpdate();

            cn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rs;
    }

    public int cancelBooking(int bookingId) {

        int rs = 0;

        try {

            Connection cn = DBUtils.getConnection();

            String sql =
                    "UPDATE bookings "
                    + "SET status='CANCEL',"
                    + "updated_at=GETDATE() "
                    + "WHERE id=?";

            PreparedStatement st = cn.prepareStatement(sql);

            st.setInt(1, bookingId);

            rs = st.executeUpdate();

            cn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rs;
    }

    public ArrayList<Booking> getWashHistory(int userId) {

        ArrayList<Booking> list = new ArrayList<>();

        try {

            Connection cn = DBUtils.getConnection();

            String sql =
                    "SELECT * FROM bookings "
                    + "WHERE user_id=? "
                    + "AND status='CHECKED_IN'";

            PreparedStatement st = cn.prepareStatement(sql);

            st.setInt(1, userId);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {

                Booking b = new Booking();

                b.setId(rs.getInt("id"));
                b.setUserId(rs.getInt("user_id"));
                b.setVehicleId(rs.getInt("vehicle_id"));
                b.setStatus(rs.getString("status"));
                b.setScheduledDate(rs.getDate("scheduled_date"));
                b.setScheduledTime(rs.getTime("scheduled_time"));
                b.setPrice(rs.getDouble("price"));
                b.setDiscount(rs.getDouble("discount"));
                b.setPayMethod(rs.getString("pay_method"));
                b.setPointsEarn(rs.getInt("points_earn"));

                list.add(b);
            }

            cn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int checkin(int bookingId,
            double price,
            double discount,
            String payMethod,
            int pointsEarn) {

        int rs = 0;

        try {

            Connection cn = DBUtils.getConnection();

            String sql =
                    "UPDATE bookings "
                    + "SET status='CHECKED_IN',"
                    + "price=?,"
                    + "discount=?,"
                    + "pay_method=?,"
                    + "points_earn=?,"
                    + "checkin_at=GETDATE(),"
                    + "updated_at=GETDATE() "
                    + "WHERE id=?";

            PreparedStatement st = cn.prepareStatement(sql);

            st.setDouble(1, price);
            st.setDouble(2, discount);
            st.setString(3, payMethod);
            st.setInt(4, pointsEarn);
            st.setInt(5, bookingId);

            rs = st.executeUpdate();

            cn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rs;
    }
}
