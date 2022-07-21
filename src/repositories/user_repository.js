const SqlConnection = require('../configs/sql_connection');

function getUser() {
    return SqlConnection().conn.query('CALL `userGetAll`();', (err, data) => {
        return data[0];
    });
}

module.exports.getUser = getUser;