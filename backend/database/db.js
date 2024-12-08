const sqlite3 = require('sqlite3').verbose();
const fs = require('fs');
const path = require('path');

// Path to the migrations.sql file
const migrationsPath = path.join(__dirname, 'migrations.sql');

// Initialize the database
const db = new sqlite3.Database('./form_data.db', (err) => {
  if (err) {
    console.error('Error connecting to SQLite:', err.message);
  } else {
    console.log('Connected to SQLite database');

    // Load and execute the migrations
    fs.readFile(migrationsPath, 'utf-8', (err, sql) => {
      if (err) {
        console.error('Error reading migrations.sql:', err.message);
      } else {
        db.exec(sql, (err) => {
          if (err) {
            console.error('Error executing migrations:', err.message);
          } else {
            console.log('Database tables initialized successfully');
          }
        });
      }
    });
  }
});

module.exports = db;
