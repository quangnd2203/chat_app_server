const { Server } = require('socket.io');
const {authorizeSocket} = require('../middlewares/authorize_middleware');

const io = new Server({
    cors : {
        origin: '*'
    }
});

const onConnection = (socket) => {
    require('../sockets/conversation_socket')(io, socket);
    require('../sockets/base_socket')(io, socket);
}

io.on('connection', (socket) => {
    onConnection(socket);
});

io.use(authorizeSocket);

module.exports = io;