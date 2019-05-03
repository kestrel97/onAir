const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    question: { type: String, required: true },
    location: {
        type: {type: String, default: 'Point'},
        coordinates: { type: [Number], required: true }
    }
});

module.exports = mongoose.model('Question', schema);