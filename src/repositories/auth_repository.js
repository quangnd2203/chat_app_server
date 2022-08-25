// const sqlConnection = require('../configs/sql_connection');
const utils = require('../utils/utils');
const NetworkResponse = require('../models/network_response');
const UserModel = require('../models/user_model');

module.exports.login = async (email, password, fcmToken, accountType = 'normal') => {
    const accessToken = utils.generateJWT(email);
    const user = await UserModel.findOne({
        email: email,
        password: password,
        fcmToken: fcmToken,
        accountType: accountType
    });
    if (user == null) throw Error('ivalid_user');
    return new NetworkResponse(
        1,
        null,
        {
            user: UserModel.fromJson(user),
            accessToken: null,
        },
    );
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
    const accessToken = utils.generateJWT(email);
    const user = await UserModel.register(name, email, password, type, fcmToken);
    return new NetworkResponse(
        1,
        null,
        {
            user: UserModel.fromJson(user),
            accessToken: null,
        },
    );
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