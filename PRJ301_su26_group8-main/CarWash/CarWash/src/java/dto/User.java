
package dto;

import java.sql.Date;


public class User {
    private int id;
    //private String loginId;
    private String phoneName;
    private String email;
    private String password;
    private String role;
    private String fullName;    
    private boolean isActive;
    private Date createAt;
    
    // ctors

    public User() {
    }

    public User(int id, String phoneName, String email, String password, String role, String fullName, boolean isActive, Date createAt) {
        this.id = id;
        this.phoneName = phoneName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.fullName = fullName;
        this.isActive = isActive;
        this.createAt = createAt;
    }

    

    
    // get & setter

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getFullName() {
        return fullName;
    }

    public String getFull_name() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneName() {
        return phoneName;
    }

    public void setPhoneName(String phoneName) {
        this.phoneName = phoneName;
    }

    // Backwards-compatible accessors
    public String getPhoneNumber() {
        return this.phoneName;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneName = phoneNumber;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }
    

    
    
}
