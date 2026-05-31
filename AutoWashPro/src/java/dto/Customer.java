        package dbo;

        import java.sql.Date;

        public class Customer {

            private int id;
            private String loginId;
            private String fullName;
            private String email;
            private String password;
            private String role;
            private boolean isActive;
            private Date createdAt;

            public Customer() {
            }

            public Customer(int id, String loginId, String fullName,
                    String email, String password,
                    String role, boolean isActive, Date createdAt) {

                this.id = id;
                this.loginId = loginId;
                this.fullName = fullName;
                this.email = email;
                this.password = password;
                this.role = role;
                this.isActive = isActive;
                this.createdAt = createdAt;
            }

            public int getId() {
                return id;
            }

            public void setId(int id) {
                this.id = id;
            }

            public String getLoginId() {
                return loginId;
            }

            public void setLoginId(String loginId) {
                this.loginId = loginId;
            }

            public String getFullName() {
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

            public boolean isActive() {
                return isActive;
            }

            public void setActive(boolean active) {
                this.isActive = active;
            }

            public Date getCreatedAt() {
                return createdAt;
            }

            public void setCreatedAt(Date createdAt) {
                this.createdAt = createdAt;
            }
        }