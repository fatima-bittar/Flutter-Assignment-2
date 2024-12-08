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
const addFormStructure = (name, structure, userId) => {
  return new Promise((resolve, reject) => {
    db.run(
      'INSERT INTO forms (name, structure, created_by) VALUES (?, ?, ?)',
      [name, JSON.stringify(structure), userId],
      function (err) {
        if (err) reject(err);
        else resolve(this.lastID);
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
const deleteForm = (formId) => {
  return new Promise((resolve, reject) => {
    const sql = 'DELETE FROM forms WHERE id = ?';
    db.run(sql, [formId], function (err) {
      if (err) {
        reject(err);
      } else if (this.changes === 0) {
        reject(new Error(`No form found with ID ${formId}`));
      } else {
        resolve();
      }
    });
  });
};

const updateForm = (formId, name, structure) => {
  return new Promise((resolve, reject) => {
    const sql = `
      UPDATE forms 
      SET name = ?, structure = ?, updated_at = CURRENT_TIMESTAMP 
      WHERE id = ?`;
    db.run(sql, [name, JSON.stringify(structure), formId], function (err) {
      if (err) {
        reject(err);
      } else if (this.changes === 0) {
        reject(new Error(`No form found with ID ${formId}`));
      } else {
        resolve();
      }
    });
  });
};
module.exports = {
  fetchFormStructure,
  addFormStructure,
  fetchAllForms,
  deleteForm,
  updateForm
};
