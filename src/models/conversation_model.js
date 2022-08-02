/**
 * @param {Number} id 
 * @param {Object} lastMessage
 * @param {Array} users
 * @param {Date} createdAt
 * @param {Date} updatedAt
 */

 function ConversationModel(id, lastMessage, users, createdAt, updatedAt){
    this.id = id;
    this.lastMessage = lastMessage;       
    this.users = users;
    this.createAt = createdAt;
    this.updateAt = updatedAt;
}

module.exports = ConversationModel;