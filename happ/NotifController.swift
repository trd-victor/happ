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
        //        let config = SYSTEM_CONFIG()
        //        self.title = config.translate("notice")
        
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
        let notifDB = FIRDatabase.database().reference().child("notifications")
        
        notifDB.observeEventType(.ChildAdded, withBlock: {(snapshot) in
            if let result = snapshot.value as? [String: AnyObject]{
                let userID = result["userId"] as! String
                
                if firID != userID{
                    self.arrayData.insert(result, atIndex: 0)
                    self.backupData.append(result)
                    self.tblView.reloadData()
                }
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
        
        let data = self.arrayData[indexPath.row]
        let name = data.valueForKey("name") as! String
        if data.valueForKey("type") != nil {
            let type = data.valueForKey("type") as! String
            
            if type == "post-timeline" || type == "timeline"{
                cell.lblMessage.text = "\(name) posted it on the timeline."
            }else if type == "free-time" {
                cell.lblMessage.text = "\(name) turned \"now\" free."
            }
            else if type == "message"{
                cell.lblMessage.text = "You have a message from \(name)."
            }else{
                cell.lblMessage.text = "\(name) posted it on the timeline."
            }
        }
        else{
            cell.lblMessage.text = "\(name) posted it on the timeline."
        }
        
        cell.lblDate.text = dateFormatter((data.valueForKey("timestamp") as? NSNumber)!)
        if (data.valueForKey("photoUrl") as? String) != nil{
            let image = setImageURL((data.valueForKey("photoUrl") as? String)!)
            cell.notifPhoto.image = image
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let data = self.backupData[self.backupData.count - 1 - indexPath.row]
        if let type = data.valueForKey("type") as? String {
            let postID = data.valueForKey("postId") as? Int
            if type == "post-timeline" || type == "timeline" {
                // post timeline
                self.postName = data.valueForKey("name") as! String
                self.postPhotoUrl = data.valueForKey("photoUrl") as! String
                self.getPostDetail(postID!)
                
            }else if type == "free-time" {
                // i am free
                let userID = data.valueForKey("userId") as! String
                self.getUserDetail(userID)
                
            }else if type == "message"{
                // message
                let messageData = data.valueForKey("data") as! [String: AnyObject]
                globalvar.userTitle =  messageData["sender"] as! String
                chatVar.RoomID = messageData["roomId"] as! String
                chatVar.Indicator = "MessageTable"
                
                let viewLib = ViewLibViewController()
                self.presentDetail(viewLib)
            }else {
                print("nothing")
            }
        }else{
            print("no type")
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
            if let result = snapshot.value{
                
                if result["id"] != nil {
                    SearchDetailsView.searchIDuser = String(result["id"]!!)
                    SearchDetailsView.userEmail = result["email"] as! String
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyBoard.instantiateViewControllerWithIdentifier("SearchDetailView") as! SearchDetailViewController
                    
                    self.presentDetail(vc)
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
}