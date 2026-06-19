package dto;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/**
 * DTO cho bảng bookings (v2).
 *
 * MỚI HOÀN TOÀN – bảng bookings giờ gộp luôn thông tin thanh toán
 * (trước đây nằm ở bảng wash_sessions đã bị xóa).
 *
 * Trạng thái (status):
 *   PENDING  – đã đặt lịch, chưa đến
 *   CANCEL   – hủy (lưu lại, không xóa)
 *   CHECKIN  – đã đến rửa xe (điền price, payMethod, pointsEarn, checkinAt)
 *
 * Tier-based booking window (xử lý ở Servlet/Service):
 *   scheduledDate phải <= GETDATE() + tiers.book_days tương ứng
 */
public class Booking {

    private int        id;
    private int        userId;
    private int        vehicleId;
    private int        serviceId;
    private Date       scheduledDate;
    private Time       scheduledTime;
    private String     status;        // PENDING | CANCEL | CHECKIN
    private int        priority;      // copy từ tiers.priority lúc đặt lịch
    private String     notes;

    // Thông tin thanh toán – điền khi status = CHECKIN
    private BigDecimal price;
    private BigDecimal discount;
    private String     payMethod;     // CASH | MOMO | CARD | BANK
    private int        pointsEarn;
    private Timestamp  checkinAt;

    private Timestamp  createdAt;
    private Timestamp  updatedAt;

    // JOIN fields (tiện dùng trên UI – không phải cột trong bookings)
    private String  vehiclePlate;
    private String  serviceName;
    private String  userFullName;

    public Booking() {}

    // ── Getters & Setters ────────────────────────────────────

    public int        getId()                       { return id; }
    public void       setId(int v)                  { this.id = v; }

    public int        getUserId()                   { return userId; }
    public void       setUserId(int v)              { this.userId = v; }

    public int        getVehicleId()                { return vehicleId; }
    public void       setVehicleId(int v)           { this.vehicleId = v; }

    public int        getServiceId()                { return serviceId; }
    public void       setServiceId(int v)           { this.serviceId = v; }

    public Date       getScheduledDate()            { return scheduledDate; }
    public void       setScheduledDate(Date v)      { this.scheduledDate = v; }

    public Time       getScheduledTime()            { return scheduledTime; }
    public void       setScheduledTime(Time v)      { this.scheduledTime = v; }

    public String     getStatus()                   { return status; }
    public void       setStatus(String v)           { this.status = v; }

    public int        getPriority()                 { return priority; }
    public void       setPriority(int v)            { this.priority = v; }

    public String     getNotes()                    { return notes; }
    public void       setNotes(String v)            { this.notes = v; }

    public BigDecimal getPrice()                    { return price; }
    public void       setPrice(BigDecimal v)        { this.price = v; }

    public BigDecimal getDiscount()                 { return discount; }
    public void       setDiscount(BigDecimal v)     { this.discount = v; }

    public String     getPayMethod()                { return payMethod; }
    public void       setPayMethod(String v)        { this.payMethod = v; }

    public int        getPointsEarn()               { return pointsEarn; }
    public void       setPointsEarn(int v)          { this.pointsEarn = v; }

    public Timestamp  getCheckinAt()                { return checkinAt; }
    public void       setCheckinAt(Timestamp v)     { this.checkinAt = v; }

    public Timestamp  getCreatedAt()                { return createdAt; }
    public void       setCreatedAt(Timestamp v)     { this.createdAt = v; }

    public Timestamp  getUpdatedAt()                { return updatedAt; }
    public void       setUpdatedAt(Timestamp v)     { this.updatedAt = v; }

    // JOIN fields
    public String     getVehiclePlate()             { return vehiclePlate; }
    public void       setVehiclePlate(String v)     { this.vehiclePlate = v; }

    public String     getServiceName()              { return serviceName; }
    public void       setServiceName(String v)      { this.serviceName = v; }

    public String     getUserFullName()             { return userFullName; }
    public void       setUserFullName(String v)     { this.userFullName = v; }

    /** Tiện ích: kiểm tra booking đã thanh toán chưa */
    public boolean isCheckedIn()  { return "CHECKIN".equals(status); }
    public boolean isCancelled()  { return "CANCEL".equals(status); }
    public boolean isPending()    { return "PENDING".equals(status); }
}
