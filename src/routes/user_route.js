const express = require('express');
const userController = require('../controllers/user_controller');
const router = express.Router();

router.get('/getAll', (request, response) => {
    userController.getUser().then((res) => {
        response.send(res);
    });
});

module.exports = router;