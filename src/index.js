var sql_connection = require('./sql_connection');

const app = require('./app');

sql_connection.createConnection().then((conn) => {
    conn.connect((error) => {
        if(error) throw error;
        app.listen(3000, () => {
            console.log('Connected');
            conn.query('CALL `userGetAll`();', (err, result,) => {
                console.log(result);
            })
        });
    });
    sql_connection.query = conn.query;
});