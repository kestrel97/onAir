const constants = require('utils/constants');
const db = require('utils/db');
const Response = db.Response;

async function create(responseParams) {
    const response = Response(responseParams);

    try {
        await response.save();
    } catch (e) {
        console.log(e);
        return ( { success: false, message: constants.RESPONSE_CREATION_FAILED } )
    }

    return ( { success: true, message: constants.RESPONSE_CREATED_SUCCESSFULLY } )
}

async function getByQuestionId(question_id) {
    return Response.findOne({ question: question_id });
}

module.exports = {
    create,
    getByQuestionId
}