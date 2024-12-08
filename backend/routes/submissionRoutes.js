const express = require('express');
const { saveFormSubmission, fetchAllSubmissions, removeSubmission, editSubmission,fetchSubmissionsByFormId } = require('../controllers/submissionController');
const router = express.Router();
const { verifyToken, isAdmin } = require('../utils/authMiddleWares');


// Route to submit form data (with user authentication)
router.post('/:formId/submit',verifyToken, saveFormSubmission); 
// Route to fetch all form submissions (admin or authorized users only)
router.get('/submissions', fetchAllSubmissions);
//Route to fetch submissions by formId
router.get('/:formId/submissions', fetchSubmissionsByFormId);
//Route to delete submission
router.delete('/submissions/:id',verifyToken, removeSubmission);
//Edit submissions
router.put('/submissions/:id',verifyToken,  editSubmission);


module.exports = router;
