package dto;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class Booking {

    private int id;
    private int userId;
    private int vehicleId;
    private int serviceId;

    private Date scheduledDate;
    private Time scheduledTime;

    private String status;
    private int priority;
    private String notes;

    private double price;
    private double discount;
    private String payMethod;
    private int pointsEarn;

    private Timestamp checkinAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Booking() {
    }

    public Booking(int id, int userId, int vehicleId, int serviceId,
                   Date scheduledDate, Time scheduledTime,
                   String status, int priority, String notes,
                   double price, double discount,
                   String payMethod, int pointsEarn,
                   Timestamp checkinAt,
                   Timestamp createdAt,
                   Timestamp updatedAt) {

        this.id = id;
        this.userId = userId;
        this.vehicleId = vehicleId;
        this.serviceId = serviceId;
        this.scheduledDate = scheduledDate;
        this.scheduledTime = scheduledTime;
        this.status = status;
        this.priority = priority;
        this.notes = notes;
        this.price = price;
        this.discount = discount;
        this.payMethod = payMethod;
        this.pointsEarn = pointsEarn;
        this.checkinAt = checkinAt;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public Date getScheduledDate() {
        return scheduledDate;
    }

    public void setScheduledDate(Date scheduledDate) {
        this.scheduledDate = scheduledDate;
    }

    public Time getScheduledTime() {
        return scheduledTime;
    }

    public void setScheduledTime(Time scheduledTime) {
        this.scheduledTime = scheduledTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getPriority() {
        return priority;
    }

    public void setPriority(int priority) {
        this.priority = priority;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getDiscount() {
        return discount;
    }

    public void setDiscount(double discount) {
        this.discount = discount;
    }

    public String getPayMethod() {
        return payMethod;
    }

    public void setPayMethod(String payMethod) {
        this.payMethod = payMethod;
    }

    public int getPointsEarn() {
        return pointsEarn;
    }

    public void setPointsEarn(int pointsEarn) {
        this.pointsEarn = pointsEarn;
    }

    public Timestamp getCheckinAt() {
        return checkinAt;
    }

    public void setCheckinAt(Timestamp checkinAt) {
        this.checkinAt = checkinAt;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

}