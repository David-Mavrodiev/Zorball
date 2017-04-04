/*globals require module*/
'use strict';

const Score = require('../models/score-model');

module.exports = {
    findTop() {
        let query = Score.find({}).sort({'points': -1}).limit(5);
        return Promise.resolve(query.exec());
    },
    add(obj) {
        let score = new Score({
            date: obj.date,
            points: obj.points
        });

        return Promise.resolve(score.save());
    }
};