const mySql = require('mysql');

// const dataBaseConfigs = {
//     host: 'sql6.freemysqlhosting.net',
//     user: 'sql6507616',
//     database: 'sql6507616',
//     password: 'hWJCEHDn86',
//     port: '3306',
// }

const dataBaseConfigs = {
    host: 'localhost',
    user: 'root',
    database: 'chat_app_db',
    port: '3306',
}


function SqlConnection(){
    if(typeof SqlConnection.instance === 'object'){
        return SqlConnection.instance;
    }

    conn = mySql.createConnection(dataBaseConfigs);

    SqlConnection.instance = this;

    return SqlConnection.instance;
}

module.exports = SqlConnection;