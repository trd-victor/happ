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
        console.log('Token', token);
        console.log(" Message detail " , valueObject.message);

        const payload = {
            data: {
                "title": valueObject.name,
                "body": valueObject.message,
                "chatroom_id": valueObject.chatroomId,
                "chatmate_id": valueObject.chatmateId,
                "photo_url": valueObject.photoUrl
            },
            notification: {
                "title": valueObject.name,
                "body": valueObject.message,
                "sound": "default"
            }
        };

        const options = {
            content_available: true,
            collapse_key: valueObject.chatroomId,
            priority: "high"
        };

        if(token != null && token != ""){
            admin.messaging().sendToDevice(token, payload, options).then(function (response) {
                console.log("Successfully sent message: ", response);
            }).catch(function (error) {
                console.log("Error sending message:", error);
            }); 
        }else{
            console.log("No Token user: ", forUserId)
        }
    },

    function (errorObject) {
        console.log("Error getting data: " + errorObject.code);
    });

});

exports.timelinePushNotif = functions.https.onRequest((req, res) => {
    if (req.body.receiver === undefined && req.body.name === undefined) {
        console.log("Failed: ", req.body.receiver ," Name: ", req.body.name)
        res.status(400).send('No message defined!');
    } else {
        var receiver = req.body.receiver;
        var name = req.body.name;
        var count = 0;
        if(receiver){
            if (receiver.length > 0) {
                var data_server = {
                    "receiver": receiver, 
                    "name": name
                }

                admin.database().ref('notifications/push-notification/timeline').set(data_server).then(function(){
                     res.status(200).end(); 
                })

            }else{
                res.status(200).end();    
            }   
        }else{
            res.status(200).end();
            console.log('No receiver')
        }
    } 
});

exports.timelinePushSend = functions.database.ref('/notifications/push-notification/timeline')
    .onWrite(event => {

    var valueObject = event.data.val();

    if(valueObject.receiver === undefined || valueObject.receiver == ""){
        return new Promise((res, rej)=> {
           return res(400);
        })
    }else{
        var receiver = JSON.parse(valueObject.receiver);
        var name = valueObject.name; 

        return new Promise((res, rej)=>{
            if(receiver.length > 0){
                var count = 0;

                receiver.forEach(function(data){
                    var fid = data.fid;
                    var message = data.message;

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

                    admin.database().ref('registration-token/' + fid + '/token').once('value', function(snap){
                        if (snap.exists()){
                            var token = snap.val();
                            count++;
                           
                            if (count == receiver.length){
                                if(token != "" && token != null){
                                    admin.messaging().sendToDevice(token, payload, options).then(function (response) {
                                        console.log("result: ", response);
                                        res(200);
                                    }).catch(function (error) {
                                        res(200);
                                        console.log("error", error);
                                    }); 
                                }else{
                                    res(200);
                                }
                            }else{
                                if(token != "" && token != null){
                                    admin.messaging().sendToDevice(token, payload, options).then(function (response) {
                                        console.log("result: ", response);
                                    }).catch(function (error) {
                                        console.log("error:", error);
                                    });
                                }
                            }
                        }else{
                             count++;
                            if (count == receiver.length){
                                res(200);
                            }
                        }
                    },function (errorObject) {
                        count++;
                        if (count == receiver.length){
                            res(200);
                        }
                        console.log("Error getting data: " + errorObject.code);
                    })

                })
            }else{
                res(200);
            }
        })
    }

})

