const conversationRepository = require('../repositories/conversation_repository');
const ConversationModel = require('../models/conversation_model');
const UserModel = require('../models/user_model');
const NetworkResponse = require('../models/network_response');

module.exports.createConversation = async (request) => {
    try{
        const errors = validationResult(request);
        if (!errors.isEmpty()) throw Error(errors.array()[0].msg);

        const body = request.body;
        const data = await conversationRepository.createConversation(request.user.uid, body.partnerUid);
        return NetworkResponse(
            1,
            null,
            ConversationModel(
                data[0].conversationId,
                null,
                data.map(u => new UserModel(
                    u.id,
                    u.uid,
                    u.name,
                    u.email,
                    u.accountType,
                    u.avatar,
                    u.background,
                    u.created_at,
                    u.updated_at,
                )),
            ),
        );
    }catch(e){
        console.log(e);
        return NetworkResponse.fromErrors(e.message || 'cant_create_conversation');
    }
}