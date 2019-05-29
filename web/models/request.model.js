const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    user: { type: Schema.Types.String, ref: 'User', required: true },
    question_id: { type: Schema.Types.ObjectId, ref: 'Question', required: true },
    question: { type: String, required: true }
});

module.exports = mongoose.model('Request', schema);