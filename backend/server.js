const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const formRoutes = require('./routes/formRoutes');
const submissionRoutes = require('./routes/submissionRoutes');
const { handleErrors } = require('./utils/errorHandler');

const app = express();
const PORT = 3000;
const HOST = '0.0.0.0' ;

app.use(cors());
app.use(bodyParser.json());

// Routes
app.use('/api/forms', formRoutes);
app.use('/api/forms', submissionRoutes);

// Error handling middleware
app.use(handleErrors);

app.listen(PORT, HOST, () => {
  console.log(`Server is running at http://${HOST}:${PORT}`);
});








