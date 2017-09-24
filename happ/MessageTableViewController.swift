//
//  MessageTableViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 14/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

struct chatVar {
    static var name: String = ""
    static var RoomID : String = ""
    static var UserKey: String = ""
    static var Indicator: String = ""
    static var chatmateId: String = ""
    static var chatmatePhoto: String = ""
}


class MessageCellDisp : UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var userMessage: UILabel!
    @IBOutlet var userTime: UILabel!
    @IBOutlet var separator: UIView!
    
}


class MessageTableViewController: UITableViewController {
    
    var userID: String!
    var curID: String!
    var USERUID: String!
    
    @IBOutlet var mytableview: UITableView!
    var animals = ["test", "test1"]
    
    //set variables.. 
    var chatRoom = [String]()
    var chatName = [String]()
    var chatMessage = [String]()
    var chatImage = [String]()
    var chatKey = [String]()
    var chatmateId = [String]()
    var chatTime = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //remove border in messages
        self.mytableview.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.loadConfig()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "refresh", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTabBarMenu:", name: "tabBarShow", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshLang:", name: "refreshMessage", object: nil)
        
        self.getUserMessage()
        
    }
    
    func loadConfig(){
        let config = SYSTEM_CONFIG()
        
        self.title = config.translate("title:message")
    }
    
    func refreshLang(notifcation: NSNotification){
        let config = SYSTEM_CONFIG()
        self.title = config.translate("title:message")
    }
    
    func getUserMessage() {
        let config = SYSTEM_CONFIG()
        
        let fireDB = config.getSYS_VAL("FirebaseID") as! String
        let details = FIRDatabase.database().reference().child("chat").child("last-message").child(fireDB)
            
        //start of retrieving messages on every user
        details.observeEventType(.ChildAdded, withBlock: { (snap) in
            
            if let result = snap.value {
                let userimage = result.objectForKey("photoUrl") as! String
                let name = result.objectForKey("name") as! String
                let chatmate = result.objectForKey("chatmateId") as! String
                let message = result.objectForKey("lastMessage") as! String
                let chatRoomID = result.objectForKey("chatroomId") as! String
                let timestamp = result.objectForKey("timestamp") as! NSNumber
                let seconds = timestamp.doubleValue / 1000
                let dateTimestamp = NSDate(timeIntervalSince1970: seconds)
                let formatter = NSDateFormatter()
                formatter.dateFormat = "hh:mm:ss a"
                let msgDate = formatter.stringFromDate(dateTimestamp)
                dispatch_async(dispatch_get_main_queue()) {
                    self.chatImage.append(userimage)
                    self.chatName.append(name)
                    self.chatMessage.append(message)
                    self.chatRoom.append(chatRoomID)
                    self.chatmateId.append(chatmate)
                    self.chatTime.append(msgDate)
                    self.mytableview.reloadData()
                }
            }
        })

    }
    
    func refreshTable(notification: NSNotification) {
        self.chatImage.removeAll()
        self.chatName.removeAll()
        self.chatMessage.removeAll()
        self.chatRoom.removeAll()
        self.chatTime.removeAll()
        self.getUserMessage()
    }
    
    
    func showTabBarMenu (notification: NSNotification) {
        //hide tabbar controller in swift
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatName.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.mytableview.dequeueReusableCellWithIdentifier("CellDisplay", forIndexPath: indexPath) as! MessageCellDisp
        
        cell.separator.translatesAutoresizingMaskIntoConstraints = false
        cell.separator.bottomAnchor.constraintEqualToAnchor(cell.contentView.bottomAnchor, constant: -5).active = true
        cell.separator.leftAnchor.constraintEqualToAnchor(cell.contentView.leftAnchor, constant: 55).active = true
        cell.separator.widthAnchor.constraintEqualToConstant(view.frame.size.width - 65).active = true
        cell.separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        cell.userTime.translatesAutoresizingMaskIntoConstraints = false
        cell.userTime.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor, constant: 3).active = true
        cell.userTime.rightAnchor.constraintEqualToAnchor(cell.contentView.rightAnchor, constant: -10).active = true
        cell.userTime.widthAnchor.constraintEqualToConstant(120).active = true
        cell.userTime.heightAnchor.constraintEqualToConstant(31).active = true
        
        let radius = min(cell.userImage!.frame.width/2 , cell.userImage!.frame.height/2)
        cell.userImage.layer.cornerRadius = radius
        cell.userImage.clipsToBounds = true
        
        if self.chatImage[indexPath.row] == "null" || self.chatImage[indexPath.row] == ""{
            cell.userImage.image = UIImage(named: "noPhoto")
        }else{
            dispatch_async(dispatch_get_main_queue()){
                let data = NSData(contentsOfURL: NSURL(string: "\(self.chatImage[indexPath.row])")!)
                cell.userImage.image = UIImage(data: data!)
            }
        }
        
        cell.userTime.text = self.chatTime[indexPath.row]
        cell.username.text = self.chatName[indexPath.row]
        cell.userMessage.text = self.chatMessage[indexPath.row]

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        chatVar.name = self.chatName[indexPath.row]
        chatVar.RoomID = self.chatRoom[indexPath.row]
        chatVar.UserKey = self.chatRoom[indexPath.row]
        chatVar.chatmateId = self.chatmateId[indexPath.row]
        firebaseId.userId = self.chatmateId[indexPath.row]
        chatVar.Indicator = "MessageTable"
        globalvar.userTitle = chatVar.name
        
        
        let vc = ViewLibViewController()
        self.presentDetail(vc)
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
    }

}


