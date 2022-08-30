

const mongoose = require("mongoose");
const { ObjectId } = mongoose.Schema;
const AutoIncrement = require('mongoose-sequence')(mongoose);
const UserModel = require('./user_model');
const MessageModel = require('./message_model');

const schema = new mongoose.Schema({
    users: [{ type: ObjectId, ref: 'UserModel'}],
    lastMessage: { type: ObjectId, ref: 'MessageModel'},
}, {
    timestamps: true,
    _id: false,
    statics: {
        fromJson (json) {
            return {
                id: json._id,
                users: json.users,
                lastMessage: json.lastMessage,
                createdAt: json.createdAt,
                updatedAt: json.updatedAt,
            }
        },

        async createConversation(userIds) {
            var conversation = await this.findOne({
                users: userIds,
            });
            if(conversation == null){
                conversation = await this.create({
                    users: userIds,
                });
            }
            return await parseUserAndLastMessage(conversation);
        },

        
    },
});

parseUserAndLastMessage = async (conversation) => {
    conversation.users = await Promise.all(conversation.users.map( async (id) => await UserModel.findById(id)));
    if(conversation.lastMessage != null){
        const conversationId = conversation.lastMessage;
        conversation.lastMessage = MessageModel.findById(conversationId);
    }
    return conversation;
}

schema.plugin(AutoIncrement, {id: 'conversationId'});

module.exports = mongoose.model('ConversationModel', schema);