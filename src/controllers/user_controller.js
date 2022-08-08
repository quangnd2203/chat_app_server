const NetworkResponse = require('../models/network_response');
const userRepository = require('../repositories/user_repository');

module.exports.getUser = async (request) => {
    try {
        const networkResponse = await userRepository.getUser(request);
        return networkResponse;
    } catch (e) {
        console.log(e);
        return NetworkResponse.fromErrors('cant_find_users');
    }
};
