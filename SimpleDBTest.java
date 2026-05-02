import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class SimpleDBTest {
    public static void main(String[] args) {
        System.out.println("🔍 Testing Database Connection...");

        String url = "jdbc:mysql://localhost:3306/protein_gallery?useSSL=false&allowPublicKeyRetrieval=true";
        String user = "root";
        String password = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);

            System.out.println("✅ Connection established successfully!");

            // Test basic query
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT VERSION() as version");

            if (rs.next()) {
                System.out.println("📊 MySQL Version: " + rs.getString("version"));
            }

            // Check if database exists
            rs = stmt.executeQuery("SHOW DATABASES LIKE 'protein_gallery'");
            if (rs.next()) {
                System.out.println("✅ Database 'protein_gallery' exists!");
            } else {
                System.out.println("❌ Database 'protein_gallery' does not exist!");
            }

            // Check tables
            rs = stmt.executeQuery("SHOW TABLES FROM protein_gallery");
            System.out.println("📋 Tables in protein_gallery:");
            boolean hasTables = false;
            while (rs.next()) {
                hasTables = true;
                System.out.println("  - " + rs.getString(1));
            }

            if (!hasTables) {
                System.out.println("  No tables found. Database might not be initialized.");
            }

            rs.close();
            stmt.close();
            conn.close();

            System.out.println("✅ Database test completed successfully!");

        } catch (Exception e) {
            System.err.println("❌ Database test failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}