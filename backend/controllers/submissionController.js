const { insertSubmission, getAllSubmissions , deleteSubmission, updateSubmission,getSubmissionsByFormId} = require('../models/submissionModel');

// Controller for saving form submission
const saveFormSubmission = (req, res, next) => {
  const formId = req.params.formId;
  const formData = req.body.data;
  const userId = req.user.id; // Get user ID from authenticated user
  
  if (!formId || !formData) {
    return res.status(400).json({ success: false, message: 'Invalid form submission.' });
  }

  insertSubmission(formId, JSON.stringify(formData), userId)
    .then(() => res.send({ success: true, message: 'Form submitted successfully!' }))
    .catch((err) => next(err));
};

// Controller for fetching all submissions
const fetchAllSubmissions = (req, res, next) => {
  getAllSubmissions()
    .then((submissions) => {
      const formattedSubmissions = submissions.map((submission) => ({
        id: submission.id,
        form_id: submission.form_id,
        user_id: submission.user_id, // Include user_id to track who submitted
        data: JSON.parse(submission.data),
        submitted_at: submission.submitted_at,
      }));

      res.json(formattedSubmissions );
    })
    .catch((err) => next(err));
};

const removeSubmission = (req, res , next) => {
    const { id } = req.params;
    const userRole = req.user.role; // Assuming role is stored in `req.user`
  
    // Only allow admin users to delete submissions
    if (userRole !== 'admin') {
      return res.status(403).json({ message: 'Access denied. Only admins can delete submissions.' });
    }
  
    try {
      deleteSubmission(id);
      res.status(200).json({ message: `Submission with ID ${id} deleted successfully.` });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Failed to delete the submission.' });
    }
  };
// Controller for editing a submission
const editSubmission = (req, res, next) => {
  const { id } = req.params; // ID of the submission to edit
  const updatedData = req.body.data; // New data to update

  if (!updatedData) {
    return res.status(400).json({ success: false, message: 'No data provided for update.' });
  }

  updateSubmission(id, updatedData)
    .then(() => res.status(200).json({ success: true, message: 'Submission updated successfully.' }))
    .catch((err) => {
      if (err.message.includes('No submission found')) {
        res.status(404).json({ success: false, message: err.message });
      } else {
        next(err);
      }
    });
};
// Controller to get submissions by formId
const fetchSubmissionsByFormId = async (req, res) => {
  const { formId } = req.params;

  try {
    const submissions = (await getSubmissionsByFormId(formId)).map(item => {
      let parsedData = {};
      try {
        parsedData = JSON.parse(item.data);
      } catch (e) {
        console.error('Error parsing data for submission ID:', item.id);
        parsedData = {}; // Provide an empty object if JSON parsing fails
      }

      return {
        ...item,
        id: item.id,
        data: {
          ...parsedData,
          submitted_at: item.submitted_at,
          submitted_by: item.username || 'Unknown', // Fallback for missing username
        },
      };
    });

    res.status(200).json(submissions);
  } catch (error) {
    console.error('Error fetching submissions:', error);
    res.status(500).json({ message: 'Failed to fetch submissions' });
  }
};


module.exports = { saveFormSubmission, fetchAllSubmissions , removeSubmission, editSubmission,fetchSubmissionsByFormId };
