const fs = require('fs');
const path = require('path');
const dotenv = require('dotenv');
const mysql = require('mysql2/promise');

const root = path.resolve(__dirname);
const envFile = fs.existsSync(path.join(root, '.env')) ? '.env' : '.env.example';

dotenv.config({ path: path.join(root, envFile) });

const dbConfig = {
    host: process.env.DB_HOST || '127.0.0.1',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'protein_gallery',
    waitForConnections: true,
    connectionLimit: 5,
    queueLimit: 0
};

async function testDb() {
    console.log(`Testing database connection using ${envFile}`);
    console.log('DB Config:', {
        host: dbConfig.host,
        user: dbConfig.user,
        database: dbConfig.database
    });

    const pool = mysql.createPool(dbConfig);
    try {
        const conn = await pool.getConnection();
        console.log('✅ Database connection successful.');
        const [rows] = await conn.query('SELECT 1 + 1 AS result');
        console.log('✅ Test query result:', rows[0]);
        conn.release();
    } catch (error) {
        console.error('❌ Database connection failed:');
        console.error(error);
        process.exitCode = 1;
    } finally {
        await pool.end();
    }
}

async function testRegisterEndpoint() {
    const url = process.env.TEST_SERVER_URL || 'http://127.0.0.1:5000/api/auth/register';
    console.log(`Testing register endpoint: ${url}`);

    const testData = {
        name: 'Test User',
        email: `testuser+${Date.now()}@example.com`,
        phone_number: '9999999999',
        password: 'TestPass123'
    };

    try {
        const res = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(testData)
        });
        const json = await res.json();
        console.log('✅ Register endpoint response status:', res.status);
        console.log('Response body:', json);
        if (!json.success) process.exitCode = 1;
    } catch (error) {
        console.error('❌ Register endpoint request failed:');
        console.error(error);
        process.exitCode = 1;
    }
}

(async () => {
    await testDb();
    console.log('---');
    await testRegisterEndpoint();
})();
