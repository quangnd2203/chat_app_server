const express = require('express');
const authRoute = require('./auth_route.js');
const userRoute = require('./user_route.js');
const router = express.Router();

const routes = [
    {
        path: '/auth',
        route: authRoute,
    },
    {
        path: '/user',
        route: userRoute,
    },
];

routes.forEach(
    (route) => {
        router.use(route.path, route.route);
    }
);

module.exports = router;