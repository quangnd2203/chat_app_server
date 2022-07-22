const sqlConnection = require('../configs/sql_connection');

module.exports.getUser = async () => {
    const users = await sqlConnection.query('CALL `userGetAll`();');
};