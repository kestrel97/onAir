const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    sender: { type: Schema.Types.String, ref: 'User', required: true },
    question: { type: Schema.Types.ObjectId, ref: 'Question', required: true },
    response: { type: String, required: true },
    image_link: { type: String, required: true }
});

module.exports = mongoose.model('Response', schema);