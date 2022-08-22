const mongoose = require("mongoose");

const { ObjectId } = mongoose.Schema;

const schema = new mongoose.Schema({
    id: { type: Number, require: true, },
    uid: { type: String, require: true, trim: true, },
    name: { type: String, require: [true, 'name is required'], trim: true, },
    email: { type: String, require: [true, 'email is required'], trim: true, },
    password: { type: String, trim: true, },
    accountType: { type: String, enum: ['normal', 'google', 'facebook'], require: [true, 'accountType is required'], trim: true, },
    avatar: { type: String, trim: true, },
    background: { type: String, trim: true, },
    accessToken: { type: String, trim: true, },
    fcmToken: { type: String, trim: true, },
}, {
    timestamps: true,
});

module.exports = mongoose.model('UserModel', schema);