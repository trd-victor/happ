////
////  ComposeMessageViewController.swift
////  happ
////
////  Created by TokikawaTeppei on 17/08/2017.
////  Copyright © 2017 H-FUKUOKA. All rights reserved.
////
//
//import UIKit
//import Firebase
//import FirebaseDatabase
////import JSQMessagesViewController
//
//class ComposeMessageViewController: JSQMessagesViewController {
//
//    var FIRDB: FIRDatabaseReference!
//    
//    var messages = [JSQMessage]()
//    
//    lazy var outgoingBubble: JSQMessagesBubbleImage = {
//        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
//    }()
//    
//    lazy var incomingBubble: JSQMessagesBubbleImage = {
//        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        senderId = "1234"
//        senderDisplayName = "Reymond"
//        
//        inputToolbar!.contentView!.leftBarButtonItem = nil
//        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
//        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
//        
//   
//        
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!,messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData!
//    {
//        return messages[indexPath.item]
//    }
//    
//    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        return messages.count
//    }
//    
//    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource!
//    {
//        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
//    }
//    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource!
//    {
//        return nil
//    }
//    //attributedTextForMessageBubbleTopLabelAt
//    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
//    }
//
//    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat
//    {
//        return messages[indexPath.item].senderId == senderId ? 0 : 15
//    }
//    
//    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
//        
//        let ref = FIRDB.database.reference()
//        let chatRoom = ref.child("messages").childByAutoId()
//        
//        
//        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text]
//        
//        chatRoom.setValue(message)
//        
//        finishSendingMessage()
//       
//       
//    }
//
//}
