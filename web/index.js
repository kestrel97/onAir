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

// api routes
app.use('/api/users', require('routes/user.route'));
app.use('/api/questions', require('routes/question.route'));
app.use('/api/responses', require('routes/response.route'));

app.get('/', function (req, res) {
  res.send('Hello World!');
})

const server = app.listen(3000, function () {
  console.log('Server listening on port ' + 3000);
});


// module.exports.handler = serverless(app, {
//   binary: ['image/png', 'image/gif']
// });