package dto;

import java.io.Serializable;
import java.sql.Date;

/**
 * DTO cho bảng vehicles.
 *
 * ĐÃ SỬA: thêm trường isActive (cột is_active) để hỗ trợ soft delete.
 * Constructor cũ (8 tham số, không có isActive) đã được thay bằng
 * constructor mới (9 tham số, có isActive).
 * VehicleDao và UserDAO đều đã cập nhật để dùng constructor mới.
 */
public class Vehicle implements Serializable {

    private int     id;
    private int     userId;
    private String  plate;
    private String  type;       // Sedan | SUV | Truck | ...
    private String  brand;
    private String  model;
    private String  color;
    private boolean isActive;   // THÊM MỚI – false = xe đã bị "xóa mềm"
    private Date    createdAt;

    public Vehicle() {}

    // ĐÃ SỬA: thêm tham số isActive
    public Vehicle(int id, int userId, String plate, String type,
                   String brand, String model, String color,
                   boolean isActive, Date createdAt) {
        this.id        = id;
        this.userId    = userId;
        this.plate     = plate;
        this.type      = type;
        this.brand     = brand;
        this.model     = model;
        this.color     = color;
        this.isActive  = isActive;
        this.createdAt = createdAt;
    }

    // ── Getters & Setters ────────────────────────────────────────────
    public int     getId()                       { return id; }
    public void    setId(int id)                 { this.id = id; }

    public int     getUserId()                   { return userId; }
    public void    setUserId(int userId)         { this.userId = userId; }

    public String  getPlate()                    { return plate; }
    public void    setPlate(String plate)        { this.plate = plate; }

    public String  getType()                     { return type; }
    public void    setType(String type)          { this.type = type; }

    public String  getBrand()                    { return brand; }
    public void    setBrand(String brand)        { this.brand = brand; }

    public String  getModel()                    { return model; }
    public void    setModel(String model)        { this.model = model; }

    public String  getColor()                    { return color; }
    public void    setColor(String color)        { this.color = color; }

    // THÊM MỚI
    public boolean isActive()                    { return isActive; }
    public void    setActive(boolean isActive)   { this.isActive = isActive; }

    public Date    getCreatedAt()                { return createdAt; }
    public void    setCreatedAt(Date createdAt)  { this.createdAt = createdAt; }
}
