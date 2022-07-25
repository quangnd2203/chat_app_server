const crypto = require('crypto-js');
const jwt = require('jsonwebtoken');

module.exports.hashPassword = (password) => {
    return crypto.SHA512(password).toString();
}

module.exports.generateJWT = (data) => {
    const jwtSecretKey = process.env.JWT_KEY;
    const payload = {
        data: data,
    };
    const option = {
        algorithm: 'HS512',
        expiresIn: process.env.JWT_EXPIRES_IN,
    }
    return jwt.sign(payload, jwtSecretKey, option);
}