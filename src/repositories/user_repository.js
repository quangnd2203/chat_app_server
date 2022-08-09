const sqlConnection = require('../configs/sql_connection');
const NetworkResponse = require('../models/network_response');
const UserModel = require('../models/user_model');

module.exports.getUser = async (request) => {
    const users = await sqlConnection.query('CALL `userGetAll`(?,?,?);', [request.user.uid, request.query.limit || 10, request.query.offset || 0]);
    return new NetworkResponse(
        status = 1,
        message = null,
        data = users.map(u => UserModel.fromJson(u)),
    );
};
