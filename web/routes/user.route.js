const express = require('express');
const router = express.Router();
const userService = require('services/user.service');

router.post('/update', update);

function update(req, res, next) {
    console.log(req.body);
    userService.update(req.body)
        .then((result) => res.json(result))
        .catch(err => next(err));
}

module.exports = router;