const express = require('express');
const router = express.Router();
const userService = require('services/user.service');

// router.post('/register', register);
router.post('/update', update);

// function register(req, res, next) {
//     userService.create(req.body)
//         .then((result) => res.json(result))
//         .catch(err => next(err));
// }

function update(req, res, next) {
    userService.update(req.body)
        .then((result) => res.json(result))
        .catch(err => next(err));
}

module.exports = router;