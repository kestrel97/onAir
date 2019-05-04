const express = require('express');
const router = express.Router();
const responseService = require('services/response.service');

const upload = require('services/multer.service');
const singleUpload = upload.single('image')

router.get('/byQuestionId/:id', getByQuestionId);
router.post('/create', create);

function create(req, res, next) {
    responseService.create(req.body)
        .then((result) => res.json(result))
        .catch(err => next(err));
}

function getByQuestionId(req, res, next) {
    responseService.getByQuestionId(req.params.id)
        .then(responses => responses ? res.json(responses) : res.sendStatus(404))
        .catch(err => next(err));
}

router.post('/image-upload', function(req, res) {
    singleUpload(req, res, function(err, some) {
        if (err) {
            return res.status(422).send({errors: [{title: 'Image Upload Error', detail: err.message}] });
        }

        return res.json({'imageUrl': req.file.location});
    });
})

module.exports = router;