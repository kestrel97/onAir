const mongoose = require('mongoose');
mongoose.connect("mongodb://localhost:27017/onair", { useCreateIndex: true, useNewUrlParser: true });
mongoose.Promise = global.Promise;

module.exports = {
    User: require('models/user.model'),
    Question: require('models/question.model'),
    Response: require('models/response.model'),
    Invite: require('models/invite.model'),
    Request: require('models/request.model')
};