const { Client } = require('pg');

// ฟังก์ชันสำหรับเชื่อมต่อฐานข้อมูล PostgreSQL
async function getConnection() {
  const client = new Client({
    host: process.env.DB_HOST,
    user: process.env.DB_USER || 'Dowmean',
    password: process.env.DB_PASS || 'Dowmean.1006',
    database: process.env.DB_NAME || 'hiwmai',
    port: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : 5432,
  });
  await client.connect();
  return client;
}

module.exports = getConnection;
