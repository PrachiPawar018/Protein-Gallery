@echo off
echo 🔍 Testing Database Connection...
echo.

REM Test MySQL connection
mysql -u root -proot -e "SELECT VERSION() as version;" 2>nul
if %errorlevel% neq 0 (
    echo ❌ MySQL connection failed!
    echo Please make sure MySQL is running and credentials are correct.
    goto end
)

echo ✅ MySQL connection successful!

REM Check if database exists
mysql -u root -proot -e "SHOW DATABASES LIKE 'protein_gallery';" 2>nul | findstr protein_gallery >nul
if %errorlevel% neq 0 (
    echo ❌ Database 'protein_gallery' does not exist!
    echo Run the database_setup.sql script to create it.
    goto end
)

echo ✅ Database 'protein_gallery' exists!

REM Check tables
echo 📋 Tables in protein_gallery:
mysql -u root -proot -e "SHOW TABLES FROM protein_gallery;" 2>nul
if %errorlevel% neq 0 (
    echo ❌ Error checking tables
    goto end
)

REM Check user count
echo.
mysql -u root -proot -e "SELECT COUNT(*) as user_count FROM protein_gallery.users;" 2>nul
if %errorlevel% neq 0 (
    echo ❌ Error checking users table
)

REM Check product count
mysql -u root -proot -e "SELECT COUNT(*) as product_count FROM protein_gallery.products;" 2>nul
if %errorlevel% neq 0 (
    echo ❌ Error checking products table
)

echo.
echo ✅ Database test completed successfully!

:end
echo.
pause