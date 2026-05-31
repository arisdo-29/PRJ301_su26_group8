
package dao;

import dto.User;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import mylib.DBUtils;

public class UserDAO {
    public int createNewUser(User u){
        int result = 0;
        Connection cn=null;
        try{
            //make connection
            cn=DBUtils.getConnection();
            if(cn!=null){
                // viet sql va run sql
                String sql = "insert into dbo.users(login_id, password, full_name, email, is_active, created_at) \n" 
                             + "values(?,?,?,?,?,?)";
                PreparedStatement st=cn.prepareStatement(sql);
                
                st.setString(1, u.getLoginId());
                st.setString(2, u.getPassword());
                
                st.setString(3, u.getFullName());
                st.setString(4, u.getEmail());
                st.setBoolean(5, u.isIsActive());
                st.setDate(6, u.getCreateAt());
                
                result = st.executeUpdate();
            }
        } catch(Exception e){
            e.printStackTrace();
        } finally{
            try{
                if(cn!=null) cn.close();
            }catch(Exception e){
                e.printStackTrace();
             }
         }
        return result;
    }
    
    public User getUser(String email, String password){
        User result = null;
        Connection cn=null;
        try{
            cn=DBUtils.getConnection();
            if(cn!=null){
                String sql="select [id], [login_id], [password], [role], [full_name], [email], [is_active], [created_at]\n" +
                            "from [dbo].[users]\n" +
                            "where [email] =? and [password]  =?";
                PreparedStatement st=cn.prepareStatement(sql);
                st.setString(1, email);
                st.setString(2, password);
                
                ResultSet table=st.executeQuery();
                if(table!= null){
                    while(table.next()){
                        int uid = table.getInt("id");
                        String logid = table.getString("login_id");
                        //String password = table.getString("password");
                        String role = table.getString("role");
                        String fullName = table.getString("full_name");
                        boolean isActive = table.getBoolean("is_active");
                        Date date = table.getDate("created_at");
                        result=new User(uid, logid, "", role, fullName, email, isActive, date);
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            //close
        }
        return result;
        
    }
    //ham nay de lay Customer dua vao email
    public User getUser(String email){
        User result = null;
        Connection cn=null;
        try{
            cn=DBUtils.getConnection();
            if(cn!=null){
                String sql = "select [id], [login_id], [password], [role], [full_name], [email], [is_active], [created_at]\n" 
                                + "from [dbo].[users]\n"
                                + "where [email]=?";
                //Tạo đối tượng chạy SQL.
                PreparedStatement st =cn.prepareStatement(sql);
                st.setString(1, email);
                ResultSet table = st.executeQuery();
                if(table!=null){
                    while(table.next()){
                        int uid = table.getInt("id");
                        String logid = table.getString("login_Id");
                        //String password = table.getString("password");
                        String role = table.getString("role");
                        String fullName = table.getString("full_name");
                        boolean isActive = table.getBoolean("is_active");
                        Date date = table.getDate("created_at");
                        result=new User(uid, logid, "", role, fullName, email, isActive, date);
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        } finally{
            //close
        }
        return result;
    }
    
}