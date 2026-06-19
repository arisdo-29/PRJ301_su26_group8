package dto;

import java.sql.Date;
import java.sql.Timestamp;


public class PointLog {
    private int       id;
    private int       accountId;
    private Integer   bookingId;   // nullable
    private String    type;
    private int       amount;
    private int       balance;
    private String    note;
    private Date      expiresAt;
    private Timestamp createdAt;

    public PointLog() {}

    //  Getters & Setters 
    public int       getId()                   { return id; }
    public void      setId(int v)              { this.id = v; }
    public int       getAccountId()            { return accountId; }
    public void      setAccountId(int v)       { this.accountId = v; }
    public Integer   getBookingId()            { return bookingId; }
    public void      setBookingId(Integer v)   { this.bookingId = v; }
    public String    getType()                 { return type; }
    public void      setType(String v)         { this.type = v; }
    public int       getAmount()               { return amount; }
    public void      setAmount(int v)          { this.amount = v; }
    public int       getBalance()              { return balance; }
    public void      setBalance(int v)         { this.balance = v; }
    public String    getNote()                 { return note; }
    public void      setNote(String v)         { this.note = v; }
    public Date      getExpiresAt()            { return expiresAt; }
    public void      setExpiresAt(Date v)      { this.expiresAt = v; }
    public Timestamp getCreatedAt()            { return createdAt; }
    public void      setCreatedAt(Timestamp v) { this.createdAt = v; }
}
