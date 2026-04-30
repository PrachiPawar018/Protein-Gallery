# Protein Gallery Deployment Guide

This guide provides step-by-step instructions for deploying the **Protein Gallery** application to an Apache Tomcat 10+ server in a production environment.

## Prerequisites

1. **Java 17+**: Ensure Java SDK 17 or higher is installed and the `JAVA_HOME` environment variable is set.
2. **Apache Tomcat 10+**: This application uses Jakarta EE APIs (`jakarta.servlet`), which requires Tomcat 10. It will **not** work on Tomcat 9.
3. **MySQL 8.0+**: Ensure MySQL is running.
4. **Maven**: For building the application.

## 1. Database Setup

1. Log in to your MySQL database:
   ```bash
   mysql -u root -p
   ```
2. Run the provided database script to create the schema, tables, and seed data:
   ```bash
   source /path/to/Protein-Gallery/database_setup.sql
   ```
   *Note: This creates a database named `protein_gallery` and populates the `products` and `users` tables.*

## 2. Environment Variables

The application relies on environment variables for sensitive configurations. Set the following variables on your server before starting Tomcat.

### Windows (System Variables)
Set these in "Environment Variables" > "System variables":
- `DB_URL` = `jdbc:mysql://localhost:3306/protein_gallery?useSSL=false&serverTimezone=UTC`
- `DB_USER` = `root` (or your db user)
- `DB_PASSWORD` = `your_db_password`
- `RAZORPAY_KEY_ID` = `your_razorpay_key_id`
- `RAZORPAY_KEY_SECRET` = `your_razorpay_key_secret`
- `SMTP_USER` = `your_email@gmail.com`
- `SMTP_PASSWORD` = `your_app_password`

### Linux/macOS
Add these to your `~/.bashrc`, `~/.zshrc`, or Tomcat's `setenv.sh`:
```bash
export DB_URL="jdbc:mysql://localhost:3306/protein_gallery?useSSL=false&serverTimezone=UTC"
export DB_USER="root"
export DB_PASSWORD="your_db_password"
export RAZORPAY_KEY_ID="your_razorpay_key_id"
export RAZORPAY_KEY_SECRET="your_razorpay_key_secret"
export SMTP_USER="your_email@gmail.com"
export SMTP_PASSWORD="your_app_password"
```

## 3. Build the WAR File

Open a terminal in the project's root directory (where `pom.xml` is located) and run:

```bash
mvn clean package
```

This command will compile the project and create a WAR file named `ProteinGallery-1.0-SNAPSHOT.war` in the `target/` directory.

## 4. Deploy to Tomcat

1. Locate the built WAR file: `target/ProteinGallery-1.0-SNAPSHOT.war`.
2. Rename the file to `ROOT.war` (if you want the app to run on the root context `http://yourdomain.com/`) or leave it as is to run on `http://yourdomain.com/ProteinGallery-1.0-SNAPSHOT/`.
3. Copy the WAR file to Tomcat's `webapps` directory:
   - **Windows**: `C:\apache-tomcat-10.x.x\webapps\`
   - **Linux**: `/opt/tomcat/webapps/`
4. Start Tomcat:
   - **Windows**: Run `bin/startup.bat`
   - **Linux**: Run `bin/startup.sh`

## 5. Verify Deployment

1. Open your browser and navigate to `http://localhost:8080/` (or the appropriate context path).
2. The Protein Gallery homepage should load successfully.
3. Test logging in as the Admin:
   - **Email**: `prachipawar5133@gmail.com`
   - **Password**: `admin123` (or the seeded BCrypt password)
4. Navigate to `http://localhost:8080/admin/dashboard` to verify admin access.

## Troubleshooting

- **ClassNotFoundException: jakarta.servlet...**: You are likely running Tomcat 9. Please upgrade to Tomcat 10.
- **Database Connection Error**: Verify that the environment variables are correctly loaded by Tomcat and that MySQL is running on the correct port.
- **Email Failed to Send**: Ensure you are using an "App Password" (if using Gmail) rather than your standard account password, and that 2FA is enabled.
