const express = require('express');
const userController = require('../controllers/user_controller');
const router = express.Router();
const authorizeMiddleware = require('../middlewares/authorize_middleware');
router.get('/getAll', authorizeMiddleware, (request, response) => {
    userController.getUser().then((data) => {
        response.send(data);
    });
});

module.exports = router;