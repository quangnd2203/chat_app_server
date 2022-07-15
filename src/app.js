const express = require('express');
const socketIo = require('socket.io');
const cors = require('cors');
// const passport = require('passport');

const routers = require('./routes/routes');

const app = express();

app.use(express.json());

app.use(express.urlencoded({ extended: true }));

app.use(cors());
app.options('*', cors());

// app.use(passport.initialize());
// passport.use('jwt', jwtStrategy);

app.use('/api', routers);

app.use((req, res, next) => {
    next(new ApiError(httpStatus.NOT_FOUND, 'Not found'));
});

module.exports = app;