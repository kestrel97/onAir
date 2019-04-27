const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    question: { type: String, required: true },
    location: {
        type: {type: String, default: 'Point'},
        coordinates: {type: [Number], default: [0, 0]}
    }
});

module.exports = mongoose.model('Question', schema);