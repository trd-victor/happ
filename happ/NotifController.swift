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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navBar.barTintColor = UIColor.blackColor()
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
        let navItem = UINavigationItem(title: "Notification")
        let btnBack = UIBarButtonItem(image: UIImage(named: "Image"), style: .Plain, target: self, action: Selector("backToMenu:"))
        btnBack.tintColor = UIColor.whiteColor()
        
        //closer to left anchor nav
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15
        
        navItem.setLeftBarButtonItems([negativeSpacer, btnBack], animated: false)
        
        self.navBar.setItems([navItem], animated: false)
        self.navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    func getNotification(){
        let config = SYSTEM_CONFIG()
        
        let firID = config.getSYS_VAL("FirebaseID") as! String
        let notifAllDb = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-all")
        
        notifAllDb.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            
            if let result = snapshot.value as? NSDictionary {
                let key =  snapshot.key
                
                let notifUserDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(firID).child("notif-list").child(key)
                
                notifUserDB.observeEventType(.ChildAdded, withBlock: {(snap) in
                    
                    if(snap.exists()) {
                        self.arrayData.insert(result, atIndex: 0)
                        self.backupData.append(result)
                        self.tblView.reloadData()
                    }
                })
            }
        })
    }
    
    func backToMenu(sender: UIBarButtonItem) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("UserTimeline") as! UserTimelineViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentBackDetail(vc)
    }
    
    func presentBackDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
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
            
            if type == "timeline" || type == "post-timeline"{
                cell.lblMessage.text = "\(name) posted it on the timeline."
            }else if type == "free-time" {
                cell.lblMessage.text = "\(name) turned \"now\" free."
            }else if type == "message" {
                cell.lblMessage.text = "You have a message from \(name)."
            }else if type == "reservation" {
                cell.lblMessage.text = "Reservation"
            }
            
            cell.lblDate.text = dateFormatter(timestamp!)
            
            if image != nil && image! != "null" && image! != ""{
                cell.notifPhoto.imgForCache(image!)
            }
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = self.backupData[self.backupData.count - 1 - indexPath.row] as? NSDictionary
        let type = data!["type"] as? String
        let name = data!["name"] as? String
        let post_id = data!["id"] as? Int
        let photoUrl = data!["photoUrl"] as? String
        let user_id = data!["userId"] as? String
        
        if type! == "timeline" || type! == "post-time" {
            self.postName = name!
            self.postPhotoUrl = photoUrl!
            self.getPostDetail(post_id!)
        }else if type! == "free-time" {
            self.getUserDetail(user_id!)
        }
        
    }
    
    func dateFormatter(timestamp: NSNumber) -> String{
        let seconds = timestamp.doubleValue / 1000
        let dateTimestamp = NSDate(timeIntervalSince1970: seconds)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm"
        let time = formatter.stringFromDate(dateTimestamp)
        formatter.dateFormat = "MMM dd"
        let date = formatter.stringFromDate(dateTimestamp)
        return "\(date) at \(time)"
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
                        
                        transition.duration = 0.25
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
        
        let baseUrl: NSURL = NSURL(string: "http://happ.biz/wp-admin/admin-ajax.php")!
        let parameters = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_timeline",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(globalUserId.userID)",
            "post_id"     : "\(postid)",
            "count"       : "1"
        ]
        
        let request = NSMutableURLRequest(URL: baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if json!["success"] != nil {
                    if let resultArray = json!.valueForKey("result") as? NSArray {
                        if resultArray.count != 0 {
                            UserDetails.username =  self.postName
                            UserDetails.userimageURL = self.postPhotoUrl
                            UserDetails.postDate = resultArray[0]["post_modified"] as! String
                            UserDetails.fromID = resultArray[0]["fields"]!!["from_user_id"]!! as! String
                            UserDetails.body = resultArray[0]["fields"]!!["body"]!! as! String
                            
                            dispatch_async(dispatch_get_main_queue()){
                                if resultArray[0]["fields"]!!["images"] as? NSArray  != nil {
                                    let images = resultArray[0]["fields"]!!["images"] as! NSArray
                                    
                                    if images.count == 3 {
                                        UserDetails.img1 = images[0]["image"]!!["url"] as! String
                                        UserDetails.img2 = images[1]["image"]!!["url"] as! String
                                        UserDetails.img3 = images[2]["image"]!!["url"] as! String
                                    }else if images.count == 2 {
                                        UserDetails.img1 = images[0]["image"]!!["url"] as! String
                                        UserDetails.img2 = images[1]["image"]!!["url"] as! String
                                        UserDetails.img3 = "null"
                                    }else if images.count == 1 {
                                        UserDetails.img1 = images[0]["image"]!!["url"] as! String
                                        UserDetails.img2 = "null"
                                        UserDetails.img3 = "null"
                                    }
                                }else{
                                    UserDetails.img1 = "null"
                                    UserDetails.img2 = "null"
                                    UserDetails.img3 = "null"
                                }
                                
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyBoard.instantiateViewControllerWithIdentifier("TimelineDetail") as! TimelineDetail
                                
                                self.presentDetail(vc)
                            }
                        }
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
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
        let name = config.getSYS_VAL("username_\(globalUserId.userID)")!
        let photoUrl = config.getSYS_VAL("userimage_\(globalUserId.userID)")!
        let firID = FIRAuth.auth()?.currentUser?.uid
        let timestamp = FIRServerValue.timestamp()
        
        dispatch_async(dispatch_get_main_queue()){
            let notifAllDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-all").childByAutoId()
            
            let notif_all_key = notifAllDB.key
            
            let notifDetail = [
                "name": String(name),
                "photoUrl": String(photoUrl),
                "id": id,
                "timestamp": timestamp,
                "type": type,
                "userId": firID!
            ]
            
            notifAllDB.setValue(notifDetail)
            
            // get all user
            let userDB = FIRDatabase.database().reference().child("users")
            
            dispatch_async(dispatch_get_main_queue()){
                userDB.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                    
                    if let result = snapshot.value as? NSDictionary {
                        for (key, _) in result {
                            if key as! String != firID! {
                                
                                // update notification user
                                FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(key as! String).child("notif-list").child(notif_all_key).child("read").setValue(false)
                                
                                // get unread count on each user
                                let readDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(key as! String).child("unread").child("count")
                                
                                readDB.observeSingleEventOfType(.Value, withBlock: {(snapCount) in
                                    let count = snapCount.value as? Int
                                    readDB.setValue(count! + 1)
                                })
                            }
                        }
                    }
                })
            }
        }
    }
    
}