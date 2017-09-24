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
 	return ref.once("value", function(snapshot){
 		const token = snapshot.val();
 		console.log('Token', token);
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
        	collapse_key: valueObject.chatroomId,
        	priority: "high"
	    };
	    admin.messaging().sendToDevice(token, payload, options);
	},
    function (errorObject) {
        console.log("Error getting data: " + errorObject.code);
	});
});

