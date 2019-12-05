const constants = require('utils/constants');
const db = require('utils/db');
const User = db.User;

async function update(userParam) {
    console.log("update response goes here",userParam, "to here///")

    if (! userParam.uid) {
        return ( { success: false, message: constants.USER_UPDATE_FAILED } )
    }

    userParam._id = userParam.uid;
    const user = await User.findOne({ uid: userParam.uid });

    userParam.location.type = "Point";

    if (user) {
        Object.assign(user, userParam);

        try {
            await user.save();
        } catch {
            return ( { success: false, message: constants.USER_UPDATE_FAILED } )
        }
    
        return ( { success: true, message: constants.USER_UPDATED_SUCCESSFULLY } )
    } else {
        const user = new User(userParam);

        try {
            await user.save();
        } catch (e) {
            console.log(e);
            return ( { success: false, message: constants.USER_REGISTRATION_FAILED } )
        }

        return ( { success: true, message: constants.USER_REGISTERED_SUCCESSFULLY } )
    }
}

module.exports = {
    update
};
