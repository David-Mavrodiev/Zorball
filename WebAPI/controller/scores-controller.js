'use strict';

module.exports = function(scoresData, cookieText) {
    return {
        getTop(req, res) {
            console.log("Getting top 5 scores...")
            if(req.body.cookieText == cookieText){
                scoresData.findTop().then((scores) => {
                    res.send(scores)
                });
            }else{
                res.status(401).send("Not authorized!")
            }
        },
        add(req, res){
            if(req.body.cookieText == cookieText){
                scoresData.add(req.body).then(() => {
                    res.status(200).send("Successfully added!")
                })
            }else{
                res.status(401).send("Not authorized!")
            }
        }
    }
}