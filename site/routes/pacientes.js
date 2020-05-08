var express = require('express');
var router = express.Router();

/* GET posts index /pacientes. */
router.get('/', (req, res, next) => {
    res.send('/pacientes');
});

/* GET posts new /pacientes/new. */
router.get('/new', (req, res, next) => {
    res.send('/pacientes/new');
});

/* POST posts create /pacientes. */
router.post('/', (req, res, next) => {
    res.send('CREATE /pacientes');
});

/* GET posts show /pacientes. */
router.get('/:id', (req, res, next) => {
    res.send('SHOW /pacientes/:id');
});

/* GET posts edit /pacientes. */
router.get('/:id/edit', (req, res, next) => {
    res.send('EDIT /pacientes/:id');
});

/* PUT posts update /pacientes. */
router.put('/:id', (req, res, next) => {
    res.send('UPDATE /pacientes/:id');
});

/* DELETE posts destroy /pacientes. */
router.delete('/:id', (req, res, next) => {
    res.send('DELETE /pacientes/:id');
});


module.exports = router;


/*
GET index        /pacientes
GET new          /pacientes/new
POST create      /pacientes
GET show         /pacientes/:id
GET edit         /pacientes/:id/edit
PUT update       /pacientes/:id
DELETE destroy   /pacientes/:id

*/
