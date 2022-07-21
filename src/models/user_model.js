
/**
 * @param {Number} id 
 * @param {string} uid
 * @param {string} name
 * @param {string} email
 * @param {string} accountType
 * @param {string} avatar
 * @param {string} background
 * @param {string} accessToken
 * @param {string} fcmToken
 * @param {Date} createdAt
 * @param {Date} updatedAt
 */

function UserModel(id, uid, name, email, accountType, avatar, background, accessToken, fcmToken, createdAt, updatedAt){
    this.id = id;
    this.uid = uid;       
    this.name = name;
    this.email = email;
    this.accountType = accountType;
    this.avatar = avatar;
    this.background = background;
    this.accessToken = accessToken;
    this.fcmToken = fcmToken;
    this.createAt = createdAt;
    this.updateAt = updatedAt;
}

module.exports = UserModel;