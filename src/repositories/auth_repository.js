// const sqlConnection = require('../configs/sql_connection');
const utils = require('../utils/utils');
const NetworkResponse = require('../models/network_response');
const UserModel = require('../models/user_model');

module.exports.login = async (email, password, fcmToken, accountType = 'normal') => {
    // const accessToken = utils.generateJWT(email);
    // const users = await sqlConnection.query('CALL `userLogin`(?,?,?,?);', [email, password, accountType, accessToken]);
    // if ((users?.length || 0) == 0) throw Error('ivalid_user');
    // // await sqlConnection.query('CALL `userUpdateFcmToken`(?,?);', [users[0].uid, fcmToken]);
    // return new NetworkResponse(
    //     1,
    //     null,
    //     {
    //         user: UserModel.fromJson(users[0]),
    //         accessToken: users[0].accessToken,
    //     },
    // );
}

module.exports.authorized = async (email, token,) => {
    // // const users = await sqlConnection.query('CALL `userAuthorize`(?,?);', [email, token]);
    // const users = null;
    // if ((users?.length || 0) == 0) throw Error('ivalid_user');
    // return new NetworkResponse(
    //     1,
    //     null,
    //     {
    //         user: UserModel.fromJson(users[0]),
    //         accessToken: users[0].accessToken,
    //     },
    // );
}

module.exports.register = async (name, email, password, type, fcmToken) => {
    // const accessToken = utils.generateJWT(email);
    // // const users = await sqlConnection.query('CALL `userRegister`(?,?,?,?,?, @message, @status)', [name, email, password, type, accessToken]);
    // const users = null;
    // // const recordStatus = await sqlConnection.query('CALL `systemGetStatus`(@message, @status)');
    // const recordStatus = null;
    // if (!recordStatus || recordStatus[0].status == 0) throw Error(recordStatus[0].message || 'ivalid_user');
    // await sqlConnection.query('CALL `userUpdateFcmToken`(?,?);', [users[0].uid, fcmToken]);
    // return new NetworkResponse(
    //     1,
    //     null,
    //     {
    //         user: UserModel.fromJson(users[0]),
    //         accessToken: users[0].accessToken,
    //     },
    // );
}


module.exports.loginSocical = async (name, socialId, accountType, fcmToken) => {
    // var response;
    // try{
    //     response = await this.login(socialId, null, fcmToken, accountType);
    // }catch(e){
    //     response = await this.register(name, socialId, null, accountType, fcmToken);
    // }
    // return response;
}