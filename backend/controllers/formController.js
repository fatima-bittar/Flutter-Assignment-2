const { addFormStructure, fetchFormStructure, fetchAllForms, updateForm, deleteForm, fetchAllFormsAndSubmissions } = require('../models/formModel');

// Controller for creating a new form
const createForm = (req, res) => {
  const { name, structure } = req.body;  // Expecting name and structure in the request body
  const created_by = req.user.id; // Extract user ID from the authenticated user
  
  addFormStructure(name, structure, created_by)
    .then((result) => {
      res.status(201).json({ message: 'Form created successfully', formId: result });
    })
    .catch((error) => {
      console.error(error);
      res.status(500).json({ error: error.message });
    });
};

// Controller for fetching a specific form structure
const getFormStructure = (req, res, next) => {
  const formId = req.params.id;

  fetchFormStructure(formId)
    .then((form) => {
      if (!form) {
        return res.status(404).json({ message: 'Form not found' });
      }
      const formData = {
        id: form.id,
        name: form.name,
        structure: JSON.parse(form.structure),
      };
      res.json(formData);
    })
    .catch((err) => next(err)); 
};

// Controller for fetching all form structures
const getAllForms = (req, res, next) => {
  fetchAllForms()
    .then((forms) => {
      if (!forms || forms.length === 0) {
        return res.status(404).json({ message: 'No forms found' });
      }

      const formStructures = forms.map((form) => ({
        id: form.id,
        name: form.name,
        structure: JSON.parse(form.structure),
      }));

      res.json(formStructures);
    })
    .catch((err) => next(err));
};

// Controller for fetching the form it's structure and it's submissions
const getAllFormsAndSubmissions = (req, res, next) => {
  fetchAllFormsAndSubmissions()
    .then((rows) => {
      if (!rows || rows.length === 0) {
        return res.status(404).json({ message: 'No forms found' });
      }

      const formsMap = new Map();

      rows.forEach((row) => {
        const {
          form_id,
          form_name,
          form_structure,
          form_status,
          submission_id,
          submission_data,
          submission_date,
          user_id,
        } = row;

        if (!formsMap.has(form_id)) {
          formsMap.set(form_id, {
            id: form_id,
            name: form_name,
            structure: JSON.parse(form_structure),
            is_enabled: form_status,
            submissions: [],
          });
        }

        if (submission_id) {
          formsMap.get(form_id).submissions.push({
            id: submission_id,
            user_id: user_id,
            data: JSON.parse(submission_data),
            submitted_at: submission_date,
          });
        }
      });

      const forms = Array.from(formsMap.values());
      res.status(200).json({ forms });
    })
    .catch((err) => next(err));
};


const removeForm = (req, res, next) => {
  const { id } = req.params;

  deleteForm(id)
    .then(() => res.status(200).json({ message: `Form with ID ${id} deleted successfully.` }))
    .catch((err) => {
      if (err.message.includes('No form found')) {
        res.status(404).json({ message: err.message });
      } else {
        next(err);
      }
    });
};

const editForm = (req, res, next) => {
  const { id } = req.params;
  const { name, structure } = req.body;

  if (!name || !structure) {
    return res.status(400).json({ message: 'Name and structure are required for updating the form.' });
  }

  updateForm(id, name, structure)
    .then(() => res.status(200).json({ message: `Form with ID ${id} updated successfully.` }))
    .catch((err) => {
      if (err.message.includes('No form found')) {
        res.status(404).json({ message: err.message });
      } else {
        next(err);
      }
    });
};

module.exports = { createForm, getFormStructure, getAllForms, removeForm, editForm,getAllFormsAndSubmissions };
