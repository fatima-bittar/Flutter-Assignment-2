const express = require('express');
const router = express.Router();
const { getFormStructure, createForm, getAllForms } = require('../controllers/formController');

// Route to fetch a form structure by ID
router.get('/form_structure/:id', getFormStructure);

// Route to create a new form
router.post('/create_form', createForm);

// Route to fetch all form structures (fields)
router.get('/form_structures', getAllForms);  // New endpoint to get all forms

module.exports = router;
