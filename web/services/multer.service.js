const multer = require('multer');
const multerS3 = require('multer-s3');
const aws = require('aws-sdk');
const mime = require('mime');

aws.config.update({
    secretAccessKey: "/4IXXs/h2zO417PnxuKzEPakRv4ijxb2l9s5XEqn",
    accessKeyId: "AKIAXVFMVVXL7QLBIHWD",
    region: 'us-east-1'
});

const s3 = new aws.S3();

const upload = multer({
  storage: multerS3({
    s3: s3,
    bucket: 'on-air-images',
    acl: 'public-read',
    contentType: multerS3.AUTO_CONTENT_TYPE,
    metadata: function (req, file, cb) {
      cb(null, {fieldName: file.fieldname});
    },
    key: function (req, file, cb) {
      cb(null, Date.now().toString() + '.' + mime.getExtension(file.mimetype));
    }
  }),
  fileFilter: function (req, file, callback) {
    var ext = mime.getExtension(file.mimetype);
    if(ext !== 'png' && ext !== 'jpg' && ext !== 'gif' && ext !== 'jpeg') {
        return callback(new Error('Only images are allowed'))
    }
    callback(null, true)
  },
  limits:{
      fileSize: 1024 * 1024 * 10
  }
})
  
  module.exports = upload;