package dto;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * DTO ánh xạ bảng loyalty_accounts
 */
public class LoyaltyAccount {
    private int       id;
    private int       userId;
    private int       tierId;
    private String    tierName;   // JOIN từ tiers (tiện dùng trên UI)
    private int       points;
    private int       totalPoints;
    private long      totalSpend;
    private int       totalWashes;
    private Date      tierSince;
    private Date      nextReview;
    private boolean   freeWashUsed;
    private boolean   freeUpgUsed;
    private Timestamp updatedAt;

    public LoyaltyAccount() {}

    // ── Getters & Setters ───────────────────────────────────────
    public int       getId()                    { return id; }
    public void      setId(int v)               { this.id = v; }
    public int       getUserId()                { return userId; }
    public void      setUserId(int v)           { this.userId = v; }
    public int       getTierId()                { return tierId; }
    public void      setTierId(int v)           { this.tierId = v; }
    public String    getTierName()              { return tierName; }
    public void      setTierName(String v)      { this.tierName = v; }
    public int       getPoints()                { return points; }
    public void      setPoints(int v)           { this.points = v; }
    public int       getTotalPoints()           { return totalPoints; }
    public void      setTotalPoints(int v)      { this.totalPoints = v; }
    public long      getTotalSpend()            { return totalSpend; }
    public void      setTotalSpend(long v)      { this.totalSpend = v; }
    public int       getTotalWashes()           { return totalWashes; }
    public void      setTotalWashes(int v)      { this.totalWashes = v; }
    public Date      getTierSince()             { return tierSince; }
    public void      setTierSince(Date v)       { this.tierSince = v; }
    public Date      getNextReview()            { return nextReview; }
    public void      setNextReview(Date v)      { this.nextReview = v; }
    public boolean   isFreeWashUsed()          { return freeWashUsed; }
    public void      setFreeWashUsed(boolean v){ this.freeWashUsed = v; }
    public boolean   isFreeUpgUsed()           { return freeUpgUsed; }
    public void      setFreeUpgUsed(boolean v) { this.freeUpgUsed = v; }
    public Timestamp getUpdatedAt()             { return updatedAt; }
    public void      setUpdatedAt(Timestamp v)  { this.updatedAt = v; }
}
