/*globals require module*/

let mongoose = require('mongoose');

let scoreSchema = new mongoose.Schema({
    date: {
        type: String,
        required: true
    },
    points: {
        type: Number,
        required: true
    }
});

mongoose.model('Score', scoreSchema);

let scoreModel = mongoose.model('Score', scoreSchema);

module.exports = scoreModel;