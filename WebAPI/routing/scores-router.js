'use strict';

const router = require('express').Router(),
    createScoreController = require('../controller/scores-controller'),
    scoresData = require('../data/scores-data'),
    constants = require("../config/utils/constants");

const scoresController = createScoreController(scoresData, constants.cookieText);

module.exports = app => {
    router
        .post('/getTop', scoresController.getTop)
        .post('/add', scoresController.add)

    app.use('/scores', router);
};