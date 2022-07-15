const mySql = require('mysql');

function SqlConnection(){
    if(typeof SqlConnection.instance === 'object'){
        return SqlConnection.instance;
    }

    conn = mySql.createConnection({
        host: 'localhost',
        user: 'root',
        database: 'chat_app_db',
    });

    SqlConnection.instance = this;

    return SqlConnection.instance;
}

module.exports = SqlConnection;