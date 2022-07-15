const mySql = require('mysql');
const app = require('./app');

let server;

let conn = mySql.createConnection({
    host: 'localhost',
    user: 'root',
    database: 'chat_app_db'
});

conn.connect((error) => {
    if(error) throw error;
    server = app.listen(3000, () => {
        console.log('Connected');
    });
});