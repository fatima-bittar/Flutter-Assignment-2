const db = require('../database/db');

// Insert a submission with user_id
const insertSubmission = (formId, data, userId) => {
  return new Promise((resolve, reject) => {
    db.run(
      'INSERT INTO submissions (form_id, data, user_id) VALUES (?, ?, ?)', 
      [formId, data, userId],
      (err) => {
        if (err) reject(err);
        else resolve();
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

const deleteSubmission = (submissionId) => {
  return new Promise((resolve, reject) => {
    db.run(
      'DELETE FROM submissions WHERE id = ?',
      [submissionId],
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

const updateSubmission = (submissionId, updatedData) => {
  return new Promise((resolve, reject) => {
    const sql = `
      UPDATE submissions 
      SET data = ?, updated_at = CURRENT_TIMESTAMP 
      WHERE id = ?`;
    db.run(sql, [JSON.stringify(updatedData), submissionId], function (err) {
      if (err) {
        reject(err);
      } else if (this.changes === 0) {
        reject(new Error(`No submission found with ID ${submissionId}`));
      } else {
        resolve();
      }
    });
  });
};

// Fetch submissions by formId
const getSubmissionsByFormId = (formId) => {
  return new Promise((resolve, reject) => {
    db.all('SELECT submissions.id, submissions.data, submissions.submitted_at, username FROM submissions JOIN users ON submissions.user_id = users.id WHERE form_id = ?', [formId], (err, rows) => {
      if (err) {
        reject(err);
      } else {
        resolve(rows);
      }
    });
  });
};

module.exports = { insertSubmission, getAllSubmissions, deleteSubmission, updateSubmission, getSubmissionsByFormId};

