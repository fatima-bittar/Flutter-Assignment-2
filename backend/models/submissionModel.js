const db = require('../database/db');

const insertSubmission = (formId, data) => {
  return new Promise((resolve, reject) => {
    db.run(
      'INSERT INTO submissions (form_id, data) VALUES (?, ?)', 
      [formId, data],
      (err) => {
        if (err) {
          reject(err);
        } else {
          resolve();
        }
      }
    );
  });
};
const getAllSubmissions = () => {
  return new Promise((resolve, reject) => {
    db.all('SELECT * FROM submissions', [], (err, rows) => {
      if (err) {
        reject(err);
      } else {
        resolve(rows);
      }
    });
  });
};

module.exports = { insertSubmission, getAllSubmissions };

