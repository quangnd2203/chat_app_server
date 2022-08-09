const {Server, Socket} = require("socket.io");
const conversationController = require('../controllers/conversation_controller');

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */

module.exports = (io, socket) => {
    socket.on('createConversation', (data) => conversationController.onCreateConversation(io, socket, data));
    socket.on('message', (data) => conversationController.onMessage(io, socket, data));
}
