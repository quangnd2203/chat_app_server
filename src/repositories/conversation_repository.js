const sqlConnection = require('../configs/sql_connection');

module.exports.createConversation = async (uid, partnerUid) => {
    const result = await sqlConnection.query('CALL `conversationCreate`(?,?,@message,@status);', [uid, partnerUid]);
    const recordStatus = await sqlConnection.query('CALL `systemGetStatus`(@message, @status)');
    if(!recordStatus || recordStatus[0].status == 0) throw Error(recordStatus[0].message || 'ivalid_user');
    if((result?.length || 0) == 0) throw Error('ivalid_conversation'); 
    result[0].users = JSON.parse(result[0].users);
    return result[0];
}

module.exports.getConversationByUid = async (uid, partnerUid) => {
    const result = await sqlConnection.query('CALL `conversationGetByUid`(?,?);', [uid, partnerUid]);
    if((result?.length || 0) == 0) throw Error('ivalid_conversation'); 
    result[0].users = JSON.parse(result[0].users);
    return result[0];
}

module.exports.getConversation = async (uid, partnerUid) => {
    var result;
    try{
        result = await this.getConversationByUid(uid, partnerUid);
    } catch(e){
        result = await this.createConversation(uid, partnerUid);
    }
    console.log(result);
    return result;
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