//import firebase functions modules
const functions = require('firebase-functions');
//import admin module
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// Listens for new messages added to messages/:pushId
exports.pushNotification = functions.database.ref('/chat/message-notif/{userId}').onWrite( event => {
    const forUserId = event.params.userId;
    //  Grab the current value of what was written to the Realtime Database.
    var valueObject = event.data.val();

    if(!valueObject) {
        return console.log('name ', valueObject.name, 'message', valueObject.message);
    }

    var ref = admin.database().ref('registration-token/' + forUserId + '/token');

    return ref.once("value", function(snapshot) {
        const token = snapshot.val();
        console.log('Token', token + " Notif detail " +valueObject.message);

        const payload = {
            data: {
                "title": valueObject.name,
                "body": valueObject.message,
                "chatroom_id": valueObject.chatroomId,
                "chatmate_id": valueObject.chatmateId,
                "photo_url": valueObject.photoUrl
            },
            notification: {
                title:valueObject.name,
                body: valueObject.message,
                sound: "default"
            }
        };

        const options = {
            content_available: true,
            collapse_key: valueObject.chatroomId,
            priority: "high"
        };

        admin.messaging().sendToDevice(token, payload, options);
    },

    function (errorObject) {
        console.log("Error getting data: " + errorObject.code);
    });

});

exports.timelinePushNotif = functions.database.ref('/notifications/push-notification/timeline')
    .onWrite(event => {

    var valueObject = event.data.val();

    console.log('Name ' +valueObject.name);

    const payload = {
        data: {
            "title": valueObject.name,
            "body": "Posted on timeline",
            "skills": valueObject.skills,
            "author_id": valueObject.userId
        },
        notification: {
            title: valueObject.name,
            body: "Posted on timeline",
            sound: "default"
        }
    };

    const options = {
        content_available: true,
        collapse_key: valueObject.name,
        priority: "high"
    }

    return admin.messaging().sendToTopic('timeline-push-notification', payload, options);

});

exports.freeTimePushNotif = functions.database.ref('/notifications/push-notification/free-time')
    .onWrite(event => {

    var valueObject = event.data.val();

    console.log('Name ' +valueObject.name);

    const payload = {
        data: {
            "title": valueObject.name,
            "body": "Turned on free now",
            "author_id": valueObject.userId
        },
        notification: {
            title: valueObject.name,
            body: "Turned on free now",
            sound: "default"
        }
    };

    const options = {
        content_available: true,
        collapse_key: valueObject.name,
        priority: "high"
    }

    return admin.messaging().sendToTopic('free-time-push-notification', payload, options);

});

exports.reservation = functions.https.onRequest((req, res) => {
    if (req.body.body === undefined) {
        res.status(400).send('No message defined!');
    } else {
        // Everything is ok
        console.log(req.body.body + "token " +req.body.fcmtoken);

        const token = req.body.fcmtoken;

        const payload = {
            data: {
                "title": "Reservation",
                "body": req.body.body,
                "token": req.body.fcmtoken
            },

            notification: {
                title: "Reservation",
                body: req.body.body,
                sound: "default"
            }
        };

        const options = {
            content_available: true,
            priority: "high"
        }

        return admin.messaging().sendToDevice(token, payload, options);

        res.status(200).end();
    }    
});

//news
exports.news = functions.https.onRequest((req, res) => {
    if (req.body.message === undefined) {
        res.status(400).send("Failed to send News");
    }if (req.body.firUsers === undefined) {
        messageAllUser(req);
    }else {
        const message = req.body.message
        const adminFID = req.body.adminFIR;
        const admin_name = req.body.adminName;

        const firUsers = req.body.firUsers;
        var all_users = firUsers.split(",");

        all_users.forEach(function(fid) {
            sendMessage(fid, message, adminFID, admin_name)
        })
        res.status(200).end();
    }    
});

function messageAllUser(req){
    const message = req.body.message
    const adminFID = req.body.adminFIR;
    const admin_name = req.body.adminName;

    admin.database().ref().child("users").once('value').then(function(snap){
        if(snap.numChildren() > 0){
            snap.forEach(function(childSnapshot){
                let fid = childSnapshot.key;
                sendMessage(fid, message, adminFID, admin_name)
            })
        }
    })
}

