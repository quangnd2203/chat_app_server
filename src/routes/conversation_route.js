const express = require('express');
const router = express.Router();
const authorizeMiddleware = require('../middlewares/authorize_middleware');
const validations = require('../validations/validations');
const conversationController = require('../controllers/conversation_controller');

router.post('/createConversation', [validations.validateRequired('partnerUid')], authorizeMiddleware, (request, response) => {
    conversationController.createConversation(request).then((value) => {
        response.send(value);
    });
});

router.get('/getAllConversation', authorizeMiddleware, (request, response) => {
    conversationController.getAllConversation(request).then((value) => {
        response.send(value);
    });
})

module.exports = router;