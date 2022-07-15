const SqlConnection = require('./configs/sql_connection');

const app = require('./app');

function main() {
    var sqlConnection = SqlConnection();
    sqlConnection.conn.connect((error) => {
        if (error) throw error;
        console.log("Connected");
        app.listen(3000);
    });
}
main();