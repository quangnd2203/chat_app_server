const sqlConnection = require('../configs/sql_connection');

module.exports.createConversation = async () => {
    const result = await sqlConnection.query('CALL `conversationCreate`(?,?);', ['uid-41eb2d84-0f0f-11ed-903b-c6ef0857e0cf', 'uid-41ef215a-0f0f-11ed-903b-c6ef0857e0cf']);
    
}