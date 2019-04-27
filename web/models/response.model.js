const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    question: { type: Schema.Types.ObjectId, ref: 'Question', required: true },
    response: { type: String, required: true }
});

module.exports = mongoose.model('Response', schema);