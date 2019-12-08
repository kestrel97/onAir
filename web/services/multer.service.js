const multer = require('multer');
const multerS3 = require('multer-s3');
const mime = require('mime');

const upload = multer({
  storage: multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, 'public/')
    },
    filename: function (req, file, cb) {
      cb(null, file.fieldname + '-' + Date.now() + '.jpg');
    }
  }),
  fileFilter: function (req, file, callback) {
    var ext = mime.getExtension(file.mimetype);
    if(ext !== 'png' && ext !== 'jpg' && ext !== 'gif' && ext !== 'jpeg' && ext !== 'bin') {
        return callback(new Error('Only images are allowed'))
    }
    callback(null, true)
  },
  limits:{
      fileSize: 1024 * 1024 * 10
  }
})

  module.exports = upload;