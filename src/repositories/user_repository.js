const sqlConnection = require('../configs/sql_connection');

module.exports.getUser = async (uid) => {
    const users = await sqlConnection.query('CALL `userGetAll`(?);', [uid]);
    return users;
};
