const express = require('express');
const authController = require('../controllers/auth_controller');
const router = express.Router();

router.post('/loginNormal', (request, response) => {
    authController.loginNormal(request.body.email, request.body.password).then((value) => {
        response.send(value);
    })
});

router.post('/register', (request, response) => {
    const body = request.body;
    authController.register(body.name, body.email, body.password, 'normal', body.fcmToken).then((value) => {
        response.send(value);
    })
});

module.exports = router;

