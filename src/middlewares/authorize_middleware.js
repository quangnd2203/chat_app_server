const jwt = require('jsonwebtoken');
const authRepository = require('../repositories/auth_repository');
const NetworkResponse = require('../models/network_response');
const UserModel = require('../models/user_model');

module.exports.authorizedServer = async (request, response, next) => {
    try{
        const token = request.header('Authorization').replace('Bearer ', '');
        const payload = jwt.verify(token, process.env.JWT_KEY);
        const user = await authRepository.authorized(payload.data, token);
        if(!user){
            throw new Error();
        }
        request.user = new UserModel(
            user.id,
            user.uid,
            user.name,
            user.email,
            user.accountType,
            user.avatar,
            user.background,
            user.created_at,
            user.updated_at,
        );
        request.token = token;
        next();
    }catch(error){
        response.status(200).send(NetworkResponse.fromErrors('Not authorized to access this resource'));
    }
}

module.exports.authorizeSocket = async (socket, next) => {
    try{
        const token = socket.handshake.headers.authorization.replace('Bearer ', '');
        const payload = jwt.verify(token, process.env.JWT_KEY);
        const user = await authRepository.authorized(payload.data, token);
        if(!user){
            throw new Error();
        }
        socket.user = new UserModel(
            user.id,
            user.uid,
            user.name,
            user.email,
            user.accountType,
            user.avatar,
            user.background,
            user.created_at,
            user.updated_at,
        );
        socket.token = token;
        next();
    }catch(error){
        next(NetworkResponse.fromErrors('Not authorized to access this resource'));
    }
}

