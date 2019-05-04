const express = require('express');
const router = express.Router();
const questionService = require('services/question.service');

router.get('/byUid/:uid', getByUserId);
router.post('/create', create);

function create(req, res, next) {
    questionService.create(req.body)
        .then((result) => res.json(result))
        .catch(err => next(err));
}

function getByUserId(req, res, next) {
    questionService.getByUserId(req.params.uid)
        .then(questions => questions ? res.json(questions) : res.sendStatus(404))
        .catch(err => next(err));
}

module.exports = router;