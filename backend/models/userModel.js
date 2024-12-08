const db = require('../database/db'); // Database connection
const bcrypt = require('bcryptjs');

// Create a new user
const createUser = (username, email, hashedPassword, role = 'user') => {
    return new Promise((resolve, reject) => {
        const query = `
            INSERT INTO users (username, email, password, role) 
            VALUES (?, ?, ?, ?);
        `;
        db.run(query, [username, email, hashedPassword, role], function (err) {
            if (err) {
                return reject(err); // Reject promise if there's an error
            }
            resolve(this.lastID); // Resolve with the last inserted ID
        });
    });
};

// Find a user by email
const findUserByEmail = (email) => {
    return new Promise((resolve, reject) => {
        const query = `
            SELECT * FROM users WHERE email = ?;
        `;
        db.get(query, [email], (err, row) => {
            if (err) {
                return reject(err); // Reject promise if there's an error
            }
            resolve(row); // Resolve with the found user (row)
        });
    });
};

// Find a user by ID
const findUserById = (id) => {
    return new Promise((resolve, reject) => {
        const query = `
            SELECT * FROM users WHERE id = ?;
        `;
        db.get(query, [id], (err, row) => {
            if (err) {
                return reject(err); // Reject promise if there's an error
            }
            resolve(row); // Resolve with the found user (row)
        });
    });
};

// Get all users
const getAllUsers = () => {
    return new Promise((resolve, reject) => {
        const query = 'SELECT * FROM users';
        db.all(query, [], (err, rows) => {
            if (err) {
                return reject(err); // Reject promise if there's an error
            }
            resolve(rows); // Resolve with the array of users
        });
    });
};

// Delete a user
const deleteUserById = (id) => {
    return new Promise((resolve, reject) => {
        const query = `
            DELETE FROM users WHERE id = ?;
        `;
        db.run(query, [id], function (err) {
            if (err) {
                return reject(err); // Reject promise if there's an error
            }
            resolve(this.changes); // Resolve with the number of deleted rows
        });
    });
};

module.exports = {
    createUser,
    findUserByEmail,
    findUserById,
    getAllUsers,
    deleteUserById,
};
