const { Server } = require('socket.io');
const {authorizeSocket} = require('../middlewares/authorize_middleware');

const io = new Server({
    cors : {
        origin: '*'
    }
});

const onConnection = (socket) => {
    require('../sockets/conversation_socket')(io, socket);
}

io.on('connection', (socket) => {
    console.log(`Connected ${socket.id}`);
    socket.on('disconnect', () => {
        console.log(`Disconnected ${socket.id}`);
    });
    onConnection(socket);
});

io.use(authorizeSocket);

module.exports = io;