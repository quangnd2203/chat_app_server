const {Server, Socket} = require("socket.io");
var socket;

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */


module.exports = (io, s) => {
    socket = s;
    socket.on('createConversation', (data) => createConversation(data));
}

/** 
 * @param {Socket} socket
*/ 

createConversation = (data) => {
    // console.log(data);
    // socket.disconnect(true);
}