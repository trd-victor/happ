//
//  ViewMessageViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 23/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase


class MessagIncoming : UICollectionViewCell {
    @IBOutlet var message: UILabel!
}

class ViewMessageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet var Navtitle: UINavigationItem!
    //variable set
    var username : String!
    var roomID: String!
    var userID: String!
    
    @IBOutlet var sendbutton: UIButton!
    
    @IBOutlet var textmessage: UITextField!
    //set of messages variables..
    var currMessage = [String]()
    var otherMessage = [String]()
    var userImage = [String]()
    var userIDmsg = [String]()
    var msgTime = [String]()
    var allMsg = [String]()
    
    //set for cellid
    let incomingMessage = "incomingmessage"
    let outgoingMessage = "outgoingcell"
    
    @IBOutlet var mycollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegate
        self.mycollectionView.delegate = self
        self.mycollectionView.dataSource = self
        
        //get chatroomid
        self.roomID = chatVar.RoomID
        print(self.roomID)
        
        //get userKey 
        self.userID  = chatVar.UserKey
        
        //set up the for the title of the navigation controller in swift
        self.username = chatVar.name
        self.title = self.username
    
        //remove the text in back button
        self.navigationController?.navigationBar.backItem?.title = ""
     
        //load all messages
        self.getAllMessage()
        
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    //get all message
    func getAllMessage() {
        
        //set db according to chatroomID..
        let db = FIRDatabase.database().reference().child("chat").child("messages").child("\(self.roomID)")
        
        
        db.observeEventType(.ChildAdded, withBlock: { snapshot in
            if let result = snapshot.value {
                
                let msg = result.objectForKey("message")
                let userID = result.objectForKey("userId")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.allMsg.append(msg as! String)
                    self.userIDmsg.append(userID as! String)
                    self.mycollectionView.reloadData()
                }
            }
        })
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.allMsg.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.mycollectionView.dequeueReusableCellWithReuseIdentifier("incomingmessage", forIndexPath: indexPath) as! MessagIncoming
        cell.sizeToFit()
        cell.message.sizeToFit()
        cell.message.text = self.allMsg[indexPath.item]
        
        return cell
    }
    
    
    @IBAction func sendbutton(sender: UIButton) {
        
        let sendMessage = self.textmessage.text!
        
        let db = FIRDatabase.database().reference().child("chat").child("messages").child("\(self.roomID)").childByAutoId()
        
        let timestamp = FIRServerValue.timestamp()
        let messageValue = [
            "message" : sendMessage,
            "name"    : "android",
            "photoURL" : "null",
            "timestamp" : timestamp,
            "userId"   : "3w6dRdnhHlTTbM5REixaW1z4icF3"
        ]
    
        db.setValue(messageValue)
        
    }

}



//if self.userIDmsg[indexPath.item] != "3w6dRdnhHlTTbM5REixaW1z4icF3" {
//    
//    //set up cell for outgoing messages..
//    let cell = self.mycollectionView.dequeueReusableCellWithReuseIdentifier(outgoingMessage, forIndexPath: indexPath) as! OutgoingMessageCell
//    cell.sizeToFit()
//    let font = UIFont(name: "Helvetica", size: 15.0)
//    //setup cell for messages
//    cell.outMsg.numberOfLines = 0
//    cell.outMsg.lineBreakMode = NSLineBreakMode.ByWordWrapping
//    cell.outMsg.font = font
//    cell.outMsg.sizeToFit()
//    cell.outMsg.text = self.allMsg[indexPath.item]
//    print(cell.outMsg.text)
//    return cell
//    
//} else {
//    //set up cell for incoming messages..
//    let cell = self.mycollectionView.dequeueReusableCellWithReuseIdentifier(incomingMessage, forIndexPath: indexPath) as! IncomingMessageCell
//    
//    //            cell.message.layer.cornerRadius = 8
//    //            cell.message.layer.masksToBounds = true
//    cell.message.sizeToFit()
//    cell.message.text = self.allMsg[indexPath.item]
//    print(cell.message.text)
//    cell.backgroundColor = UIColor.clearColor()
//    
//    return cell




//let constraintRect = CGSize(width: self.view.frame.size.width, height: CGFloat.max)
//let data = self.allMsg[indexPath.row];
//let boundingBox = data.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 16)!], context: nil)
//return CGSizeMake(collectionView.frame.width, boundingBox.height);




