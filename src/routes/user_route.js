const express = require('express');
const userController = require('../controllers/user_controller');
const router = express.Router();
const {authorizedServer} = require('../middlewares/authorize_middleware');

router.get('/getAll', authorizedServer, (request, response) => {
    userController.getUser(request).then((data) => {
        response.send(data);
    });
});

module.exports = router;