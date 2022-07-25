const express = require('express');
const swaggerJsDoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');
const router = express.Router();
require('dotenv').config('./.env');

const swaggerOption = swaggerJsDoc({
    swaggerDefinition: JSON.parse(process.env.SWAGGER_DEFINITION),
    apis: ['src/routes/*.js'],
})

router.use('/', swaggerUi.serve);
router.get(
  '/',
  swaggerUi.setup(swaggerOption, {
    explorer: true,
  })
);

module.exports = router;



