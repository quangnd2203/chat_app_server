const sqlConnection = require('../configs/sql_connection');
const ConversationModel = require('../models/conversation_model');
const UserModel = require('../models/user_model');
const NetworkResponse = require('../models/network_response');
const MessageModel = require('../models/message_model');

module.exports.createConversation = async (uid, partnerUid) => {
    const result = await sqlConnection.query('CALL `conversationCreate`(?,?);', [uid, partnerUid]);
    if ((result?.length || 0) == 0) throw Error('ivalid_conversation');
    result[0].users = JSON.parse(result[0].users);
    if (result[0].lastMessage != null) {
        result[0].lastMessage = JSON.parse(result[0].lastMessage);
        result[0].lastMessage.user = JSON.parse(result[0].lastMessage.user);
    }
    return new NetworkResponse(
        1,
        null,
        ConversationModel.fromJson(result[0]),
    );
}

module.exports.getAllConversation = async (uid, limit, offset) => {
    const result = await sqlConnection.query('CALL `conversationGetAll`(?,?,?);', [uid, limit || 15, offset || 0]);
    return new NetworkResponse(
        1,
        null,
        result.map(c => {
            c.users = JSON.parse(c.users);
            if(c.lastMessage != null){
                c.lastMessage = JSON.parse(c.lastMessage);
                c.lastMessage.user = JSON.parse(c.lastMessage.user);
            }
            return ConversationModel.fromJson(c);
        })
    );
}

module.exports.getMessagesByConversationId = async (conversationId, limit, offset) => {
    const result = await sqlConnection.query('CALL `messageGetByConversationId`(?,?,?);', [conversationId, limit || 15, offset || 0]);
    return new NetworkResponse(
        1,
        null,
        result.map(m => {
            m.user = JSON.parse(m.user);
            return MessageModel.fromJson(m);
        }),
    );
}

module.exports.getConversationById = async (conversationId) => {
    const result = await sqlConnection.query('CALL `getConversationById`(?);', [conversationId]);
    if ((result?.length || 0) == 0) throw Error('ivalid_conversation');
    result[0].users = JSON.parse(result[0].users);
    if (result[0].lastMessage != null) {
        result[0].lastMessage = JSON.parse(result[0].lastMessage);
        result[0].lastMessage.user = JSON.parse(result[0].lastMessage.user);
    }
    return new NetworkResponse(
        1,
        null,
        ConversationModel.fromJson(result[0]),
    );
}

module.exports.getConversationUsers = async (conversationId) => {
    const result = await sqlConnection.query('CALL `conversationGetUsers`(?);', [conversationId]);
    if ((result?.length || 0) == 0) throw Error('cant_send_message');
    return new NetworkResponse(
        1,
        null,
        result.map(u => UserModel.fromJson(u)),
    );
}

module.exports.createMessage = async (conversationId, uid, text, media) => {
    const result = await sqlConnection.query('CALL `messageCreate`(?, ?, ?, ?);', [conversationId, uid, text, media]);
    if ((result?.length || 0) == 0) throw Error('cant_send_message');
    if (result[0].user != null) {
        result[0].user = JSON.parse(result[0].user);
    }
    return new NetworkResponse(
        1,
        null,
        MessageModel.fromJson(result[0])
    );
}