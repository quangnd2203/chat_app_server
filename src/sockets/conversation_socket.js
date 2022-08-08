const {Server, Socket} = require("socket.io");
const ConversationController = require('../controllers/conversation_controller');

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */

module.exports = (io, socket) => {
    // const helper = new Helper(io, socket);
    const controllers = new ConversationController(io, socket);
    socket.on('createConversation', controllers.onCreateConversation);
    socket.on('message', helper.onMessage)
}
