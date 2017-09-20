//
//  ViewLibViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 25/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

struct Message {
    static var lastMessage : String = ""
}

class ViewLibViewController: JSQMessagesViewController {

    //variable set
    var username : String!
    var roomID : String = ""
    var userID: String!
    
    
    //set of messages variables..
    var currMessage = [String]()
    var otherMessage = [String]()
    var userImage = [String]()
    var userIDmsg = [String]()
    var msgTime = [String]()
    var allMsg = [String]()
    var chatID = [String]()
    var firebaseID: String!
    
    var AllMessages = [JSQMessage]()
    
    
    
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
//        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        
       return JSQMessagesBubbleImageFactory(bubbleImage: UIImage.jsq_bubbleCompactTaillessImage(), capInsets: UIEdgeInsetsZero).outgoingMessagesBubbleImageWithColor(UIColor(hexString: "#eeeeee"))
    }()
    

    lazy var incomingBubble: JSQMessagesBubbleImage = {
//        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        return JSQMessagesBubbleImageFactory(bubbleImage: UIImage.jsq_bubbleCompactTaillessImage(), capInsets: UIEdgeInsetsZero).incomingMessagesBubbleImageWithColor(UIColor(hexString: "#f3e5d0"))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputToolbar!.contentView!.leftBarButtonItem = nil
        senderId = globalUserId.FirID
        
//        self.collectionView!.reloadData()
        //hide tabbar controller in swift
        self.tabBarController?.tabBar.hidden = true
        
        let cuid = firebaseId.userId
        let uid = globalUserId.FirID
        
        self.title = globalvar.userTitle
        senderDisplayName = globalvar.userTitle
       
        print(chatVar.Indicator)
        if chatVar.Indicator == "MessageTable" {
            self.roomID = chatVar.RoomID
            if self.roomID != "" {
                self.getAllMessage(self.roomID)
            }
        } else {
            if uid != "" && cuid != "" {
                self.chatMembers(uid, cuid: cuid){ (result) -> () in
                    if result.characters.count > 0 {
                        self.getEmptyMessage(result)
                        self.chatID.append(result)
                    }
                }
            }
        }
   
    }
    
    override func viewWillDisappear(animated: Bool) {
       NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil, userInfo: nil)
        
       NSNotificationCenter.defaultCenter().postNotificationName("tabBarShow", object: nil, userInfo: nil)
    }
    
    //get all message
    func getAllMessage(sender : String ) {
        
        //set db according to chatroomID..
        let db = FIRDatabase.database().reference().child("chat").child("messages").child(sender)
        
        db.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let result = snapshot.value {
                
                let userName = result.objectForKey("name")
                let userID = result.objectForKey("userId")
                let msg = result.objectForKey("message")
                
                if let message = JSQMessage(senderId: userID as! String, displayName: userName as! String , text: msg as! String) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.AllMessages.append(message)
                        self.finishReceivingMessage()
                        self.collectionView!.reloadData()
                    }
                }
            }
        })
    }
    
    
    
    //get all message
    func getEmptyMessage(sender: String) {
        
        //set db according to chatroomID..
        let db = FIRDatabase.database().reference().child("chat").child("messages").child("\(sender)")
        
        db.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let result = snapshot.value {
                
                let userName = result.objectForKey("name")
                let userID = result.objectForKey("userId")
                let msg = result.objectForKey("message")
                
                
                if let message = JSQMessage(senderId: userID as! String, displayName: userName as! String , text: msg as! String) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.AllMessages.append(message)
                        self.finishReceivingMessage()
                        self.collectionView!.reloadData()
                    }
                }
            }
        })
    }
    
    func displaySendMsg(sender: String) {
        
        //set db according to chatroomID..
        let db = FIRDatabase.database().reference().child("chat").child("messages").child("\(sender)")
        
        db.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let result = snapshot.value {
                
                let userName = result.objectForKey("name")
                let userID = result.objectForKey("userId")
                let msg = result.objectForKey("message")
                
                
                if let message = JSQMessage(senderId: userID as! String, displayName: userName as! String , text: msg as! String) {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.AllMessages.append(message)
                        self.finishReceivingMessage()
                        self.collectionView!.reloadData()
                    }
                }
            }
        })
    }
    
    
    func chatMembers(uid:String, cuid: String, completion: (String) -> ()) {
        let membersDb = FIRDatabase.database().reference().child("chat").child("members")
        membersDb.observeSingleEventOfType(.Value, withBlock: { snapshot in
            //get here teh chatroom ID
            for (key, value) in (snapshot.value as? [String: AnyObject])!{
                let id = key
                let dataVal = value as? [String: AnyObject]
                if dataVal![uid] != nil && dataVal![cuid] != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(id)
                    }
                }else{
                    dispatch_async(dispatch_get_main_queue()) {
                        completion("")
                    }
                }
            }
        })
    }
    
    //set image circel..
    func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage {
        let imageView: UIImageView = UIImageView(image: image)
        var layer: CALayer = CALayer()
        layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.AllMessages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageData!
    {
        return self.AllMessages[indexPath.item]
    }
   
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageAvatarImageDataSource!
    {
        let img = UIImage(named: "noPhoto")
        return JSQMessagesAvatarImage.avatarWithImage(self.maskRoundedImage(img!, radius: 8))
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageBubbleImageDataSource!
    {
        return AllMessages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
//    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        let cell = super.collectionView!.cellForItemAtIndexPath(indexPath) as!
//        JSQMessagesCollectionViewCell
//        
//        cell.textView!.textColor = UIColor.blackColor()
//        
//        return cell
//        
//    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        let config = SYSTEM_CONFIG()
        let username = config.getSYS_VAL("username_\(globalUserId.userID)")!
        
        let cuid = firebaseId.userId
        let uid = globalUserId.FirID
        
        var chatRoomID: String!
        for roomID in self.chatID {
            chatRoomID = roomID
        }
       
        if self.roomID != "" {
            let timestamp = FIRServerValue.timestamp()
            let ref = FIRDatabase.database().reference().child("chat").child("messages").child(self.roomID).childByAutoId()
            
            let message = ["message": text, "name": self.senderDisplayName, "userId": senderId, "photoUrl" : "null", "timestamp" : timestamp]
            
            //save message to message table firebase...
            ref.setValue(message)
            
            //save user last message
            let lastmsgDB = FIRDatabase.database().reference().child("chat").child("last-message").child(uid).child(self.roomID)
            
            let lastmsg = [
                "chatmateId"   : cuid,
                "chatroomId"   : roomID,
                "lastMessage"  : text,
                "name"         : self.senderDisplayName,
                "photoUrl"     : "null",
                "read"         : true,
                "timestamp"    : timestamp
            ]
            
            lastmsgDB.setValue(lastmsg)
            //end here user
  
            //save chatmate last message
            let clastmsgDB = FIRDatabase.database().reference().child("chat").child("last-message").child(cuid).child(self.roomID)
            
            let clastmsg = [
                "chatmateId"   : uid,
                "chatroomId"   : roomID,
                "lastMessage"  : text,
                "name"         : username,
                "photoUrl"     : "null",
                "read"         : true,
                "timestamp"    : timestamp
            ]
            clastmsgDB.setValue(clastmsg)
            //end here chatmate
// temporary comment
//            // save notif message on firebase
//            let notifDB = FIRDatabase.database().reference().child("notifications").childByAutoId()
//            let keyID = notifDB.key
//            let name = config.getSYS_VAL("username_\(globalUserId.userID)")!
//            let photoUrl = config.getSYS_VAL("userimage_\(globalUserId.userID)")!
//            let firID = config.getSYS_VAL("FirebaseID") as? String
//            
//            let data = [
//                "key"           : keyID,
//                "roomId"        : roomID,
//                "chatmateId"    : cuid,
//                "sender"          : self.senderDisplayName,
//            ]
//            
//            let notifData = [
//                "name"      : "\(name)",
//                "photoUrl"  : "\(photoUrl)",
//                "data"      : data,
//                "type"      : "message",
//                "timestamp" : timestamp,
//                "userId"    : firID!
//            ]
//            
//            notifDB.setValue(notifData)
//            // end here notif
            
            self.finishSendingMessage()
        } else {
            if cuid != "" && uid != "" {
                
                if self.chatID.isEmpty == true {
                    //connection to message
                    let ref = Constants.ref.rootChild.childByAutoId()
                    
                    //set chatroom ID
                    let userChatRoomID = Constants.ref.rootChild
                    
                    //get server timestamp..
                    let timestamp = FIRServerValue.timestamp()
                    
                    let message = ["message": text, "name": self.senderDisplayName, "userId": senderId, "photoUrl" : "null", "timestamp" : timestamp]
                    
                    //save message to message table firebase...
                    ref.setValue(message)
                    
                    //get the connection for members DB
                    let memberDB = Constants.ref.memberDb.child(userChatRoomID.key)
                    
                    let membersMessage = [
                        "\(cuid)"      :  true,
                        "\(uid)"  : true
                    ]
                    
                    //save to members DB..
                    memberDB.setValue(membersMessage)
                    
                    let lastmsgDB = FIRDatabase.database().reference().child("chat").child("last-message").child(uid).child(userChatRoomID.key)
                    
                    let lastmsg = [
                        "chatmateId"   : cuid,
                        "chatroomId"   : userChatRoomID.key,
                        "lastMessage"  : text,
                        "name"         : self.senderDisplayName,
                        "photoUrl"     : "null",
                        "read"         : true,
                        "timestamp"    : timestamp
                    ]
                    
                    //save to database last-message...
                    lastmsgDB.setValue(lastmsg)
                    
                    let cmatelastmsgDB = FIRDatabase.database().reference().child("chat").child("last-message").child(cuid).child(userChatRoomID.key)
                    
                    let cmatelastmsg = [
                        "chatmateId"   : uid,
                        "chatroomId"   : userChatRoomID.key,
                        "lastMessage"  : text,
                        "name"         : username,
                        "photoUrl"     : "null",
                        "read"         : true,
                        "timestamp"    : timestamp
                    ]
                    
                    //save to database last-message...
                    cmatelastmsgDB.setValue(cmatelastmsg)
                    
                    self.finishSendingMessage()
                    
                    if self.AllMessages.isEmpty == true {
                    
                        self.displaySendMsg(userChatRoomID.key)
                    }
                    
                }
                else {
                    let timestamp = FIRServerValue.timestamp()
                    let ref = FIRDatabase.database().reference().child("chat").child("messages").child(chatRoomID).childByAutoId()
                    
                    let message = ["message": text, "name": self.senderDisplayName, "userId": senderId, "photoUrl" : "null", "timestamp" : timestamp]
                    
                    //save message to message table firebase...
                    ref.setValue(message)
                    
                    let lastmsgDB = FIRDatabase.database().reference().child("chat").child("last-message")
                    
                     let userlastmsgDB = lastmsgDB.child(uid).child(chatRoomID)
                    
                    let userlastmsg = [
                        "chatmateId"   : cuid,
                        "chatroomId"   : chatRoomID,
                        "lastMessage"  : text,
                        "name"         : self.senderDisplayName,
                        "photoUrl"     : "null",
                        "read"         : true,
                        "timestamp"    : timestamp
                    ]
                    
                    //save to database last-message...
                    userlastmsgDB.setValue(userlastmsg)
                    
                    let cmatelastmsgDB = lastmsgDB.child(cuid).child(chatRoomID)
                    
                    let cmatelastmsg = [
                        "chatmateId"   : uid,
                        "chatroomId"   : chatRoomID,
                        "lastMessage"  : text,
                        "name"         : username,
                        "photoUrl"     : "null",
                        "read"         : true,
                        "timestamp"    : timestamp
                    ]
                    
                    //save to database last-message...
                    cmatelastmsgDB.setValue(cmatelastmsg)
                    self.finishSendingMessage()
                }
                
            }
        }
        
    }

}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

