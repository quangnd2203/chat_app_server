
/**
 * @param {Number} id 
 * @param {string} uid
 * @param {string} name
 * @param {string} email
 * @param {string} accountType
 * @param {string} avatar
 * @param {string} background
 * @param {Date} createdAt
 * @param {Date} updatedAt
 */

function UserModel(id, uid, name, email, accountType, avatar, background, createdAt, updatedAt) {
    this.id = id;
    this.uid = uid;
    this.name = name;
    this.email = email;
    this.accountType = accountType;
    this.avatar = avatar;
    this.background = background;
    this.createdAt = createdAt;
    this.updatedAt = updatedAt;
}

UserModel.fromJson = (json) => new UserModel(
    json.id,
    json.uid,
    json.name,
    json.email,
    json.accountType,
    json.avatar,
    json.background,
    new Date(`${json.createdAt}`),
    new Date(`${json.updatedAt}`),
);

module.exports = UserModel;