const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    name: { type: String, required: true },
    email: { type: String, unique: true, required: true },
    is_admin: { type: Boolean, default: false, required: true },
    fcm_token: { type: String },
    location: {
        type: {
            type: String,
            enum: ['Point'],
            required: true
        },
        coordinates: {
            type: [Number],
            required: true
        }
    }
});

module.exports = mongoose.model('User', schema);
