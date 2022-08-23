const databaseConnection = require('./configs/database_connection');
const socket_io_server = require('./configs/socket_io_server');
const app = require('./app');
const UserModel = require('./models/user_model');
require('dotenv').config('./.env');

databaseConnection.createConnection(() => {
    socket_io_server.listen(process.env.SOCKET_PORT);
    console.log(`SocketIo is up and running on port: ${process.env.SOCKET_PORT}`);
    app.listen(process.env.SERVER_PORT, () => {
        console.log(`Server is up and running on port: ${process.env.SERVER_PORT}`);
    });
    // UserModel.schema.c
});



