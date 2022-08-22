const mongoose = require('mongoose');

module.exports.createConnection = (next) => {
    const config = {
        dbName: 'chat_app_db'
    };
    mongoose.connect('mongodb://root:password@mongo:27017', config, (error) => {
        if (error) throw error;
        next();
    });
}
