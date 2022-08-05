const sqlConnection = require('../configs/sql_connection');

module.exports.createConversation = async (uid, partnerUid) => {
    const result = await sqlConnection.query('CALL `conversationCreate`(?,?);', [uid, partnerUid]);
    if((result?.length || 0) == 0) throw Error('ivalid_conversation'); 
    result[0].users = JSON.parse(result[0].users);
    return result[0];
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