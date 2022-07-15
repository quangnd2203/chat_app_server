const express = require('express');
var sql_connection = require('../sql_connection');
const router = express.Router();

router.get('/getAll', (request, response) => {
    sql_connection.query('CALL `userGetAll`();', (err, result,) => {
        response.send(result);
    })
});

module.exports = router;