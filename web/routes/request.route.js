const express = require('express');
const router = express.Router();
const requestService = require('services/request.service');

router.get('/byUid/:uid', getByUserId);

function getByUserId(req, res, next) {
    requestService.getByUserId(req.params.uid)
        .then(requests => requests ? res.json(requests) : res.sendStatus(404))
        .catch(err => next(err));
}

module.exports = router;