const { fetchFormStructure, addFormStructure, fetchAllForms } = require('../models/formModel');

// Controller for fetching a specific form structure
const getFormStructure = (req, res, next) => { 
  const formId = req.params.id;  // Assuming you pass a formId as a URL param
  fetchFormStructure(formId)
    .then((form) => {
      if (!form) {
        return res.status(404).json({ message: 'Form not found' });
      }
      // Ensure that 'id' and 'name' are included in the response
      const formData = {
        id: form.id,  // Add id to the response
        name: form.name,  // Add name to the response
        structure: JSON.parse(form.structure),  // Parse the structure
      };

      res.json(formData);  // Sending back the parsed form structure
    })
    .catch((err) => next(err)); // Handling errors
};


// Controller for creating a new form
const createForm = (req, res) => {
  const { name, structure } = req.body;  // Expecting name and structure in the request body
  
  addFormStructure(name, structure)
    .then((result) => {
      res.status(201).json({ message: 'Form created successfully', formId: result });
    })
    .catch((error) => {
      console.error(error);
      res.status(500).json({ error: error.message });
    });
};

// Controller for fetching all form structures (fields)
const getAllForms = (req, res, next) => {
  fetchAllForms()
    .then((forms) => {
      if (!forms || forms.length === 0) {
        return res.status(404).json({ message: 'No forms found' });
      }

      // Map the forms to include both 'name' and 'structure'
      const formStructures = forms.map((form) => {
        return {
          id: form.id, // Assuming 'id' is a field in your form data
          name: form.name, // Include the name of the form
          structure: JSON.parse(form.structure), // Parse structure field to JSON
        };
      });

      // Send back an array of form objects with name and structure
      res.json(formStructures);
    })
    .catch((err) => next(err)); // Handle any errors
};


module.exports = {
  getFormStructure,
  createForm,
  getAllForms, // Exporting the new controller function
};
