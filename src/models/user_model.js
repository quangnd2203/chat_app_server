const { json } = require("express");
const mongoose = require("mongoose");

const schema = new mongoose.Schema({
    name: { type: String, require: [true, 'name is required'], trim: true },
    email: { type: String, require: [true, 'email is required'], trim: true, unique: true },
    password: { type: String, trim: true },
    accountType: { type: String, enum: ['normal', 'google', 'facebook'], require: [true, 'accountType is required'], trim: true },
    avatar: { type: String, trim: true },
    background: { type: String, trim: true },
    accessToken: { type: String, trim: true },
    fcmToken: { type: String, trim: true },
}, {
    timestamps: true,
    statics: {
        fromJson (json) {
            return {
                uid: json._id,
                name: json.name,
                avatar: json.avatar,
                background: json.background,
                createdAt: json.createdAt,
                updatedAt: json.updatedAt,
            }
        },
    
        async register (name, email, password, type, accessToken){
            try {
                const user = await this.create({
                    name: name,
                    email: email,
                    password: password,
                    accountType: type,
                    avatar: null,
                    background: null,
                    accessToken: accessToken,
                    fcmToken: null,
                });
                return user;
            } catch (err) {
                console.log(err);
                throw Error('user already exists');
            }
    
        },
    
        async login (email, password, accountType, accessToken){
            const user = await this.findOneAndUpdate({
                email: email,
                password: password,
                accountType,
            }, {
                accessToken: accessToken,
            });
            if (user == null) throw Error('ivalid_user');
            return user;
        },
    
        updateFcmToken (_id, fcmToken){
            this.updateMany({fcmToken: fcmToken,}, {fcmToken: null});
            this.findByIdAndUpdate(_id, {fcmToken: fcmToken});
        }
    },
});

module.exports = mongoose.model('UserModel', schema);