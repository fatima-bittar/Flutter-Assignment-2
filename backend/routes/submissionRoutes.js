const express = require('express');
const { saveFormSubmission, fetchAllSubmissions } = require('../controllers/submissionController');
const router = express.Router();

router.post('/:formId/submit', saveFormSubmission);
router.get('/submissions', fetchAllSubmissions);

module.exports = router;
