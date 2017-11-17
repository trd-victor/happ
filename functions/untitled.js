exports.timelinePushNotif = functions.https.onRequest((req, res) => {
    if (req.body.message === undefined && req.body.firid === undefined) {
        console.log("Failed: ", req.body.message ," FIRID", req.body.firid)
        res.status(400).send('No message defined!');
    } else {
        var message = req.body.message;
        var name = req.body.name;
        var fid = req.body.firid;

        const payload = {
            data: {
                "title": "H",
                "body": name + " " + message,
                "author_id": fid
            },
            notification: {
                body: name + " " + message,
                sound: "default"
            }
        };

        const options = {
            content_available: true,
            collapse_key: name,
            priority: "high"
        }

        admin.database().ref('user-badge').child("timeline").child(fid).once('value', function(snap){
            var count = snap.val();
            if (count != null && count != 0 ){
                var total = count + 1;
                admin.database().ref('user-badge').child("timeline").child(id).set(total);
            }else{
                admin.database().ref('user-badge').child("timeline").child(id).set(1);
            }
        });

        admin.database().ref('registration-token/' + fid + '/token').once('value', function(snap){
            var token = snap.val();
           
            if(token != "" && token != null){
                admin.messaging().sendToDevice(token, payload, options);
            }
        },function (errorObject) {
            console.log("Error getting data: " + errorObject.code);
        })
        res.status(200).end();
    }
});