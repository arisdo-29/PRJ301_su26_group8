package dto;

import java.sql.Date;

/**
 * DTO cho bảng rewards (đã gộp promotions vào đây).
 *
 * THAY ĐỔI so với v1:
 *   + Thêm trường description
 *   - Đổi tên validFrom → startDate  (DB cột: start_date)
 *   - Đổi tên validTo   → endDate    (DB cột: end_date)
 *
 * Phân biệt loại reward:
 *   pointsCost > 0  → phần thưởng đổi điểm (customer tự đổi)
 *   pointsCost = 0  → khuyến mãi của admin (hiển thị nhưng không cần đổi điểm)
 */
public class Reward {

    private int     id;
    private String  name;
    private String  description;  // THÊM MỚI
    private String  type;         // FREE_WASH | DISC_PERCENT | DISC_VND | FREE_UPGRADE
    private int     pointsCost;   // 0 = khuyến mãi, > 0 = đổi điểm
    private double  value;
    private Integer minTierId;
    private Date    startDate;    // ĐỔI TÊN từ validFrom (DB: start_date)
    private Date    endDate;      // ĐỔI TÊN từ validTo   (DB: end_date)
    private boolean isActive;

    public Reward() {}

    // ── Getters & Setters ────────────────────────────────────

    public int     getId()                  { return id; }
    public void    setId(int v)             { this.id = v; }

    public String  getName()               { return name; }
    public void    setName(String v)       { this.name = v; }

    public String  getDescription()              { return description; }
    public void    setDescription(String v)      { this.description = v; }

    public String  getType()               { return type; }
    public void    setType(String v)       { this.type = v; }

    public int     getPointsCost()         { return pointsCost; }
    public void    setPointsCost(int v)    { this.pointsCost = v; }

    public double  getValue()              { return value; }
    public void    setValue(double v)      { this.value = v; }

    public Integer getMinTierId()          { return minTierId; }
    public void    setMinTierId(Integer v) { this.minTierId = v; }

    /** Ngày bắt đầu hiệu lực (DB cột: start_date) */
    public Date    getStartDate()          { return startDate; }
    public void    setStartDate(Date v)    { this.startDate = v; }

    /** Ngày hết hạn (DB cột: end_date) */
    public Date    getEndDate()            { return endDate; }
    public void    setEndDate(Date v)      { this.endDate = v; }

    public boolean isActive()              { return isActive; }
    public void    setActive(boolean v)    { this.isActive = v; }

    /** Tiện ích: true nếu reward này là khuyến mãi admin (không cần điểm) */
    public boolean isPromotion()           { return pointsCost == 0; }
}
