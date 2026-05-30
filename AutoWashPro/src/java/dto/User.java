
package dto;

import java.sql.Date;



public class User {
    private int userID;
    private String fullname;
//    private String login_id; //phone or username -> phat trien them
    private String password;
//    private String role;
    private String email;
    private boolean isActive;
    private Date createAt;

    public User() {
    }

    public User(int userID, String fullname, String password, String email, boolean isActive, Date createAt) {
        this.userID = userID;
        this.fullname = fullname;
        this.password = password;
        this.email = email;
        this.isActive = isActive;
        this.createAt = createAt;
    }

    public User(String fullname, String password, String email, boolean isActive, Date createAt) {
        this.fullname = fullname;
        this.password = password;
        this.email = email;
        this.isActive = isActive;
        this.createAt = createAt;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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
