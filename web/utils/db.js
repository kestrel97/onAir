const mongoose = require('mongoose');
mongoose.connect(process.env.MONGODB_STRING, { useCreateIndex: true, useNewUrlParser: true });
mongoose.Promise = global.Promise;

module.exports = {
    User: require('models/user.model'),
    Question: require('models/question.model'),
    Response: require('models/response.model'),
    Invite: require('models/invite.model'),
    Request: require('models/request.model')
};