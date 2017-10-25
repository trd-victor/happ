//
//  NotifController.swift
//  happ
//
//  Created by TokikawaTeppei on 13/09/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID

class NotifController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let navBar: UINavigationBar = UINavigationBar()
    let tblView: UITableView = UITableView()
    var arrayData: [NSObject] = []
    var backupData: [NSObject] = []
    var postName: String = ""
    var postPhotoUrl: String = ""
    var freeTimeMessage: String = ""
    var postTimelineMessage: String = ""
    var reservationMessage: String = ""
    var loadingScreen: UIView?
    let imgforProfileCache = NSCache()
    
    var count:UInt = 10
    var currentKey: String!
    var currentTime: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "#272727")
        self.navBar.barTintColor = UIColor(hexString: "#272727")
        self.navBar.translucent = false
        self.tblView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(navBar)
        self.view.addSubview(tblView)
        
        self.tblView.registerClass(NotifCell.self, forCellReuseIdentifier: "NotifCell")
        
        
        //load starting config and layout
        autoLayout()
        loadConfig()
        getNotification()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        self.tblView.reloadData()
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeBackTimeline:");
        swipeRight.direction = .Right
        
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func swipeBackTimeline(sender: UISwipeGestureRecognizer){
        let transition: CATransition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func autoLayout(){
        self.navBar.translatesAutoresizingMaskIntoConstraints = false
        self.navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        self.navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        self.navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        self.navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        self.tblView.translatesAutoresizingMaskIntoConstraints = false
        self.tblView.topAnchor.constraintEqualToAnchor(self.navBar.bottomAnchor).active = true
        self.tblView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        self.tblView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        self.tblView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, constant: -66).active = true
        self.tblView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tblView.rowHeight = 70
    }
    
    func loadConfig(){
        let config = SYSTEM_CONFIG()
        let titlestr = config.translate("title_notification")
        
        self.postTimelineMessage = config.translate("notif_timeline_mess")
        self.freeTimeMessage = config.translate("notif_freetime_mess")
        self.reservationMessage = config.translate("notif_reservation_mess")
        
        let navItem = UINavigationItem(title: titlestr)
        let btnBack = UIBarButtonItem(image: UIImage(named: "Image"), style: .Plain, target: self, action: Selector("backToMenu:"))
        btnBack.tintColor = UIColor.whiteColor()
    
        //closer to left anchor nav
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.tintColor = UIColor(hexString: "#272727")
        negativeSpacer.width = -15
        
        navItem.setLeftBarButtonItems([negativeSpacer, btnBack], animated: false)
        
        self.navBar.setItems([navItem], animated: false)
        self.navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    func getNotification(){
        let config = SYSTEM_CONFIG()
        let firID = config.getSYS_VAL("FirebaseID") as! String
        
        if currentKey == nil {
            let notifUserDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(firID).child("notif-list").queryLimitedToLast(10)
            
            notifUserDB.observeSingleEventOfType(.Value, withBlock: {(snap) in
                let first = snap.children.allObjects.first as? FIRDataSnapshot
                
                if snap.childrenCount > 0 {
                    for s in snap.children.allObjects as! [FIRDataSnapshot] {
                        
                        let read = s.value!["read"] as? Bool
                        
                        let notifAllDb = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-all").child(s.key)
                        
                        notifAllDb.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                            
                            if let result = snapshot.value as? NSDictionary {
                                result.setValue(read, forKey: "read")
                                result.setValue(s.key, forKey: "key")
                                self.arrayData.insert(result, atIndex: 0)
                            }
                            
                            if self.arrayData.count == snap.children.allObjects.count {
                                 self.tblView.reloadData()
                            }
                        })
                    }
                    self.currentKey = first!.key
                }
            })
        }else{
            let notifUserDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(firID).child("notif-list").queryOrderedByKey().queryEndingAtValue(self.currentKey).queryLimitedToLast(11)
            let count = self.arrayData.count
            notifUserDB.observeSingleEventOfType(.Value, withBlock: {(snap) in
                
                let first = snap.children.allObjects.first as? FIRDataSnapshot
                let index = self.arrayData.count
                
                if snap.childrenCount > 0 {
                    var notifData = snap.children.allObjects as! [FIRDataSnapshot]
                    notifData.removeLast()
                    for s in notifData {
                        let notifAllDb = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-all").child(s.key)
                        
                        let read = s.value!["read"] as? Bool
                        
                        notifAllDb.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                            if let result = snapshot.value as? NSDictionary {
                                result.setValue(read, forKey: "read")
                                result.setValue(s.key, forKey: "key")
                                self.arrayData.insert(result, atIndex: index)
                            }
                            
                            if (count + snap.children.allObjects.count - 1) == self.arrayData.count {
                                self.tblView.reloadData()
                            }
                        })
                    }
                    
                    self.currentKey = first!.key
                }
            })
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        
        if maxOffset - currentOffset <= 40{
//            self.count += 10
            getNotification()
        }
    }
    
    func backToMenu(sender: UIBarButtonItem) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("UserTimeline") as! UserTimelineViewController
        self.presentBackDetail(vc)
    }
    
    func presentBackDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.dismissViewControllerAnimated(false, completion: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotifCell", forIndexPath: indexPath) as! NotifCell
        
        let data = self.arrayData[indexPath.row] as? NSDictionary
       
        if data != nil {
            let name = data!["name"] as! String
            let type = data!["type"] as! String
            let timestamp = data!["timestamp"] as? NSNumber
            let image = data!["photoUrl"] as? String
            let read = data!["read"] as? Bool
            
            if !read! {
                cell.lblMessage.font = UIFont.boldSystemFontOfSize(17)
            }else{
                cell.lblMessage.font = UIFont.systemFontOfSize(17)
            }
            
            if type == "timeline" || type == "post-timeline"{
                cell.lblMessage.text = "\(name) \(self.postTimelineMessage)"
                if (globalvar.imgforProfileCache.objectForKey(image!) != nil) {
                    let imgCache = globalvar.imgforProfileCache.objectForKey(image!) as! UIImage
                    cell.notifPhoto.image = imgCache
                }else{
                    cell.notifPhoto.image = UIImage(named : "noPhoto")
                    let url = NSURL(string: image!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                        if let data = NSData(contentsOfURL: url!){
                            dispatch_async(dispatch_get_main_queue()){
                                cell.notifPhoto.image = UIImage(data: data)
                            }
                            let tmpImg = UIImage(data: data)
                            globalvar.imgforProfileCache.setObject(tmpImg!, forKey: image!)
                        }
                        
                    })
                    task.resume()
                }
            }else if type == "free-time" {
                cell.lblMessage.text = "\(name) \(self.freeTimeMessage)"
                if (globalvar.imgforProfileCache.objectForKey(image!) != nil) {
                    let imgCache = globalvar.imgforProfileCache.objectForKey(image!) as! UIImage
                    cell.notifPhoto.image = imgCache
                }else{
                    cell.notifPhoto.image = UIImage(named : "noPhoto")
                    let url = NSURL(string: image!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                        if let data = NSData(contentsOfURL: url!){
                            dispatch_async(dispatch_get_main_queue()){
                                cell.notifPhoto.image = UIImage(data: data)
                            }
                            let tmpImg = UIImage(data: data)
                            globalvar.imgforProfileCache.setObject(tmpImg!, forKey: image!)
                        }
                        
                    })
                    task.resume()
                }
            }else if type == "reservation" {
                cell.notifPhoto.image = UIImage(named: "oval")
                cell.lblMessage.text = self.reservationMessage
            }
            
            cell.lblDate.text = self.dateFormatter(timestamp!)
            
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       
        let data = self.arrayData[indexPath.row] as? NSDictionary
      
        let type = data!["type"] as? String
        let name = data!["name"] as? String
        let post_id = data!["id"] as? Int
        let photoUrl = data!["photoUrl"] as? String
        let user_id = data!["userId"] as? String
        let read = data!["read"] as? Bool
        let key = data!["key"] as? String
        
        if !read! {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? NotifCell
            cell?.lblMessage.font = UIFont.systemFontOfSize(17)
            FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(globalUserId.FirID).child("notif-list").child(key!).child("read").setValue(true)
            
            self.arrayData[indexPath.row].setValue(true, forKey: "read")
        }
        
        if type! == "timeline" || type! == "post-time" {
            self.postName = name!
            self.postPhotoUrl = photoUrl!
            self.getPostDetail(post_id!)
        }else if type! == "free-time" {
            self.getUserDetail(user_id!)
        }else if type! == "reservation"{
            dispatch_async(dispatch_get_main_queue()){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewControllerWithIdentifier("ViewReservation") as! ViewReservation
                let transition = CATransition()
                
                transition.duration = 0.40
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                self.view.window!.layer.addAnimation(transition, forKey: nil)
                self.presentViewController(vc, animated: false, completion: nil)
            }
        }
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
        return "\(date) \(time)"
    }
    
    func setImageURL(imageURL: String)-> UIImage{
        var image = UIImage()
        let url = imageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let data = NSData(contentsOfURL: NSURL(string: "\(url)")!)
        
        if data != nil {
            image = UIImage(data: data!)!
        }else{
            image = UIImage(named: "noPhoto")!
        }
        
        return image
    }
    
    func getUserDetail(id: String){
        let userdb = FIRDatabase.database().reference().child("users").child("\(id)")
        
        userdb.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let result = snapshot.value as? NSDictionary{
                if result["id"] != nil {
                    
                    dispatch_async(dispatch_get_main_queue()){
                        UserProfile.id = String(result["id"]!)
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyBoard.instantiateViewControllerWithIdentifier("UserProfile") as! UserProfileController
                        let transition = CATransition()
                        
                        transition.duration = 0.40
                        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                        transition.type = kCATransitionPush
                        transition.subtype = kCATransitionFromRight
                        self.view.window!.layer.addAnimation(transition, forKey: nil)
                        self.presentViewController(vc, animated: false, completion: nil)
                    }
                }
            }
        })
    }
    
    func getPostDetail(postid: Int) {
        
        UserDetails.username =  self.postName
        UserDetails.userimageURL = self.postPhotoUrl
        UserDetails.postID = String(postid)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("TimelineDetail") as! TimelineDetail
        self.presentDetail(vc)
    }
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func createBodyWithParameters(parameters: [String: String]?,  boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func saveNotificationMessage(id: Int, type: String){

        let config = SYSTEM_CONFIG()
       
        var firIDs: [String] = []
        let name = config.getSYS_VAL("username_\(globalUserId.userID)")!
        let photoUrl = config.getSYS_VAL("userimage_\(globalUserId.userID)")!
        let firID = FIRAuth.auth()?.currentUser?.uid
        let timestamp = FIRServerValue.timestamp()

        dispatch_async(dispatch_get_main_queue()){
            let notifAllDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-all").childByAutoId()
            
            let notif_all_key = notifAllDB.key
            
            let detail = [
                "name": String(name),
                "photoUrl": String(photoUrl),
                "id": id,
                "timestamp": timestamp,
                "type": type,
                "userId": firID!
            ]
            
            notifAllDB.setValue(detail)
            
            if type == "free-time" {
                let freeTimeDetail = [
                    "name": String(name),
                    "photoUrl": String(photoUrl),
                    "id": id,
                    "timestamp": timestamp,
                    "type": type,
                    "userId": firID!,
                    "messageEN": config.getTranslate("notif_freetime_mess", lang: "en"),
                    "messageJP": config.getTranslate("notif_freetime_mess", lang: "jp")
                ]
                
                let pushFreeTimeDB = FIRDatabase.database().reference().child("notifications").child("push-notification").child("free-time")
                pushFreeTimeDB.setValue(freeTimeDetail)
            }
            
            
            // get user DB
            let userDB = FIRDatabase.database().reference().child("users")
            
            if type == "free-time" {
                dispatch_async(dispatch_get_main_queue()){
                    userDB.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                        
                        if let result = snapshot.value as? NSDictionary {
                            for (key, _) in result {
                                if key as! String != firID! {
                                    // update notification user
                                    FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(key as! String).child("notif-list").child(notif_all_key).child("read").setValue(false)
                                    
                                    // get unread count on each user
                                    let readDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(key as! String).child("unread")
                                    dispatch_async(dispatch_get_main_queue()){
                                        readDB.observeSingleEventOfType(.Value, withBlock: {(snapCount) in
                                            
                                            if let result = snapCount.value as? NSDictionary {
                                                if let count = result["count"] as? Int {
                                                    readDB.child("count").setValue(count + 1)
                                                }else{
                                                    readDB.child("count").setValue(1)
                                                }
                                            }
                                        })
                                    }
                                }
                            }// end of loop
                        }// end of if
                    })// end of observation
                }// dispatch end
            }//end of if free time type
          
            
            if type == "timeline" {
                if timeline_post_skills.selectedSkills.count == 0 {
                    return
                }else{
                    dispatch_async(dispatch_get_main_queue()){
                        var count = 0
                        userDB.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                            if let result = snapshot.value as? NSDictionary {
                                for (key, value) in result {
                                    count++
                                    if let valueData = value as? NSDictionary {
                                        if let skills = valueData["skills"] as? String {
                                            let userKey = key as? String
                                            if skills != "" && userKey! != firID{
                                                for c in timeline_post_skills.selectedSkills {
                                                    if skills.containsString(String(c)){
                                                        firIDs.append(userKey!)
                                                        FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(key as! String).child("notif-list").child(notif_all_key).child("read").setValue(false)
                                                        let readDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(key as! String).child("unread")
                                                        dispatch_async(dispatch_get_main_queue()){
                                                            readDB.observeSingleEventOfType(.Value, withBlock: {(snapCount) in
                                                                
                                                                if let result = snapCount.value as? NSDictionary {
                                                                    if let count = result["count"] as? Int {
                                                                        readDB.child("count").setValue(count + 1)
                                                                    }else{
                                                                        readDB.child("count").setValue(1)
                                                                    }
                                                                }
                                                            })
                                                        }
                                                        break
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if count == result.count {
                                        let pushdetail = [
                                            "name": String(name),
                                            "photoUrl": String(photoUrl),
                                            "id": id,
                                            "timestamp": timestamp,
                                            "type": type,
                                            "userId": firID!,
                                            "skills": timeline_post_skills.selectedSkills.flatMap({String($0)}).joinWithSeparator(","),
                                            "messageEN": config.getTranslate("notif_timeline_mess", lang: "en"),
                                            "messageJP": config.getTranslate("notif_timeline_mess", lang: "jp"),
                                            "firIDs": firIDs.joinWithSeparator(",")
                                        ]
                                        
                                        let pushTimelineDB = FIRDatabase.database().reference().child("notifications").child("push-notification").child("timeline")
                                        pushTimelineDB.setValue(pushdetail)
                                    }
                                }// end of loop
                            }// end of if
                        })// end of observation
                    }// dispatch end
                }// end of if count selectedskill
            }// end of if type timeline
        }
    }
    
}