const express = require('express');
const router = express.Router();
const {authorizedServer} = require('../middlewares/authorize_middleware');
const validations = require('../validations/validations');
const conversationController = require('../controllers/conversation_controller');

router.post('/createConversation', [validations.validateRequired('partnerUid')], authorizedServer, (request, response) => {
    conversationController.createConversation(request).then((value) => {
        response.send(value);
    });
});

router.get('/getAllConversation', authorizedServer, (request, response) => {
    conversationController.getAllConversation(request).then((value) => {
        response.send(value);
    });
})

module.exports = router;