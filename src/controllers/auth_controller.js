const NetworkResponse = require('../models/network_response');
const UserModel = require('../models/user_model');
const authRepository = require('../repositories/auth_repository');
const socialRepository = require('../repositories/social_repository');
const utils = require('../utils/utils');

module.exports.loginNormal = async (email, password, fcmToken) => {
    try {
        const hashPass = utils.hashPassword(password);
        const user = await authRepository.login(email, hashPass, fcmToken);
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
        return NetworkResponse.fromErrors(e.message || 'wrong_email_or_pass');
    }
};

module.exports.register = async (name, email, password, type, fcmToken) => {
    try{
        let hassPass = null;
        if(!password) hassPass = utils.hashPassword(password);
        const data = await authRepository.register(name, email, password, type, fcmToken);
        let response = new NetworkResponse(
            1,
            null,
            {
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
            }
        );
        return response;
    } catch (e) {
        console.log(e);
        return NetworkResponse.fromErrors(e.message || 'cant_register');
    }
}

module.exports.loginSocial = async (socialToken, accountType, fcmToken) => {
    try{
        const socialUser = await socialRepository.getUserGoogleInfo(socialToken);
        const user = await authRepository.loginSocical(socialUser.name, socialUser.id.toString(), accountType, fcmToken);
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
            }
        )
    } catch (e) {
        console.log(e);
        return NetworkResponse.fromErrors(e.message || 'cant_get_user');
    }
}