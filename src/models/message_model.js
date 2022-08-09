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

function MessageModel(id, conversationId, text, media, user, createAt, updateAt){
    this.id = id;
    this.conversationId = conversationId;
    this.text = text;
    this.media = media;
    this.user = user;
    this.createAt = createAt;
    this.updateAt = updateAt;
}

MessageModel.fromJson = (json) => new MessageModel(
    json.id,
    json.conversationId,
    json.text,
    json.media,
    json.user != null ? UserModel.fromJson(json.user) : null,
    json.created_at,
    json.updated_at,
);

module.exports = MessageModel;