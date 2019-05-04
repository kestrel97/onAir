const constants = require('utils/constants');
const db = require('utils/db');
const Response = db.Response;


async function create(responseParams) {
    const response = Response(responseParams);
}

async function getByQuestionId(question_id) {
    return Response.find({ question: question_id });
}

module.exports = {
    getByQuestionId
}