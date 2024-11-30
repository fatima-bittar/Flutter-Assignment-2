const { insertSubmission,getAllSubmissions } = require('../models/submissionModel');

const saveFormSubmission = (req, res, next) => {
  const formId = req.params.formId; // Read formId from the URL
  const formData = req.body.data; // Assuming form data is sent in the 'data' field

   // Validate the request body
   if (!formId || !formData) {
    return res.status(400).json({ success: false, message: 'Invalid form submission.' });
  }
  
  insertSubmission(formId, JSON.stringify(formData))
    .then(() => res.send({ success: true, message: 'Form submitted successfully!' , data :JSON.stringify(formData) }))
    .catch((err) => next(err));
};
const fetchAllSubmissions = (req, res, next) => {
  getAllSubmissions()
    .then((submissions) => {
      // Parse data from JSON strings back to objects
      const formattedSubmissions = submissions.map((submission) => ({
        id: submission.id,
        form_id: submission.form_id,
        data: JSON.parse(submission.data), // Convert back to JSON
        created_at: submission.created_at, // Include timestamp if available
      }));

      res.json({ success: true, submissions: formattedSubmissions });
    })
    .catch((err) => next(err));
};

module.exports = { saveFormSubmission, fetchAllSubmissions };