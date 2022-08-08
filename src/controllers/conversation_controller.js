const conversationRepository = require('../repositories/conversation_repository');
const NetworkResponse = require('../models/network_response');
const { validationResult } = require('express-validator');

/**
 * 
 * @param {Server} io 
 * @param {Socket} socket 
 */

module.exports = function ConversationController (io, socket){
    
    this.onCreateConversation = (data) => {
        createConversation(socket.user.uid, data.uid).then((value) => socket.emit('onCreateConversation', value));  
    };

    this.onMessage = (data) => {
        
    }

    // this.getAllConversation = async () => {
    //     try{
    //         const errors = validationResult(request);
    //         if (!errors.isEmpty()) throw Error(errors.array()[0].msg);
    
    //         const body = request.body;
    //         const data = await conversationRepository.getAllConversation(request.user.uid);
    //         return new NetworkResponse(
    //             1,
    //             null,
    //             data.map(conversation => new ConversationModel(
    //                 conversation.id,
    //                 conversation.lastMessage,
    //                 conversation.users.map(u => new UserModel(
    //                     u.id,
    //                     u.uid,
    //                     u.name,
    //                     u.email,
    //                     u.accountType,
    //                     u.avatar,
    //                     u.background,
    //                     u.created_at,
    //                     u.updated_at,
    //                 )),
    //             )),
    //         );
    //     }catch(e){
    //         console.log(e);
    //         return NetworkResponse.fromErrors(e.message || 'cant_create_conversation');
    //     }
    // };
}

createConversation = async (uid, partnerUid) => {
    try{
        const networkResponse = await conversationRepository.createConversation(uid, partnerUid);
        return networkResponse;
    }catch(e){
        console.log(e);
        return NetworkResponse.fromErrors(e.message || 'cant_create_conversation');
    }
}