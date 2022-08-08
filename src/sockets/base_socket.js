const {Server, Socket} = require("socket.io");

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */

module.exports = (io, socket) => {
    const helper = new Helper(io, socket);
    helper.onSocketConnected();
    socket.on('disconnect', (data) => {
        console.log("DIS");
    })
}

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */

function Helper (io, socket){
    this.onSocketConnected = async () => {
        console.log(`Connected ${socket.id}`);
        socket.join(`uid-${socket.user.uid}`);
    }
}