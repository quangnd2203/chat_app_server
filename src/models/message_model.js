const UserModel = require("./user_model");
/**
 * @param {Number} id
 * @param {Number} conversationId
 * @param {String} text
 * @param {String} media
 * @param {UserModel} user
 * @param {Date} createdAt
 * @param {Date} updatedAt
 */

function MessageModel(id, conversationId, text, media, user, createdAt, updatedAt){
    this.id = id;
    this.conversationId = conversationId;
    this.text = text;
    this.media = media;
    this.user = user;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
}

MessageModel.fromJson = (json) => new MessageModel(
    json.id,
    json.conversationId,
    json.text,
    json.media,
    json.user != null ? UserModel.fromJson(json.user) : null,
    new Date(`${json.createdAt}`),
    new Date(`${json.updatedAt}`),
);

module.exports = MessageModel;