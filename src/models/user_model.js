const mongoose = require("mongoose");
const AutoIncrement = require('mongoose-sequence')(mongoose);
const { ObjectId } = mongoose.Schema;
const untils = require('../utils/utils');

const schema = new mongoose.Schema({
    id: { type: Number },
    uid: { type: String, require: true, trim: true },
    name: { type: String, require: [true, 'name is required'], trim: true },
    email: { type: String, require: [true, 'email is required'], trim: true },
    password: { type: String, trim: true },
    accountType: { type: String, enum: ['normal', 'google', 'facebook'], require: [true, 'accountType is required'], trim: true },
    avatar: { type: String, trim: true },
    background: { type: String, trim: true },
    accessToken: { type: String, trim: true },
    fcmToken: { type: String, trim: true },
}, {
    timestamps: true,
});

schema.static.createNewUser = (data) => {
    const user = new UserModel({
        uid: untils.generateUUID(),
        name: data.name,
        email: data.email,
        password: data.password,
        accountType: data.accountType,
        avatar: data.avatar,
        background: data.background,
        accessToken: data.accessToken,
        fcmToken: data.fcmToken,
    });
    return user.save();
}

const UserModel = mongoose.model('UserModel', schema);

module.exports = UserModel;