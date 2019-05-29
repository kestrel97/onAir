const constants = require('utils/constants');
const db = require('utils/db');
const Request = db.Request;

async function getByUserId(uid) {
    var requests = await Request.find({ user: uid });

    for (var i = 0; i < requests.length; i++) {
        requests[i]._id = requests[i].question_id;
    }

    return requests;
}

module.exports = {
    getByUserId
}