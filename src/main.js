const sqlConnection = require('./configs/sql_connection');
const app = require('./app');

sqlConnection.createConnection().then((value) => {
    if(value) app.listen(3000);

});