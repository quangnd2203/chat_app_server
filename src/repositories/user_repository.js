const sqlConnection = require('../configs/sql_connection');

module.exports.getUser = async (request) => {
    const users = await sqlConnection.query('CALL `userGetAll`(?,?,?);', [request.user.uid, request.query.limit || 10, request.query.offset || 0]);
    return users;
};
