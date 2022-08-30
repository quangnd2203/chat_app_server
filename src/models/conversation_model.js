

const mongoose = require("mongoose");
const { ObjectId } = mongoose.Schema;
const AutoIncrement = require('mongoose-sequence')(mongoose);
const UserModel = require('./user_model');
const MessageModel = require('./message_model');

const schema = new mongoose.Schema({
    userIds: [{ type: ObjectId, ref: 'UserModel'}],
    lastMessageId: { type: ObjectId, ref: 'MessageModel'},
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
            if(conversation == null) throw Error('ivalid_conversation');
            return await parseUserAndLastMessage(conversation);
        },

        
    },
});

parseUserAndLastMessage = async (conversation) => {
    conversation.users = await Promise.all(conversation.userIds.map(async (id) => UserModel.fromJson(await UserModel.findById(id))));
    if(conversation.lastMessageId != null){
        conversation.lastMessage = MessageModel.findById(conversation.lastMessageId);
    }
    return conversation;
}

schema.plugin(AutoIncrement, {id: 'conversationId'});

module.exports = mongoose.model('ConversationModel', schema);