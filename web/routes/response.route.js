const express = require('express');
const router = express.Router();
const responseService = require('services/response.service');

const upload = require('services/multer.service');
const singleUpload = upload.single('image')

router.get('/byQuestionId/:id', getByQuestionId);

router.post('/create', function(req, res) {
    singleUpload(req, res, function(err, some) {
        if (err) {
            return res.status(422).send({errors: [{title: 'Image Upload Error', detail: err.message}] });
        }

        req.body.image_link = req.file.location;

        responseService.create(req.body)
            .then((result) => res.json(result))
            .catch(err => next(err));
    });
})

function getByQuestionId(req, res, next) {
    responseService.getByQuestionId(req.params.id)
        .then(responses => responses ? res.json(responses) : res.sendStatus(404))
        .catch(err => next(err));
}



module.exports = router;