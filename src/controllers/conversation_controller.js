const conversationRepository = require('../repositories/conversation_repository');
const NetworkResponse = require('../models/network_response');

module.exports.onCreateConversation = async (io, socket, data) => {
    try {
        const networkResponse = await conversationRepository.createConversation(socket.user.uid, data.uids);
        socket.emit('onCreateConversation', networkResponse);
    } catch (e) {
        console.log(e);
        socket.emit('error', NetworkResponse.fromErrors(e.message || 'cant_create_conversation'));
    }
};

module.exports.onMessage = async (io, socket, data) => {
    try {
        const networkResponseUser = await conversationRepository.getConversationUsers(data.conversationId);
        const networkResponseMessage = await conversationRepository.createMessage(data.conversationId, socket.user.uid, data.text, data.media);
        networkResponseUser.data.forEach(u => {
            io.to(`uid-${u.uid}`).emit('onMessage', networkResponseMessage);
        });
    } catch (e) {
        console.log(e);
        socket.emit('error', NetworkResponse.fromErrors(e.message || 'cant_send_message'));
    }
};

module.exports.getAllConversation = async (request) => {
    try {
        const networkResponse = await conversationRepository.getAllConversation(request.user.uid, request.query.limit, request.query.offset);
        return networkResponse;
    } catch (e) {
        console.log(e);
        return NetworkResponse.fromErrors(e.message || 'cant_get_conversations');
    }
}

module.exports.getMessagesByConversationId = async (request) => {
    try{
        const networkResponse = await conversationRepository.getMessagesByConversationId(request.query.conversationId, request.query.limit, request.query.offset);
        return networkResponse;
    } catch(e) {
        console.log(e);
        return NetworkResponse.fromErrors(e.message || 'cant_get_message');
    }
}