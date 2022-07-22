const NetworkResponse = require('../models/network_response');
const UserModel = require('../models/user_model');
const userRepository = require('../repositories/user_repository');

module.exports.getUser = async () => {
    try {
        const users = await userRepository.getUser();
        return new NetworkResponse(
            status = 1,
            message = null,
            data = users.map(u => new UserModel(
                u.id,
                u.uid,
                u.name,
                u.email,
                u.accountType,
                u.avatar,
                u.background,
                u.created_at,
                u.updated_at,
            )),
        );
    } catch (e) {
        console.log(e);
        return NetworkResponse.fromErrors('cant_find_users');
    }
};
