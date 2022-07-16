const mySql = require('mysql');
const dbConfigs = require('./database_configs');

function SqlConnection(){
    if(typeof SqlConnection.instance === 'object'){
        return SqlConnection.instance;
    }

    conn = mySql.createConnection(dbConfigs);

    SqlConnection.instance = this;

    return SqlConnection.instance;
}

module.exports = SqlConnection;