exports.freeTimePushNotif = functions.database.ref('/notifications/push-notification/free-time')
    .onWrite(event => {

    var valueObject = event.data.val();

    if(valueObject.firIDs != null && valueObject.firIDs != "") { 
        var firIDs = valueObject.firIDs.split(",");

        if (firIDs.length > 0){
            var count = 0;
            return new Promise((res, rej)=>{
                firIDs.forEach(function(id){
                    return admin.database().ref().child("users").child(id).once('value').then(function(snapshot){
                        if(snapshot.exists()){
                            var value = {}
                            value = snapshot.val();
                            var body = "";
                            if(!value && value["language"] === undefined){
                                value["language"] = "jp";
                            }

                            if(value["language"] == "en"){
                                body = valueObject.messageEN;
                            }else if(value["language"] == "jp"){
                                body = valueObject.messageJP;
                            }

                            var payload = {
                                data: {
                                    "title": "H",
                                    "body": valueObject.name + " " + body,
                                    "author_id": valueObject.userId
                                },
                                notification: {
                                    // title: valueObject.name,
                                    body: valueObject.name + " " + body,
                                    sound: "default"
                                }
                            };

                            var options = {
                                content_available: true,
                                collapse_key: valueObject.name,
                                priority: "high"
                            }

                            admin.database().ref('registration-token/' + id + '/token').once('value', function(snap){
                                if (snap.exists()){
                                    var token = snap.val();
                                    count++;
                                   
                                    if (count == firIDs.length){
                                        if(token != "" && token != null){
                                            admin.messaging().sendToDevice(token, payload, options).then(function (response) {
                                                console.log("result: ", response);
                                                res(200);
                                            }).catch(function (error) {
                                                console.log("error:", error);
                                                res(200);
                                            });
                                        }else{
                                           res(200);
                                        }
                                    }else{
                                        if(token != "" && token != null){
                                            admin.messaging().sendToDevice(token, payload, options).then(function (response) {
                                                console.log("result: ", response);
                                            }).catch(function (error) {
                                                console.log("error:", error);
                                            });
                                        }
                                    }
                                }else{
                                    count++;
                                    if (count == firIDs.length){
                                        res(200);
                                    }
                                }
                            },function (errorObject) {
                                count++;
                                if (count == firIDs.length){
                                    res(200);
                                }
                                console.log("Error getting data: " + errorObject.code);
                            })
                        }else{
                            count++;
                            if (count == firIDs.length){
                                res(200);
                            }
                        }
                    })
                })
            })
        }else{
            return new Promise(function(res,rej){
                console.log("No FIR IDS")
                res(400);
            })
        }
    }else{
        return new Promise(function(res,rej){
            console.log("No FIR IDS")
            res(400);
        })
    }
});

exports.reservation = functions.https.onRequest((req, res) => {
    if (req.body.body === undefined) {
        res.status(400).send('No message defined!');
    } else {
        // Everything is ok
        const token = req.body.fcmtoken;
        const uid = req.body.uid;

        console.log("Send reservation to " +uid);

        const payload = {
            data: {
                "title": req.body.title,
                "body": req.body.body,
                "token": req.body.fcmtoken
            },

            notification: {
                title: req.body.title,
                body: req.body.body,
                sound: "default"
            }
        };

        const options = {
            content_available: true,
            priority: "high"
        }

        if (req.body.firstSend == true || req.body.firstSend == "true"){

            writeReservationDetails(uid);
            admin.database().ref('user-badge').child("reservation").child(uid).once('value', function(snap){
                var count = snap.val();

                if (count != null && count != 0 ){
                    var total = count + 1;
                    admin.database().ref('user-badge').child("reservation").child(uid).set(total);
                }else{
                    admin.database().ref('user-badge').child("reservation").child(uid).set(1);
                }
            })
        }

        //Check if token exist
        var database = admin.database();

        database.ref('registration-token').child(uid).child('token').once("value", snapshot => {
            const userToken = snapshot.val();
            if (userToken != null && userToken == token) {
                 // Save reservation details to db
                 return admin.messaging().sendToDevice(token, payload, options);
            } else {
                console.log("Registration token does not exist");
            }
        });

        res.status(200).end();
    }
});


