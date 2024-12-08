const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const formRoutes = require('./routes/formRoutes');
const userRoutes = require('./routes/userRoutes');
const submissionRoutes = require('./routes/submissionRoutes');
const { handleErrors } = require('./utils/errorHandler');
const sqlite3 = require('sqlite3').verbose();  // Import SQLite3
require('dotenv').config();

const app = express();
const PORT = 3000;
const HOST = '0.0.0.0';

app.use(cors());
app.use(bodyParser.json());


// Routes
app.use('/api/forms', formRoutes);
app.use('/api/forms', submissionRoutes);
app.use('/api/users', userRoutes);

// Error handling middleware
app.use(handleErrors);

app.listen(PORT, HOST, () => {
  console.log(`Server is running at http://${HOST}:${PORT}`);
});
