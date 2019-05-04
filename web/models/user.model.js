const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const schema = new Schema({
    _id: { type: String },
    name: { type: String },
    uid: { type: String, unique: true, required: true }, // firebase authentication
    identifier: { type: String, required: true }, // email or phone
    fcm_token: { type: String, required: true }, // firebase cloud messaging
    location: {
        type: { type: String, default: 'Point' },
        coordinates: { type: [Number], required: true } // Longitude first then Lattitude
    }
});

module.exports = mongoose.model('User', schema);