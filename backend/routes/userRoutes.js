const express = require('express');
const  {registerUser, loginUser, deleteUser, fetchAllUsers, fetchUserById} = require('../controllers/userController');
const router = express.Router();
const {isAdmin, verifyToken} = require('../utils/authMiddleWares');
const { verify } = require('jsonwebtoken');

// Public routes
router.post('/register', registerUser);
router.post('/login', loginUser);

// Protected routes
router.get('/', fetchAllUsers); // Only logged-in users , verifyToken,
router.get ('/:id', fetchUserById);
router.delete('/:id', deleteUser);


module.exports = router;