//news
exports.news = functions.https.onRequest((req, res) => {
    if (req.body.messageEN === undefined || req.body.messageJP === undefined || req.body.indicator === undefined ) {
        res.status(400).send("Failed to send News");
    }else if (req.body.indicator == "all") {
        messageAllUser(req);
        res.status(200).end();
    }else if (req.body.indicator == "specific") {
        const messageJP = req.body.messageJP;
        const messageEN = req.body.messageEN;
        const adminFID = req.body.adminFIR;
        const admin_name = req.body.adminName;

        const firUsers = req.body.firUsers;
        var all_users = firUsers.split(",");

        all_users.forEach(function(fid) {
            admin.database().ref().child("users").child(fid).once("value").then(function(snap){
                if(snap.exists()){
                    let value = snap.val();
                    if (value && value["language"] && value["language"] != null){
                        if (value["language"] == "en"){
                            sendMessage(fid, messageEN, adminFID, admin_name);
                        }else{
                            sendMessage(fid, messageJP, adminFID, admin_name);
                        }
                    }else {
                        sendMessage(fid, messageJP, adminFID, admin_name);
                    }
                }  
            })
        })
        res.status(200).end();
    }    
});

function messageAllUser(req){
    const messageJP = req.body.messageJP;
    const messageEN = req.body.messageEN;
    const adminFID = req.body.adminFIR;
    const admin_name = req.body.adminName;

    admin.database().ref().child("users").once('value').then(function(snap){
        if(snap.numChildren() > 0){
            snap.forEach(function(childSnapshot){
                let fid = childSnapshot.key;
                let value = childSnapshot.val();

                if (value && value["language"] && value["language"] != null){
                    if (value["language"] == "en"){
                        sendMessage(fid, messageEN, adminFID, admin_name);
                    }else{
                        sendMessage(fid, messageJP, adminFID, admin_name);
                    }
                }else {
                    sendMessage(fid, messageJP, adminFID, admin_name);
                }                
            })
        }
    })
}

