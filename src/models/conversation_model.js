// /**
//  * @param {Number} id 
//  * @param {MessageModel} lastMessage
//  * @param {Array<UserModel>} users
//  * @param {Date} createdAt
//  * @param {Date} updatedAt
//  */

// const MessageModel = require("./message_model");
// const UserModel = require("./user_model");

// function ConversationModel(id, lastMessage, users, createdAt, updatedAt){
//     this.id = id;
//     this.lastMessage = lastMessage;       
//     this.users = users;
//     this.createdAt = createdAt;
//     this.updatedAt = updatedAt;
// }

// ConversationModel.fromJson = (json) => new ConversationModel(
//     json.id,
//     json.lastMessage != null ? MessageModel.fromJson(json.lastMessage) : null,
//     json.users != null ? json.users.map(u => UserModel.fromJson(u)) : [],
//     new Date(`${json.createdAt}`),
//     new Date(`${json.updatedAt}`),
// );

// module.exports = ConversationModel;

const mongoose = require("mongoose");

const { ObjectId } = mongoose.Schema;

const schema = new mongoose.Schema({
    id: { type: Number, require: true},
    users: [{ type: ObjectId, ref: 'UserModel'}],
    lastMessage: { type: ObjectId, ref: 'MessageModel'},
}, {
    timestamps: true,
});

module.exports = mongoose.model('ConversationModel', schema);