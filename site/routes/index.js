var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', (req, res, next)=> {
  res.render('index', { title: 'EPILEPSY DETECTION - Home' });
});

/* GET /register */
router.get('/register', (req, res, next) => {
  res.send('GET /register');
});

/* POST /register */
router.post('/register', (req, res, next) => {
  res.send('POST /register');
});


/* GET /login */
router.get('/login', (req, res, next) => {
  res.send('GET /login');
});


/* Post /login */ 

router.post('/login', (req, res, next) => {
  res.send('POST /login');
});


/* GET /profile */
router.get('/profile', (req, res, next) => {
  res.send('GET /profile');
});


/* PUT /profile/:user_id */
router.put('/profile/:user_id', (req, res, next) => {
  res.rensendder('PUT /profile/:user_id');
});


/* GET /forgot-pw */
router.get('/forgot-pw', (req, res, next) => {
  res.send('GET /forgot-pw');
});

/* PUT /forgot-password */
router.put('/forgot-pw', (req, res, next) => {
  res.send('PUT /forgot-pw');
});

/* GET /reset-pw */
router.get('/reset-pw/:token', (req, res, next) => {
  res.send('GET /reset-pw/:token');
});

/* PUT /reset-pw */
router.put('/reset-pw/:token', (req, res, next) => {
  res.send('PUT /reset-pw/:token');
});


module.exports = router;
