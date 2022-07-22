const crypto = require('crypto-js');

module.exports.hashPassword = (password) => {
    return crypto.SHA512(password).toString();
}