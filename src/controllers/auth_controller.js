const NetworkResponse = require('../models/network_response');
const UserModel = require('../models/user_model');
const authRepository = require('../repositories/auth_repository');
const utils = require('../utils/utils');

module.exports.loginNormal = async (email, password) => {
    try {
        const hashPass = utils.hashPassword(password);
        const user = await authRepository.loginNormal(email, hashPass);
        return new NetworkResponse(
            1,
            null,
            {
                user: new UserModel(
                    user.id,
                    user.uid,
                    user.name,
                    user.email,
                    user.accountType,
                    user.avatar,
                    user.background,
                    user.created_at,
                    user.updated_at,
                ),
                accessToken: user.accessToken,
            },
        );
    } catch (e) {
        console.log(e);
        return NetworkResponse.fromErrors('cant_find_users');
    }
};

module.exports.register = async (name, email, password, type, fcmToken) => {
    try{
        let hassPass = null;
        if(!password) hassPass = utils.hashPassword(password);
        const data = await authRepository.register(name, email, password, type, fcmToken);
        let response = new NetworkResponse(
            data.status.status,
            data.status.message,
        );
        if(response.status == 1){
            response.data = {
                user: new UserModel(
                    data.user.id,
                    data.user.uid,
                    data.user.name,
                    data.user.email,
                    data.user.accountType,
                    data.user.avatar,
                    data.user.background,
                    data.user.created_at,
                    data.user.updated_at,
                ),
                accessToken: data.user.accessToken,
            };
        }
        return response;
    } catch (e) {
        console.log(e);
        return NetworkResponse.fromErrors('cant_register');
    }
}