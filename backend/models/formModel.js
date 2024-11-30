const db = require('../database/db');

// Fetch form structure from the database by ID
const fetchFormStructure = (formId) => {
  return new Promise((resolve, reject) => {
    db.get('SELECT * FROM forms WHERE id = ?', [formId], (err, row) => {
      if (err) reject(err);
      else resolve(row);
    });
  });
};

// Add a new form to the database
const addFormStructure = (name, structure) => {
  return new Promise((resolve, reject) => {
    db.run(
      'INSERT INTO forms (name, structure) VALUES (?, ?)',
      [name, JSON.stringify(structure)],
      function (err) {
        if (err) reject(err);
        else resolve(this.lastID); // Return the ID of the inserted form
      }
    );
  });
};

// Fetch all forms from the database
const fetchAllForms = () => {
  return new Promise((resolve, reject) => {
    db.all('SELECT * FROM forms', (err, rows) => {
      if (err) reject(err);
      else resolve(rows);  // Return all forms
    });
  });
};

module.exports = {
  fetchFormStructure,
  addFormStructure,
  fetchAllForms,  // Exporting the new function to fetch all forms
};
