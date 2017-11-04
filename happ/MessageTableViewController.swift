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
    let navBar: UINavigationBar = UINavigationBar()
    
    var animals = ["test", "test1"]
    
    //set variables..
    var lastMessages = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //remove border in messages
        self.mytableview.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.autoLayout()
        self.loadConfig()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "refresh", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showTabBarMenu:", name: "tabBarShow", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshLang:", name: "refreshMessage", object: nil)
        
        self.getUserMessage()
        
        preferredStatusBarStyle()
        
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func autoLayout(){
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#272727")
        self.navigationController?.navigationBar.titleTextAttributes =  [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    func loadConfig(){
        let config = SYSTEM_CONFIG()
        
        self.title = config.translate("title:message")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        let config = SYSTEM_CONFIG()
        
        self.title = config.translate("title:message")
        self.mytableview.reloadData()
    }
    
    func refreshLang(notifcation: NSNotification){
        let config = SYSTEM_CONFIG()
        self.title = config.translate("title:message")
    }
    
    func getUserMessage() {
        
        let config = SYSTEM_CONFIG()
        
        let fireDB = config.getSYS_VAL("FirebaseID") as! String
        let details = FIRDatabase.database().reference().child("chat").child("last-message").child(fireDB).queryOrderedByChild("timestamp")
        
        //start of retrieving messages on every user
        details.observeEventType(.Value, withBlock: { (snap) in
            self.lastMessages.removeAll()
            var count = 0
            if snap.childrenCount > 0 {
                for s in snap.children.allObjects as! [FIRDataSnapshot] {
                    if let data = s.value as? NSDictionary {
                        count++
                        
                        if let userID = data.valueForKey("chatmateId") as? String {
                            if let _ = globalvar.USER_IMG.valueForKey(userID) {
                                if let photo = globalvar.USER_IMG.valueForKey(userID)?.valueForKey("photoUrl") as? String {
                                    data.setValue(photo, forKey: "photoUrl")
                                }
                                if let photo = globalvar.USER_IMG.valueForKey(userID)?.valueForKey("name") as? String {
                                    data.setValue(photo, forKey: "name")
                                }
                                self.lastMessages.append(data)
                            }
                        }
                        
                        if count == Int(snap.childrenCount) {
                            dispatch_async(dispatch_get_main_queue()){
                                self.lastMessages.sortInPlace({(message1, message2) -> Bool in
                                    return message1["timestamp"]?.intValue < message2["timestamp"]?.intValue
                                })
                                self.mytableview.reloadData()
                            }
                        }
                    }
                }
            }
        })
    }
    
    func refreshTable(notification: NSNotification) {
        
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
        return self.lastMessages.count
    }
    
    let imgforProfileCache = NSCache()
    
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
        cell.username.font = UIFont.boldSystemFontOfSize(17)
        cell.userMessage.font = UIFont.systemFontOfSize(15)
        
        let radius = cell.userImage!.frame.width/2
        cell.userImage.contentMode = .ScaleAspectFill
        cell.userImage.layer.cornerRadius = radius
        cell.userImage.clipsToBounds = true
        
        
        let message = self.lastMessages[indexPath.row]
        let name = message["name"] as? String
        let lastMessage = message["lastMessage"] as? String
        let imageUrl  = message["photoUrl"] as? String
        let timestamp = message["timestamp"] as? NSNumber
        let readStatus = message["read"] as? Bool
        
        if (globalvar.imgforProfileCache.objectForKey(imageUrl!) != nil) {
            let imgCache = globalvar.imgforProfileCache.objectForKey(imageUrl!) as! UIImage
            cell.userImage.image = imgCache
        }else{
            cell.userImage.image = UIImage(named : "noPhoto")
            let url = NSURL(string: imageUrl!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if let data = NSData(contentsOfURL: url!){
                    dispatch_async(dispatch_get_main_queue()){
                        cell.userImage.image = UIImage(data: data)
                    }
                    let tmpImg = UIImage(data: data)
                    globalvar.imgforProfileCache.setObject(tmpImg!, forKey: imageUrl!)
                }
                
            })
            task.resume()
        }
        
        cell.userTime.text = dateFormatter(timestamp!)
        
        if readStatus! == false {
            cell.userMessage.font = UIFont.boldSystemFontOfSize(17)
        }
        
        cell.username.text = name!
        cell.userMessage.text = lastMessage
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let data = self.lastMessages[indexPath.row]
        let name = data["name"] as? String
        let room_id = data["chatroomId"] as? String
        let user_key = FIRAuth.auth()?.currentUser?.uid
        let chatmate_id = data["chatmateId"] as? String
        let messageStatus = data["read"] as? Bool
        
        
        chatVar.name = name!
        chatVar.RoomID =  room_id!
        chatVar.UserKey = user_key!
        chatVar.chatmateId = chatmate_id!
        chatVar.Indicator = "MessageTable"
        globalvar.userTitle = name!
        
        if messageStatus! == false {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? MessageCellDisp
            cell?.userMessage.font = UIFont.systemFontOfSize(15)
            FIRDatabase.database().reference().child("chat").child("last-message").child(user_key!).child(room_id!).child("read").setValue(true)
        }
        
        let vc = ViewLibViewController()
        self.presentDetail(vc)
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func dateFormatter(timestamp: NSNumber) -> String{
        let seconds = timestamp.doubleValue / 1000
        let dateTimestamp = NSDate(timeIntervalSince1970: seconds)
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "Asia/Tokyo")
        formatter.dateFormat = "HH:mm"
        let time = formatter.stringFromDate(dateTimestamp)
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.stringFromDate(dateTimestamp)
        return self.dateTransform("\(date) \(time)")
    }
    
    func dateTransform(date: String) -> String {
        var dateArr = date.characters.split{$0 == " "}.map(String.init)
        var timeArr = dateArr[1].characters.split{$0 == ":"}.map(String.init)
        let config = SYSTEM_CONFIG()
        let lang = config.getSYS_VAL("AppLanguage") as! String
        var date:String = "\(dateArr[0]) \(timeArr[0]):\(timeArr[1])"
        if lang != "en" {
            dateArr = dateArr[0].characters.split{$0 == "-"}.map(String.init)
            date = "\(dateArr[0])年\(dateArr[1])月\(dateArr[2])日 \(timeArr[0]):\(timeArr[1])"
        }
        return date
    }
    
    
}