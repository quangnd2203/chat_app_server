/**
 * @param {Number} id 
 * @param {MessageModel} lastMessage
 * @param {Array<UserModel>} users
 * @param {Date} createdAt
 * @param {Date} updatedAt
 */

const MessageModel = require("./message_model");
const UserModel = require("./user_model");

function ConversationModel(id, lastMessage, users, createdAt, updatedAt){
    this.id = id;
    this.lastMessage = lastMessage;       
    this.users = users;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
}

ConversationModel.fromJson = (json) => new ConversationModel(
    json.id,
    json.lastMessage != null ? MessageModel.fromJson(json.lastMessage) : null,
    json.users != null ? json.users.map(u => UserModel.fromJson(u)) : [],
    json.createdAt,
    json.updatedAt,
);

module.exports = ConversationModel;