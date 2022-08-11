const express = require('express');
const conversationController = require('../controllers/conversation_controller');
const router = express.Router();
const {authorizedServer} = require('../middlewares/authorize_middleware');

router.get('/getAll', authorizedServer, (request, response) => {
    conversationController.getAllConversation(request).then((value) => {
        response.send(value);
    });
});

module.exports = router;