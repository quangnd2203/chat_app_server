const mySql = require('promise-mysql');

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

var db;

module.exports.createConnection = async () => {
    try{
        db = await mySql.createConnection(dataBaseConfigs);
        console.log('Connected');
        return true;
    }catch(e){
        console.log('Connect failed: '+ e);
        return false;
    }
}

module.exports.query = async (query, param = []) => {
    return (await db.query(query, param))[0];
}
