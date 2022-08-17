const mySql = require('promise-mysql');
var db;

module.exports.createConnection = async () => {
    try{
        console.log(`Connecting: ${process.env.MYSQL_CONFIGS}`);
        db = await mySql.createConnection(JSON.parse(process.env.MYSQL_CONFIGS));
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
