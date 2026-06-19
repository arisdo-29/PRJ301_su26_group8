package dto;

import java.io.Serializable;
import java.sql.Date;

/**
 * DTO cho bảng vehicles.
 *
 * THAY ĐỔI so với v1:
 *   + Thêm trường isActive (cột is_active trong DB)
 *     → khi "xóa xe", chỉ set isActive = false thay vì DELETE
 *   + type vẫn giữ nguyên (Sedan / SUV / Truck …)
 *     Không còn giá trị 'Motorbike' vì hệ thống chỉ phục vụ ô tô.
 */
public class Vehicle implements Serializable {

    private int     id;
    private int     userId;
    private String  plate;
    private String  type;       // Sedan | SUV | Truck | ...
    private String  brand;
    private String  model;
    private String  color;
    private boolean isActive;   // THÊM MỚI – false = xe đã bị "xóa" (soft delete)
    private Date    createdAt;

    public Vehicle() {}

    // Constructor đầy đủ (dùng trong DAO)
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

    // ── Getters & Setters ────────────────────────────────────

    public int getId()                  { return id; }
    public void setId(int id)           { this.id = id; }

    public int getUserId()              { return userId; }
    public void setUserId(int userId)   { this.userId = userId; }

    public String getPlate()            { return plate; }
    public void setPlate(String plate)  { this.plate = plate; }

    public String getType()             { return type; }
    public void setType(String type)    { this.type = type; }

    public String getBrand()            { return brand; }
    public void setBrand(String brand)  { this.brand = brand; }

    public String getModel()            { return model; }
    public void setModel(String model)  { this.model = model; }

    public String getColor()            { return color; }
    public void setColor(String color)  { this.color = color; }

    // THÊM MỚI
    public boolean isActive()               { return isActive; }
    public void setActive(boolean isActive) { this.isActive = isActive; }

    public Date getCreatedAt()              { return createdAt; }
    public void setCreatedAt(Date createdAt){ this.createdAt = createdAt; }
}
