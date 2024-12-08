const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/userModel');
require('dotenv').config();

const secretKey = process.env.SECRET_KEY;
// Register a new user
const registerUser = async (req, res) => {
    const { username, email, password, role } = req.body;

    try {
        // Check if the email is already in use
        const existingUser = await User.findUserByEmail(email);
        if (existingUser) {
            return res.status(400).json({ message: 'User already exists' });
        }

        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Create the new user
        await User.createUser(username, email, hashedPassword, role || 'user');
        res.status(201).json({ message: 'User registered successfully', role : role });
    } catch (err) {
        console.error('Error registering user:', err);
        res.status(500).json({ message: 'Error registering user' });
    }
};

// Login a user
const loginUser = async (req, res) => {
    const { email, password } = req.body;

    try {
        // Find the user by email
        const user = await User.findUserByEmail(email);
        if (!user) {
            return res.status(400).json({ message: 'Invalid email ' });
        }

        // Compare the hashed password
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid password' });
        }

        // Generate a JWT token
        const token = jwt.sign(
            { id: user.id, username: user.username, role: user.role },
            secretKey,
            { expiresIn: '1h' }
        );

        res.json({ message: 'Login successful', token, role : user.role, userId: user.id});
    } catch (err) {
        console.error('Error logging in user:', err);
        res.status(500).json({ message: 'Error logging in user' });
    }
};

// Delete a user
const deleteUser = async (req, res) => {
    const { id } = req.params;

    try {
        await User.deleteUserById(id);
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (err) {
        console.error('Error deleting user:', err);
        res.status(500).json({ message: 'Error deleting user' });
    }
};

const fetchAllUsers = async (req, res) => {
    try {
        const users = await User.getAllUsers(); 
        
        res.status(200).json(
           users, // Send the fetched users as the response
        );
    } catch (error) {
        console.error('Error fetching users:', error.message);
        res.status(500).json({
            success: false,
            message: 'Failed to fetch users',
        });
    }
};
const fetchUserById = async (req, res) => {
    const { id } = req.params;

    try {
        await User.getUserById(id);
        res.status(200).json({ message: 'User deleted successfully' });
    } catch (err) {
        console.error('Error deleting user:', err);
        res.status(500).json({ message: 'Error deleting user' });
    }
};

module.exports = {
    registerUser,
    loginUser,
    deleteUser,
    fetchAllUsers,
    fetchUserById
};
