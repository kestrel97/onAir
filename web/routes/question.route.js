const express = require('express');
const router = express.Router();
const questionService = require('services/question.service');

router.post('/create', create);

function create(req, res, next) {
    questionService.create(req.body)
        .then((result) => res.json(result))
        .catch(err => next(err));
}

module.exports = router;