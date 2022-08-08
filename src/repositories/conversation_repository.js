const sqlConnection = require('../configs/sql_connection');
const ConversationModel = require('../models/conversation_model');
const UserModel = require('../models/user_model');
const NetworkResponse = require('../models/network_response');

module.exports.createConversation = async (uid, partnerUid) => {
    const result = await sqlConnection.query('CALL `conversationCreate`(?,?);', [uid, partnerUid]);
    if((result?.length || 0) == 0) throw Error('ivalid_conversation'); 
    result[0].users = JSON.parse(result[0].users);
    return new NetworkResponse(
        1,
        null,
        new ConversationModel(
            result[0].id,
            null,
            result[0].users.map(u => new UserModel(
                u.id,
                u.uid,
                u.name,
                u.email,
                u.accountType,
                u.avatar,
                u.background,
                u.created_at,
                u.updated_at,
            )),
        ),
    )
}

module.exports.getAllConversation = async (uid) => {
    var result = await sqlConnection.query('CALL `conversationGetAll`(?);', [uid]);
    result = result.map(conversation => {
        conversation.users = JSON.parse(conversation.users);
        conversation.lastMessage = JSON.parse(conversation.lastMessage || null);
        return conversation;
    });
    return result;
}