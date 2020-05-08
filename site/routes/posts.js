var express = require('express');
var router = express.Router();

/* GET posts index /posts. */
router.get('/', (req, res, next) => {
    res.send('/posts');
});

/* GET posts new /posts/new. */
router.get('/new', (req, res, next) => {
    res.send('/posts/new');
});

/* POST posts create /posts. */
router.post('/', (req, res, next) => {
    res.send('CREATE /posts');
});

/* GET posts show /posts. */
router.get('/:id', (req, res, next) => {
    res.send('SHOW /posts/:id');
});

/* GET posts edit /posts. */
router.get('/:id/edit', (req, res, next) => {
    res.send('EDIT /posts/:id');
});

/* PUT posts update /posts. */
router.put('/:id', (req, res, next) => {
    res.send('UPDATE /posts/:id');
});

/* DELETE posts destroy /posts. */
router.delete('/:id', (req, res, next) => {
    res.send('DELETE /posts/:id');
});


module.exports = router;


/*
GET index        /posts
GET new          /posts/new
POST create      /posts
GET show         /posts/:id
GET edit         /posts/:id/edit
PUT update       /posts/:id
DELETE destroy   /posts/:id

*/
