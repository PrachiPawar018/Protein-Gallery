const mysql = require('mysql2/promise');

(async () => {
  try {
    const db = await mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: 'root',
      database: 'protein_gallery'
    });
    console.log('MYSQL_OK');
    await db.end();
  } catch (err) {
    console.error(err.message);
    process.exit(1);
  }
})();
