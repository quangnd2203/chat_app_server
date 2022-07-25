const sqlConnection = require('./configs/sql_connection');
const app = require('./app');
const os = require('os');
require('dotenv').config('./.env');

sqlConnection.createConnection().then((value) => {
    if(value) app.listen(process.env.SERVER_PORT, () => {
        console.log(`Server is up and running on port: ${process.env.SERVER_PORT}`);
    });
});