const mongoose = require("mongoose");

const { ObjectId } = mongoose.Schema;

const schema = new mongoose.Schema({
    id: { type: Number, require: true},
    conversationId: { type: ObjectId, ref: 'ConversationModel'},
    text: { type: String, trim: true},
    media: { type: String, trim: true},
    userId: { type: ObjectId, ref: 'UserModel'},
}, {
    timestamps: true,
});

module.exports = mongoose.model('MessageModel', schema);