const sqlConnection = require('../configs/sql_connection');
const utils = require('../utils/utils');

module.exports.loginNormal = async (email, password) => {
    const accessToken = utils.generateJWT(email);
    const users = await sqlConnection.query('CALL `userLoginNormal`(?,?,?);', [email, password, accessToken]);
    return users[0];
}

module.exports.authorize = async (email, token) => {
    const users = await sqlConnection.query('CALL `userAuthorize`(?,?);', [email, token]);
    return users[0];
}

module.exports.register = async (name, email, password, type, fcmToken) => {
    const accessToken = utils.generateJWT(email);
    const users = await sqlConnection.query('CALL `userRegister`(?,?,?,?,?,?, @message, @status)', [name, email, password, type, accessToken, fcmToken,]);
    const recordStatus = await sqlConnection.query('CALL `systemGetStatus`(@message, @status)');
    return {
        user: (users != null) ? users[0] : null,
        status: recordStatus[0],
    };
}