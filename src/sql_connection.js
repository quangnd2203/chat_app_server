const mySql = require('mysql');
const app = require('./app');

var sql_connection = {};

sql_connection.createConnection = async () => {
    var connect = mySql.createConnection({
        host: 'localhost',
        user: 'root',
        database: 'chat_app_db'
    });
    return connect;
}

module.exports = sql_connection;

