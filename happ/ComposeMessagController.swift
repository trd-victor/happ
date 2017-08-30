////
////  ComposeMessagController.swift
////  happ
////
////  Created by TokikawaTeppei on 20/08/2017.
////  Copyright © 2017 H-FUKUOKA. All rights reserved.
////
//
//import UIKit
//import Firebase
//import JSQMessagesViewController
//
//class ComposeMessagController: JSQMessagesViewController {
//
//    var messages = [JSQMessage]()
//    
//    
//    
//    lazy var outgoingBubble: JSQMessagesBubbleImage = {
//        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
//    }()
//
//    lazy var incomingBubble: JSQMessagesBubbleImage = {
//        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
//    }()
//    
//    //variable set
//    var username : String!
//    var roomID: String!
//    var userID: String!
//    
//    //set of messages variables..
//    var currMessage = [String]()
//    var otherMessage = [String]()
//    var userImage = [String]()
//    var userIDmsg = [String]()
//    var msgTime = [String]()
//    var allMsg = [String]()
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        let defaults = NSUserDefaults.standardUserDefaults()
////        
////        
////        if  let id = defaults.stringForKey("jsq_id"),
////            let name = defaults.stringForKey("jsq_name")
////        {
////            senderId = id
////            senderDisplayName = name
////        }
////        else
////        {
////            senderId = String(arc4random_uniform(999999))
////            senderDisplayName = ""
////            
////            defaults.setObject(senderId, forKey: "jsq_id")
////            defaults.synchronize()
////            
////            showDisplayNameDialog()
////        }
////        
////        title = "Chat: \(senderDisplayName!)"
////        
////        let tapGesture = UITapGestureRecognizer(target: self, action:  "showDisplayNameDialog:")
////        tapGesture.numberOfTapsRequired = 1
////        
////        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
////        
//        inputToolbar!.contentView!.leftBarButtonItem = nil
//        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
//        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
////
////        let query = Constants.ref.rootChild.queryLimitedToLast(10)
////        
////        _ = query.observeEventType(.ChildAdded, withBlock: { [weak self] snapshot in
////        
////            if  let data        = snapshot.value as? [String: String],
////                let id          = data["user_id"],
////                let name        = data["name"],
////                let text        = data["message"] where !text.isEmpty
////            {
////                if let message = JSQMessage(senderId: id, displayName: name, text: text)
////                {
////                    self?.messages.append(message)
////                    
////                    self?.finishReceivingMessage()
////                }
////            }
////        })
//        
//        
//        //set delegate
////        self.mycollectionView.delegate = self
////        self.mycollectionView.dataSource = self
//        
//        //get chatroomid
//        self.roomID = chatVar.RoomID
//        print(self.roomID)
//        
//        //get userKey
//        self.userID  = chatVar.UserKey
//        
//        //set up the for the title of the navigation controller in swift
//        self.username = chatVar.name
//        self.title = self.username
//        
//        //remove the text in back button
//        self.navigationController?.navigationBar.backItem?.title = ""
//        
//        //set collection view..
////        
////        self.mycollectionView.reloadData()
//        
//        //load all messages
//        self.getAllMessage()
//        
//        
//        
//        
//    }
//    
//    //get all message
//    func getAllMessage() {
//        
//        //set db according to chatroomID..
//        let db = FIRDatabase.database().reference().child("chat").child("messages").child("\(self.roomID)")
//        
//        db.observeEventType(.Value, withBlock: { (snapshot) in
//            if let messages = snapshot.value as? [String:AnyObject] {
//                for( _, value) in messages {
//                    
//                    //get all array of data..
//                    let message = value["message"] as! String
//                    //                    let image = value["photoUrl"] as! String
//                    let userID = value["userId"] as! String
//                    
//                    //set array of data..
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.otherMessage.append(message)
////                        self.allMsg.append(message)
//                        self.userIDmsg.append(userID)
//                        
////                        self.messages.append(message)
//                      //  self.mycollectionView.reloadData()
//                        self.collectionView!.reloadData()
//                    }
//                }
//            }
//        })
//    }
//    
//    
//    
////    @objc func showDisplayNameDialog()
////    {
////        let defaults = NSUserDefaults.standardUserDefaults()
////        
////        
////        let alert = UIAlertController(title: "Your Display Name", message: "Before you can chat, please choose a display name. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: UIAlertControllerStyle.Alert)
////        
////        alert.addTextFieldWithConfigurationHandler {  textField in
////            if let name = defaults.stringForKey("jsq_name")
////            {
////                textField.text = name
////            }
////            else
////            {
////                let names = ["Ford", "Arthur", "Zaphod", "Trillian", "Slartibartfast", "Humma Kavula", "Deep Thought"]
////                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
////            }
////        }
////        
////        
////        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { [weak self, weak alert] _ in
////            
////            if let textField = alert?.textFields?[0] where !textField.text!.isEmpty {
////                
////                self?.senderDisplayName = textField.text
////                
////                self?.title = "Chat: \(self!.senderDisplayName!)"
////                
////                defaults.setObject(textField.text, forKey: "jsq_name")
////                defaults.synchronize()
////            }
////            }))
////    
////        self.presentViewController(alert, animated: true, completion: nil)
////    }
//    
//    
//    
////    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageData!
////    {
//////        return self.allMsg[indexPath.item]
////    }
////    
////    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
////    {
////        return allMsg.count
////    }
////    
////    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageBubbleImageDataSource!
////    {
////        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
////    }
////    
////    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath) -> JSQMessageAvatarImageDataSource!
////    {
////        return nil
////    }
//    
////    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> NSAttributedString!
////    {
//////        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
////        
////    }
////    
////    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath) -> CGFloat
////    {
//////        return messages[indexPath.item].senderId == senderId ? 0 : 15
////    }
//    
////    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
//    
////        //insert new chat inseid the roomID
////        let ref = Constants.ref.rootChild.childByAutoId()
////        
////        //get room ID
////        //let roomID = Constants.ref.rootChild
////        //print(roomID.key)
////        
////        let message = ["message": text, "name": self.senderDisplayName, "user_id": senderId]
////        
////        ref.setValue(message)
////        
////        finishSendingMessage()
//        
//    }
//    
//    //set up 
//    //insert new chat inseid the roomID
//    //let ref = Constants.ref.rootChild.childByAutoId()
//    
//    //get room ID
//    //let roomID = Constants.ref.rootChild
//
//}
