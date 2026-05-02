# Database Connection Test Script
Write-Host "🔍 Testing Database Connection..." -ForegroundColor Cyan

try {
    # Test MySQL connection
    $connectionString = "Server=localhost;Database=protein_gallery;User Id=root;Password=root;"
    $connection = New-Object MySql.Data.MySqlClient.MySqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()

    Write-Host "✅ Connection established successfully!" -ForegroundColor Green

    # Test basic query
    $command = $connection.CreateCommand()
    $command.CommandText = "SELECT VERSION() as version"
    $reader = $command.ExecuteReader()
    if ($reader.Read()) {
        $version = $reader["version"]
        Write-Host "📊 MySQL Version: $version" -ForegroundColor Yellow
    }
    $reader.Close()

    # Check if database exists
    $command.CommandText = "SHOW DATABASES LIKE 'protein_gallery'"
    $reader = $command.ExecuteReader()
    if ($reader.Read()) {
        Write-Host "✅ Database 'protein_gallery' exists!" -ForegroundColor Green
    } else {
        Write-Host "❌ Database 'protein_gallery' does not exist!" -ForegroundColor Red
    }
    $reader.Close()

    # Check tables
    $command.CommandText = "SHOW TABLES FROM protein_gallery"
    $reader = $command.ExecuteReader()
    Write-Host "📋 Tables in protein_gallery:" -ForegroundColor Yellow
    $hasTables = $false
    while ($reader.Read()) {
        $hasTables = $true
        $tableName = $reader[0]
        Write-Host "  - $tableName" -ForegroundColor White
    }
    $reader.Close()

    if (-not $hasTables) {
        Write-Host "  No tables found. Database might not be initialized." -ForegroundColor Red
    }

    # Test user count
    try {
        $command.CommandText = "SELECT COUNT(*) as user_count FROM protein_gallery.users"
        $reader = $command.ExecuteReader()
        if ($reader.Read()) {
            $userCount = $reader["user_count"]
            Write-Host "👥 Users in database: $userCount" -ForegroundColor Cyan
        }
        $reader.Close()
    } catch {
        Write-Host "❌ Error checking users table: $($_.Exception.Message)" -ForegroundColor Red
    }

    # Test product count
    try {
        $command.CommandText = "SELECT COUNT(*) as product_count FROM protein_gallery.products"
        $reader = $command.ExecuteReader()
        if ($reader.Read()) {
            $productCount = $reader["product_count"]
            Write-Host "📦 Products in database: $productCount" -ForegroundColor Cyan
        }
        $reader.Close()
    } catch {
        Write-Host "❌ Error checking products table: $($_.Exception.Message)" -ForegroundColor Red
    }

    $connection.Close()
    Write-Host "✅ Database test completed successfully!" -ForegroundColor Green

} catch {
    Write-Host "❌ Database test failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Stack Trace:" -ForegroundColor Red
    $_.Exception.StackTrace
}

Read-Host "Press Enter to exit"