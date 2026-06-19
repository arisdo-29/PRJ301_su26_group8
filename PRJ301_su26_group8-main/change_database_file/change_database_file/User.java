package dto;

import java.sql.Date;

/**
 * DTO cho bảng users.
 *
 * THAY ĐỔI so với v1:
 *   - XÓA trường loginId (cột login_id đã bị xóa khỏi DB)
 *   - Đăng nhập giờ dùng email hoặc phoneNumber trực tiếp
 *   - Đổi tên trường phoneName → phoneNumber cho rõ nghĩa
 *     (getPhoneName() giữ lại để tương thích ngược nếu JSP cũ dùng)
 */
public class User {

    private int     id;
    private String  phoneNumber;  // maps to DB: phone_number (đổi tên từ phoneName)
    private String  email;
    private String  password;
    private String  role;
    private String  fullName;
    private boolean isActive;
    private Date    createAt;

    // ── Constructors ─────────────────────────────────────────

    public User() {}

    /** Constructor đầy đủ – dùng trong DAO khi query ra từ DB */
    public User(int id, String phoneNumber, String email,
                String password, String role, String fullName,
                boolean isActive, Date createAt) {
        this.id          = id;
        this.phoneNumber = phoneNumber;
        this.email       = email;
        this.password    = password;
        this.role        = role;
        this.fullName    = fullName;
        this.isActive    = isActive;
        this.createAt    = createAt;
    }

    /** Constructor dùng khi tạo user mới (chưa có id và createAt) */
    public User(String phoneNumber, String email, String password,
                String role, String fullName) {
        this.phoneNumber = phoneNumber;
        this.email       = email;
        this.password    = password;
        this.role        = role;
        this.fullName    = fullName;
        this.isActive    = true;
    }

    // ── Getters & Setters ────────────────────────────────────

    public int getId()              { return id; }
    public void setId(int id)       { this.id = id; }

    public String getPhoneNumber()              { return phoneNumber; }
    public void   setPhoneNumber(String phone)  { this.phoneNumber = phone; }
    /** Alias giữ tương thích với code cũ dùng getPhoneName() */
    public String getPhoneName()               { return phoneNumber; }
    public void   setPhoneName(String phone)   { this.phoneNumber = phone; }

    public String getEmail()                { return email; }
    public void   setEmail(String email)    { this.email = email; }

    public String getPassword()                 { return password; }
    public void   setPassword(String password)  { this.password = password; }

    public String getRole()             { return role; }
    public void   setRole(String role)  { this.role = role; }

    public String getFullName()                 { return fullName; }
    public void   setFullName(String fullName)  { this.fullName = fullName; }
    /** Alias: một số JSP cũ gọi getFull_name() */
    public String getFull_name()               { return fullName; }

    public boolean isIsActive()                     { return isActive; }
    public void    setIsActive(boolean isActive)    { this.isActive = isActive; }

    public Date getCreateAt()               { return createAt; }
    public void setCreateAt(Date createAt)  { this.createAt = createAt; }
}
