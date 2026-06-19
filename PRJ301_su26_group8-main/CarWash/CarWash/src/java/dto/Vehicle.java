package dto;

import java.io.Serializable;
import java.sql.Date;


public class Vehicle implements Serializable {

    private int    id;
    private int    userId;
    private String plate;      // tên cột DB: [plate]
    private String type;
    private String brand;
    private String model;
    private String color;
    private Date   createdAt;

    public Vehicle() {}

    public Vehicle(int id, int userId, String plate, String type, String brand, String model, String color, Date createdAt) {
        this.id = id;
        this.userId = userId;
        this.plate = plate;
        this.type = type;
        this.brand = brand;
        this.model = model;
        this.color = color;
        this.createdAt = createdAt;
    }

    

    //  Getters & Setters 

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

    public String getPlate() {
        return plate;
    }

    public void setPlate(String plate) {
        this.plate = plate;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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
