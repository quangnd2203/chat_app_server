const express = require('express');
const SqlConnection = require('../configs/sql_connection');
const userRepository = require('../repositories/user_repository');
const NetworkResponse = require('../models/network_response');
const UserModel = require('../models/user_model');
const router = express.Router();

router.get('/getAll', async (request, response) => {
    var result = userRepository.getUser();
    console.log(result);
    // SqlConnection().conn.query('CALL `userGetAll`();', (err, result,) => {
    //     if (err != null) response.send(NetworkResponse.fromErrors(error = err.code));
    //     else response.send(
    //         new NetworkResponse(
    //             status = 1,
    //             message = 'success',
    //             data = result[0].map(json => new UserModel(
    //                 id = json.id,
    //                 uid = json.uid,
    //                 name = json.name,
    //                 email = json.email,
    //                 accountType = json.accountType,
    //                 avatar = json.avatar,
    //                 background = json.background,
    //                 createAt = json.created_at,
    //                 updateAt = json.update_at,
    //             )),
    //         ),
    //     );
    // });
});

module.exports = router;