const sqlConnection = require('../configs/sql_connection');

module.exports.createConversation = async (uid, partnerUid) => {
    const result = await sqlConnection.query('CALL `conversationCreate`(?,?,@message,@status);', [uid, partnerUid]);
    const recordStatus = await sqlConnection.query('CALL `systemGetStatus`(@message, @status)');
    if(!recordStatus || recordStatus[0].status == 0) throw Error(recordStatus[0].message || 'ivalid_user');
    if((result?.length || 0) == 0) throw Error('ivalid_conversation'); 
    return result;
}