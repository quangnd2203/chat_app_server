const {Server, Socket} = require("socket.io");
const conversationController = require('../controllers/conversation_controller');

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */

module.exports = (io, socket) => {
    const helper = new Helper(io, socket);
    socket.on('createConversation', helper.onCreateConversation);
    socket.on('message', helper.onMessage)
}

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */

function Helper (io, socket){

    this.onCreateConversation = async(data) => {
        const conversation = await conversationController.createConversation(socket.user.uid, data.uid);
        socket.emit('createConversation', conversation);
    };

    this.onMessage = async(data) => {
        io.to(`uid-${data.uid}`).emit('message', data.message);
        io.to(`uid-${socket.user.uid}`).emit('message', data.message);
    }
}