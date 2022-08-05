const {Server, Socket} = require("socket.io");
const conversationController = require('../controllers/conversation_controller');

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */

module.exports = (io, socket) => {
    var helper = new Helper(io, socket);
    socket.on('createConversation', helper.onCreateConversation);
    socket.on('leaveRoom', helper.onLeaveRoom);
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
        socket.join(`conversation_${conversation.data.id}`);
    };

    this.onLeaveRoom = (data) => {
        socket.leave(`conversation_${data.conversationId}`);
        socket.emit('leaveRoom', true);
    }

    this.onMessage = (data) => {
        io.to(`conversation_${data.conversationId}`).emit('message', data.message);
    }
}