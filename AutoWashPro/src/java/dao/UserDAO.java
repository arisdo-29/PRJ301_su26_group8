
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
        Connection cn = null;
        try {
            // buoc 1: make connection
            cn = DBUtils.getConnection();
            if(cn!=null){
                // buoc 2: viet sql va run sql
                String sql = "insert [dbo].[users]([full_name],[email],[password],[is_active],[created_at])\n" +
                            "values(?,?,?,?,?)";
                PreparedStatement st = cn.prepareStatement(sql);
                st.setString(1, u.getFullname());
                st.setString(2, u.getEmail());
                st.setString(3, u.getPassword());
                st.setBoolean(4, u.isIsActive());
                st.setDate(5, u.getCreateAt());
                result = st.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        finally{
            try{
                if(cn!=null) cn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return result;
    }
    
    // ham nay de lay email password de login
    public User getUser(String email, String password){
        User result = null;
        Connection cn = null;
        try {
            cn = DBUtils.getConnection();
            if(cn!=null){
                
            String sql = "SELECT [id]\n" +
                        "      ,[login_id]\n" +
                        "      ,[password]\n" +
                        "      ,[role]\n" +
                        "      ,[full_name]\n" +
                        "      ,[email]\n" +
                        "      ,[is_active]\n" +
                        "      ,[created_at]\n" +
                        "  FROM [AutoWashPro].[dbo].[users]\n" +
                        "  where [email] =? and [password] =?";
              PreparedStatement st=cn.prepareStatement(sql);
              st.setString(1, email);
              st.setString(2, password);
              
              ResultSet table= st.executeQuery();
              if(table!=null){
                  while(table.next()){
                      int userid=table.getInt("id");
                      String name=table.getString("full_name");
                      Date date=table.getDate("created_at");
                      boolean isActive=table.getBoolean("is_active");
                      result=new User(userid, name, password, email, isActive, date);
                      
                  }
              }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        finally{
            
        }
        return result;
    }
    
    
}
