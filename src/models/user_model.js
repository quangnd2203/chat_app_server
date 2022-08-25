const { json } = require("express");
const mongoose = require("mongoose");
const untils = require('../utils/utils');

const schema = new mongoose.Schema({
    uid: { type: String, require: true, trim: true, unique: true},
    name: { type: String, require: [true, 'name is required'], trim: true },
    email: { type: String, require: [true, 'email is required'], trim: true, unique: true},
    password: { type: String, trim: true },
    accountType: { type: String, enum: ['normal', 'google', 'facebook'], require: [true, 'accountType is required'], trim: true },
    avatar: { type: String, trim: true },
    background: { type: String, trim: true },
    accessToken: { type: String, trim: true },
    fcmToken: { type: String, trim: true },
}, {
    timestamps: true,
    statics: {
        fromJson (json){
            return {
                uid: json.uid,
                name: json.name,
                avatar: json.avatar,
                background: json.background,
                createdAt: json.createdAt,
                updatedAt: json.updatedAt,
            }
        },

        register (name, email, password, type, fcmToken){
            return this.create({
                uid: untils.generateUUID(),
                name: name,
                email: email,
                password: password,
                accountType: type,
                avatar: null,
                background: null,
                fcmToken: fcmToken,
                accessToken: null,
            }).catch((err) => {
                throw Error('user already exists');
            });
        }
    }
});

var UserModel = mongoose.model('UserModel', schema);

module.exports = UserModel;