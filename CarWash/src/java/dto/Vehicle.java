package dto;

import java.io.Serializable;
import java.sql.Date;

/**
 * DTO ánh xạ bảng [dbo].[vehicles]
 *
 * Chuyển từ package dbo → dto (chuẩn hoá toàn dự án).
 * Tên biến: licensePlate → plate (khớp tên cột DB và VehicleDao)
 */
public class Vehicle implements Serializable {

    private int    id;
    private int    userId;
    private String plate;      // tên cột DB: [plate]
    private String brand;
    private String model;
    private String color;
    private Date   createdAt;

    public Vehicle() {}

    public Vehicle(int id, int userId, String plate, String brand,
                   String model, String color, Date createdAt) {
        this.id        = id;
        this.userId    = userId;
        this.plate     = plate;
        this.brand     = brand;
        this.model     = model;
        this.color     = color;
        this.createdAt = createdAt;
    }

    // ── Getters & Setters ───────────────────────────────────────

    public int    getId()               { return id; }
    public void   setId(int v)          { this.id = v; }

    public int    getUserId()           { return userId; }
    public void   setUserId(int v)      { this.userId = v; }

    public String getPlate()            { return plate; }
    public void   setPlate(String v)    { this.plate = v; }

    public String getBrand()            { return brand; }
    public void   setBrand(String v)    { this.brand = v; }

    public String getModel()            { return model; }
    public void   setModel(String v)    { this.model = v; }

    public String getColor()            { return color; }
    public void   setColor(String v)    { this.color = v; }

    public Date   getCreatedAt()        { return createdAt; }
    public void   setCreatedAt(Date v)  { this.createdAt = v; }
}
