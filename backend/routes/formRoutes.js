const express = require('express');
const router = express.Router();
const { getFormStructure, createForm, getAllForms, removeForm, editForm, getAllFormsAndSubmissions } = require('../controllers/formController');
const { verifyToken, isAdmin } = require('../utils/authMiddleWares'); // Assuming this is your authentication middleware

// Route to fetch a form structure by ID
router.get('/form_structure/:id', getFormStructure);

// Route to create a new form (with user authentication)
router.post('/create_form', verifyToken, createForm); 

// Route to fetch all form structures (fields)
router.get('/form_structures', getAllForms);

//Route to fetch all the forms with their submissions:
router.get('/', getAllFormsAndSubmissions);

// Route to delete a form
router.delete('/:id', removeForm);

// Update a form
router.put('/:id' , editForm);

module.exports = router;
