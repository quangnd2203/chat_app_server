const sqlConnection = require('../configs/sql_connection');

module.exports.loginNormal = async (email, password) => {
    const users = await sqlConnection.query('CALL `userLoginNormal`(?,?);', [email, password]);
    return users[0];
}