function sendMessage(fid, message, adminFID, admin_name){
    var memberDB = admin.database().ref('/chat/members').orderByChild(fid).equalTo(true).once("value").then(function(snap){
        var result = snap.val();
        var userFID = fid.toString();
        var chatRoom = "";
        if(result != null && result.length != 0) {
                var count = 0
                snap.forEach(function(childSnapshot){
                    count++
                    var value = childSnapshot.val()
                    var snapKey = childSnapshot.key

                    if(value[fid] && value[adminFID]){
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
                                    "timestamp"    : admin.database.ServerValue.TIMESTAMP
                                });

                                admin.database().ref('/chat/messages').child(key).push({
                                    "message"      : message,
                                    "name"         : admin_name,
                                    "photoUrl"     : "",
                                    "timestamp"    : admin.database.ServerValue.TIMESTAMP,
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
                                "timestamp"    : admin.database.ServerValue.TIMESTAMP
                            });

                            admin.database().ref('/chat/messages').child(chatRoom).push({
                                "message"      : message,
                                "name"         : admin_name,
                                "photoUrl"     : "",
                                "timestamp"    : admin.database.ServerValue.TIMESTAMP,
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


// Save reservation details to db
function writeReservationDetails(userId) {
    console.log('Reservation saved');
    var database = admin.database();

    var timestamp = admin.database.ServerValue.TIMESTAMP;

    var globalData = {
        id: 0,
        name: "null",
        photoUrl: "null",
        timestamp: timestamp,
        type: "reservation",
        userId: "null"
    };

    var globalRef = database.ref('notifications').child('app-notification').child('notification-all');
    var userRef = database.ref('notifications').child('app-notification').child('notification-user');

    // Get a key for a new reservation
    var resKey = globalRef.push().key;

    // Prepare insertion
    globalRef.child(resKey).set(globalData);
    userRef.child(userId).child('notif-list').child(resKey).child('read').set(false);

    var countRef = userRef.child(userId).child('unread').child('count');

    // Get unread value
    countRef.once('value').then(function(snapshot) {
        if (snapshot.val() === undefined || snapshot.val() == null) {
            countRef.set(1);
        } else {
            var count = snapshot.val();
            countRef.set(count + 1);
        }
    });
}

function deleteUserData(userId) {
    var database = admin.database();

    console.log("Id to be deleted: " +userId);
    // Delete account details
    database.ref('users').child(userId).remove();
    database.ref('registration-token').child(userId).remove();
    database.ref('notifications').child('app-notification').child('notification-user').child(userId).remove();

    // Delete user messages
    database.ref('chat').child('members').orderByChild(userId).equalTo(true).on("value", function(snapshot) {
        if (snapshot.exists()) {
            if (snapshot.numChildren() > 0) {
                snapshot.forEach(function(data) {
                    var chatroomId = data.key;
                    var roomData = data.val();
                    console.log("Convo to be deleted: " +chatroomId);

                    for(dataID in roomData){
                        if(dataID != "blocked"){
                            database.ref('chat').child('last-message').child(dataID).child(chatroomId).remove();
                        }
                    }

                    database.ref('chat').child('last-message').child(userId).remove();
                    database.ref('chat').child('messages').child(chatroomId).remove();
                    database.ref('chat').child('message-notif').child(userId).remove();
                    database.ref('chat').child('members').child(chatroomId).remove();
                });
            }
        }
    });
}

function deleteNotif(notif_key){
    var database = admin.database();
    database.ref('notifications').child('app-notification').child('notification-user').on('value').then(function(snap){

        if (snap.exists()){
            if (snap.numChildren() > 0) {
                snap.forEach(function(data) {
                    var user_key = data.key;
                    database.ref('notifications').child('app-notification').child('notification-user').child(user_key).child('notif-list').child(notif_key).remove();
                });
            }
        }
    })
}


exports.updateUser = functions.https.onRequest((req, res) => {
    if (req.body.uid === undefined) {
        res.status(400).send('No user id defined');
    } else {
        var userId = req.body.uid;
        var newPassword = req.body.password;
        var newEmail = req.body.email;
       
        var name = req.body.name;
        var skills = req.body.skills;
        var icon = req.body.icon;
        var lang = req.body.lang;
        var wp_id = req.body.id;
        var action = req.body.action;

        if(action == "updateuser" && wp_id !== undefined && wp_id != "" && newEmail && newEmail != ""){

            if(skills != ""){
                skills = "," + skills + ",";
            } 

            admin.database().ref('users').child(userId).once("value").then(function(snapshot){
                if(snapshot.exists()){
                    var updated_data = {
                        "email" : newEmail,
                        "id" : wp_id,
                        "language" : lang,
                        "name" : name,
                        "photoUrl" : icon,
                        "skills" : skills,
                    }
                    console.log(updated_data)
                    admin.database().ref('users').child(userId).set(updated_data);
                }
            });
        }

        if((newPassword == "" || newPassword == null) && newEmail != ""){
            //prepare user update
            admin.auth().updateUser(userId, {
                email: newEmail,
                emailVerified: true
            }).then(function(userRecord) {
                admin.database().ref("users").child(userId).child("email").set(newEmail);
                console.log("Successfully updated user email", userRecord.toJSON());
            })
            .catch(function(error) {
                console.log("Error updating user: ", error);
            });
        }else if((newEmail == "" || newEmail == null) && newPassword != ""){
            //prepare user update
            admin.auth().updateUser(userId, {
                password: newPassword
            }).then(function(userRecord) {
                console.log("Successfully updated user password ", userRecord.toJSON());
            })
            .catch(function(error) {
                console.log("Error updating user: ", error);
            });
        }else{
            if(newEmail != null && newEmail != "" && newPassword != null && newPassword != ""){
                //prepare user update
                admin.auth().updateUser(userId, {
                    password: newPassword,
                    email: newEmail,
                    emailVerified: true
                }).then(function(userRecord) {
                    admin.database().ref("users").child(userId).child("email").set(newEmail);
                    console.log("Successfully updated user user and password", userRecord.toJSON());
                })
                .catch(function(error) {
                    console.log("Error updating user: ", error);
                });
            }
        }

        res.status(200).end();
    }
});