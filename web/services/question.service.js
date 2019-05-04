const constants = require('utils/constants');
const db = require('utils/db');
const Question = db.Question;

async function create(userParam) {
    if (userParam.location == undefined || userParam.location.coordinates == undefined) {
        return ( { success: false, message: constants.QUESTION_CREATION_FAILED } );
    }

    const question = new Question(userParam);

    try {
        await question.save();
    } catch {
        return ( { success: false, message: constants.QUESTION_CREATION_FAILED } )
    }

    return ( { success: true, message: constants.QUESTION_CREATED_SUCCESSFULLY } )
}

async function getByUserId(uid) {
    return Question.find({ user: uid });
}

module.exports = {
    create,
    getByUserId
};