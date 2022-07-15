const SqlConnection = require('./configs/sql_connection');

const app = require('./app');

SqlConnection().conn.connect((error) => {
    if (error) throw error;
    console.log("Connected");
    app.listen(3000);
});