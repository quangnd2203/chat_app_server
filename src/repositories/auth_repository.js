const sqlConnection = require('../configs/sql_connection');
const utils = require('../utils/utils');

module.exports.login = async (email, password, fcmToken, accountType = 'normal') => {
    const accessToken = utils.generateJWT(email);
    const users = await sqlConnection.query('CALL `userLogin`(?,?,?,?);', [email, password, accountType , accessToken]);
    if((users?.length || 0) == 0) throw Error('ivalid_user'); 
    await sqlConnection.query('CALL `userUpdateFcmToken`(?,?);', [users[0].uid, fcmToken]);
    return users[0];
}

module.exports.authorized = async (email, token,) => {
    const users = await sqlConnection.query('CALL `userAuthorize`(?,?);', [email, token]);
    if((users?.length || 0) == 0) throw Error('ivalid_user'); 
    return users[0];
}

module.exports.register = async (name, email, password, type, fcmToken) => {
    const accessToken = utils.generateJWT(email);
    const users = await sqlConnection.query('CALL `userRegister`(?,?,?,?,?, @message, @status)', [name, email, password, type, accessToken]);
    const recordStatus = await sqlConnection.query('CALL `systemGetStatus`(@message, @status)');
    if(!recordStatus || recordStatus[0].status == 0) throw Error(recordStatus[0].message || 'ivalid_user');
    await sqlConnection.query('CALL `userUpdateFcmToken`(?,?);', [users[0].uid, fcmToken]);
    return users[0];
}


module.exports.loginSocical = async (name, socialId, accountType, fcmToken) => {
    var user;
    try{
        user = await this.login(socialId, null, fcmToken, accountType);
    } catch(e){
        user = await this.register(name, socialId, null, accountType, fcmToken);
    }
    return user;
}