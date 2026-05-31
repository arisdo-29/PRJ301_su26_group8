package dto;

import java.sql.Date;

/**
 * DTO ánh xạ bảng rewards
 * type: FREE_WASH | DISC_PERCENT | DISC_VND | FREE_UPGRADE
 */
public class Reward {
    private int    id;
    private String name;
    private String type;
    private int    pointsCost;
    private double value;
    private Integer minTierId;
    private Date   validFrom;
    private Date   validTo;
    private boolean isActive;

    public Reward() {}

    // ── Getters & Setters ───────────────────────────────────────
    public int     getId()                  { return id; }
    public void    setId(int v)             { this.id = v; }
    public String  getName()               { return name; }
    public void    setName(String v)       { this.name = v; }
    public String  getType()               { return type; }
    public void    setType(String v)       { this.type = v; }
    public int     getPointsCost()         { return pointsCost; }
    public void    setPointsCost(int v)    { this.pointsCost = v; }
    public double  getValue()              { return value; }
    public void    setValue(double v)      { this.value = v; }
    public Integer getMinTierId()          { return minTierId; }
    public void    setMinTierId(Integer v) { this.minTierId = v; }
    public Date    getValidFrom()          { return validFrom; }
    public void    setValidFrom(Date v)    { this.validFrom = v; }
    public Date    getValidTo()            { return validTo; }
    public void    setValidTo(Date v)      { this.validTo = v; }
    public boolean isActive()              { return isActive; }
    public void    setActive(boolean v)    { this.isActive = v; }
}
