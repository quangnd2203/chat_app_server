const {Server, Socket} = require("socket.io");

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */

module.exports = (io, socket) => {
    socket.on('createConversation', (data) => createConversation(data, socket));
}

/** 
 * @param {Socket} socket
*/ 

createConversation = (data, socket) => {
    console.log(data);
}