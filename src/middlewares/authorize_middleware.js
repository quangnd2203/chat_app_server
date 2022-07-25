const jwt = require('jsonwebtoken');
const authRepository = require('../repositories/auth_repository');
const NetworkResponse = require('../models/network_response');

module.exports = async (request, response, next) => {
    const token = request.header('Authorization').replace('Bearer ', '');
    const payload = jwt.verify(token, process.env.JWT_KEY);
    try{
        const user = await authRepository.authorize(payload.data, token);
        if(!user){
            throw new Error();
        }
        request.user = user;
        request.token = token;
        next();
    }catch(error){
        response.status(400).send(NetworkResponse.fromErrors('Not authorized to access this resource'));
    }
}