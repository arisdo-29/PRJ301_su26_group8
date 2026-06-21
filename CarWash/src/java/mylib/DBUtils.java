package mylib;
 
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
 
public class DBUtils {
 
    private static final String DB_NAME     = "AutoWashPro";
    private static final String DB_USER_NAME = "sa";
    private static final String DB_PASSWORD  = "12345";
 
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
 
        // Thêm unicode + encrypt=false để fix:
        //   - Lỗi font tiếng Việt (Ä□en → Đen)
        //   - Lỗi SSL certificate trên SQL Server local
        String url = "jdbc:sqlserver://localhost:1433;"
                   + "databaseName=" + DB_NAME + ";"
                   + "unicode=true;"
                   + "characterEncoding=UTF-8;"
                   + "encrypt=false;"
                   + "trustServerCertificate=true;";
 
        return DriverManager.getConnection(url, DB_USER_NAME, DB_PASSWORD);
    }
}