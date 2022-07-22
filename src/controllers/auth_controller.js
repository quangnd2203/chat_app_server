const NetworkResponse = require('../models/network_response');
const UserModel = require('../models/user_model');
const authRepository = require('../repositories/auth_repository');
const utils = require('../utils/utils');

module.exports.loginNormal = async (email, password) => {
    try {
        const hashPass = utils.hashPassword(password);
        const u = await authRepository.loginNormal(email, hashPass);
        return new NetworkResponse(
            status = 1,
            message = null,
            data = {
                user: new UserModel(
                    u.id,
                    u.uid,
                    u.name,
                    u.email,
                    u.accountType,
                    u.avatar,
                    u.background,
                    u.created_at,
                    u.updated_at,
                ),
                accessToken : u.accessToken,
            },
        );
    } catch (e) {
        console.log(e);
        return NetworkResponse.fromErrors('cant_find_users');
    }
};