const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    sender: { type: Schema.Types.String, ref: 'User', required: true },
    mobile_no: { type: String, required: true }
});

module.exports = mongoose.model('Invite', schema);