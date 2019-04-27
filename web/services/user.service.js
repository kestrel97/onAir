const constants = require('utils/constants');
const db = require('utils/db');
const User = db.User;

async function create(userParam) {

    if (! userParam.location || ! userParam.location.coordinates) {
        return ( { success: false, message: constants.USER_REGISTRATION_FAILED } )
    }

    if (await User.findOne({ email: userParam.email })) {
        return ( { success: false, message: constants.USER_EMAIL_ALREADY_TAKEN } )
    }

    const user = new User(userParam);

    try {
        await user.save();
    } catch {
        return ( { success: false, message: constants.USER_REGISTRATION_FAILED } )
    }

    return ( { success: true, message: constants.USER_REGISTERED_SUCCESSFULLY } )
}

async function update(userParam) {
    if (! userParam.email) {
        return ( { success: false, message: constants.USER_UPDATE_FAILED } )
    }

    const user = await User.findOne({ email: userParam.email });

    if (! user) {
        return ( { success: false, message: constants.USER_NOT_FOUND } )
    }

    Object.assign(user, userParam);

    await user.save();
}

module.exports = {
    create,
    update
};
