const express = require('express');
const SqlConnection = require('../configs/sql_connection');
const router = express.Router();

router.get('/getAll', (request, response) => {
    SqlConnection().conn.query('CALL `userGetAll`();', (err, result,) => {
        response.send(result[0]);
    })
});

module.exports = router;