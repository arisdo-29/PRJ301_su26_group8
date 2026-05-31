package dbo;

import java.io.Serializable;
import java.sql.Date;

public class Vehicle implements Serializable {

    private int id;
    private int userId;

    private String licensePlate;
    private String brand;
    private String model;
    private String color;

    private Date createdAt;

    public Vehicle() {
    }

    public Vehicle(int id, int userId, String licensePlate, String brand, String model, String color, Date createdAt) {
        this.id = id;
        this.userId = userId;
        this.licensePlate = licensePlate;
        this.brand = brand;
        this.model = model;
        this.color = color;
        this.createdAt = createdAt;
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

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }


    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}