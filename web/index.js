require('rootpath')();
const serverless = require('serverless-http');

const express = require('express');
const app = express();

const bodyParser = require('body-parser');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

const helmet = require('helmet');
app.use(helmet());

const cors = require('cors');
app.use(cors());

function logResponseBody(req, res, next) {
  var oldWrite = res.write,
      oldEnd = res.end;

  var chunks = [];

  res.write = function (chunk) {
    chunks.push(chunk);

    oldWrite.apply(res, arguments);
  };

  res.end = function (chunk) {
    if (chunk)
      chunks.push(chunk);

    var body = Buffer.concat(chunks).toString('utf8');
    console.log(req.path, body);

    oldEnd.apply(res, arguments);
  };

  next();
}

// app.use(logResponseBody);

app.use(express.static('public'));

// api routes
app.use('/api/users', require('routes/user.route'));
app.use('/api/questions', require('routes/question.route'));
app.use('/api/responses', require('routes/response.route'));
app.use('/api/requests', require('routes/request.route'));

app.get('/', function (req, res) {
  res.send('Hello World!');
})

const server = app.listen(3000, function () {
  console.log('Server listening on port ' + 3000);
});


// module.exports.handler = serverless(app, {
//   binary: ['image/png', 'image/gif']
// });