function sendMessage(fid, message, adminFID, admin_name){
    var memberDB = admin.database().ref('/chat/members').orderByChild(id).equalTo(true).once("value").then(function(snap){
        var result = snap.val();
        var userFID = id.toString();
        var chatRoom = "";
        if(result.length != 0) {
                var count = 0
                snap.forEach(function(childSnapshot){
                    count++
                    var value = childSnapshot.val()
                    var snapKey = childSnapshot.key

                    if(value[id] && value[adminFID]){
                        chatRoom = snapKey;
                    }

                    if(count == snap.numChildren()){
                        if(chatRoom == ""){
                            var obj = {}
                            obj[adminFID] = true;
                            obj[userFID] = true;
                            obj["blocked"] = true;
                            admin.database().ref('/chat/members').push(obj).then((snapshot)=> {
                                var key = snapshot.key
                                admin.database().ref('/chat/last-message').child(userFID).child(key).set({
                                    "chatmateId"   : adminFID,
                                    "chatroomId"   : key,
                                    "lastMessage"  : message,
                                    "name"         : admin_name,
                                    "photoUrl"     : "",
                                    "read"         : false,
                                    "timestamp"    : Date.now()
                                });

                                admin.database().ref('/chat/messages').child(key).push({
                                    "message"      : message,
                                    "name"         : admin_name,
                                    "photoUrl"     : "",
                                    "timestamp"    : Date.now(),
                                    "userId"       : adminFID
                                });

                                admin.database().ref('/chat/message-notif').child(userFID).set({
                                    "chatmateId"   : adminFID,
                                    "chatroomId"   : chatRoom,
                                    "message"      : message,
                                    "name"         : admin_name,
                                    "photoUrl"     : ""
                                });
                            })                                   
                        }else{
                            admin.database().ref('/chat/last-message').child(userFID).child(chatRoom).set({
                                "chatmateId"   : adminFID,
                                "chatroomId"   : chatRoom,
                                "lastMessage"  : message,
                                "name"         : admin_name,
                                "photoUrl"     : "",
                                "read"         : false,
                                "timestamp"    : Date.now()
                            });

                            admin.database().ref('/chat/messages').child(chatRoom).push({
                                "message"      : message,
                                "name"         : admin_name,
                                "photoUrl"     : "",
                                "timestamp"    : Date.now(),
                                "userId"       : adminFID
                            });

                            admin.database().ref('/chat/message-notif').child(userFID).set({
                                "chatmateId"   : adminFID,
                                "chatroomId"   : chatRoom,
                                "message"      : message,
                                "name"         : admin_name,
                                "photoUrl"     : ""
                            });
                        }
                    }
                })
        }else{
            var obj = {}
            obj[adminFID] = true;
            obj[userFID] = true;
            obj["blocked"] = true;
            admin.database().ref('/chat/members').push(obj).then((snapshot)=> {
                var key = snapshot.key

                admin.database().ref('/chat/last-message').child(userFID).child(key).set({
                    "chatmateId"   : adminFID,
                    "chatroomId"   : key,
                    "lastMessage"  : message,
                    "name"         : admin_name,
                    "photoUrl"     : "",
                    "read"         : false,
                    "timestamp"    : Date.now()
                });

                admin.database().ref('/chat/messages').child(key).push({
                    "message"      : message,
                    "name"         : admin_name,
                    "photoUrl"     : "",
                    "timestamp"    : Date.now(),
                    "userId"       : adminFID
                });

                admin.database().ref('/chat/message-notif').child(userFID).set({
                    "chatmateId"   : adminFID,
                    "chatroomId"   : chatRoom,
                    "message"      : message,
                    "name"         : admin_name,
                    "photoUrl"     : ""
                });
            }) 
        }
    })
}

// Delete user
exports.deleteUser = functions.https.onRequest((req, res) => {
    if (req.body.uid === undefined) {
        res.status(400).send('No user id defined');
    } else {
        // prepare deletion
        var userId = req.body.uid;

        admin.auth().deleteUser(userId)
            .then(function() {
                console.log("Successfully deleted user");
                deleteUserData(userId);

            })
            .catch(function(error) {
                console.log("Error deleting user: ", error);
            });

        res.status(200).end();
    }
});

function deleteUserData(userId) {
    var database = admin.database();

    console.log("Id to be deleted: " +userId);
    // Delete account details
    database.ref('users').child(userId).remove();
    database.ref('registration-token').child(userId).remove();
    database.ref('notifications').child('app-notification').child('notification-user').child(userId).remove();
    
}