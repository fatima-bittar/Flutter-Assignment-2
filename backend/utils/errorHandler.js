const handleErrors = (err, req, res, next) => {
    console.error(err.message);
    res.status(500).send({ error: 'An internal error occurred' });
  };
  
  module.exports = { handleErrors };
  