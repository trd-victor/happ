//
//  SearchDetailViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 13/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

struct firebaseId {
    static var userId : String = ""
    static var userName: String = ""
    static var indicator: String = ""
}

class onlyUserPost: UITableViewCell {
    
    @IBOutlet var userPostImage: UIImageView!
    @IBOutlet var userPostName: UILabel!
    @IBOutlet var userPostDate: UILabel!
    @IBOutlet var userPostContent: UITextView!
    
}


class SearchDetailViewController: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var topView: UIView!
   
    @IBOutlet var mytabBar: UITabBar!
    @IBOutlet var username: UILabel!
    
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userHID: UILabel!
    @IBOutlet var userSkills: UILabel!
    @IBOutlet var userDesription: UITextView!
    
    @IBOutlet var btnMessage: UIButton!
    @IBOutlet var btnBlock: UIButton!
    
    @IBOutlet var mytableView: UITableView!
    
    
    var arrText = [
        "en" : [
            "Message"  : "Message",
            "Block"    : "To block"
        ],
        "ja" : [
            "Message"  : "メッセージ",
            "Block"    : "ブロックする"
        ]
    ]
    
    var userDetails = [
        "sercret"     : "jo8nefamehisd",
        "action"      : "api",
        "ac"          : "get_userinfo",
        "d"           : "0",
        "lang"        : "en",
        "user_id"     : "\(globalUserId.userID)",
    ]
    
    var timelineViewController: UIViewController!
    var configurationViewControllers: UIViewController!
    var viewControllers: [UIViewController]!
    
    var user_id: String!
    var stringName: String!
    var language: String!
    var useEmail : String!
    var userPost = [String]()
    var userContent = [String]()
    var userDate = [String]()
    var fromID = [String]()
    
    var detailUser: SearchUser? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailUser = detailUser {
            if let username = self.username {
                username.text = detailUser.name
            }
        }
    }
    
    override func viewDidLoad() {
        
        language = setLanguage.appLanguage
        
        super.viewDidLoad()
        self.configureView()
        self.user_id = SearchDetailsView.searchIDuser
        self.mytabBar.delegate = self
        
        self.userSkills.numberOfLines = 0
        self.userSkills.sizeToFit()
        

        //load user information
        self.loadUserinfo(self.user_id)
        
        self.useEmail = SearchDetailsView.userEmail
        
        
        //set text button 
        btnMessage.setTitle(arrText["\(language)"]!["Message"], forState: .Normal)
        btnBlock.setTitle(arrText["\(language)"]!["Block"], forState: .Normal)
        
        
        //remov back title 
        self.navigationController?.navigationBar.topItem?.title = " "
        
        
        let db = FIRDatabase.database().reference().child("users")
        
        // GET CURRENT USER ID KEY
        let queryFirebase = db.queryOrderedByChild("email").queryEqualToValue("\(self.useEmail)")
        queryFirebase.observeSingleEventOfType(.Value, withBlock: { (snapshot)   in
            for snap in snapshot.children {
                let userSnap = snap as! FIRDataSnapshot
                let uid = userSnap.key //the uid of each user
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    firebaseId.userId = uid
                })
            }
        })
        
    
        //make it delegate..
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        
        
        self.mytableView.separatorStyle = .None

        //load user post 
        self.getTimelineUser()
        
        autoLayout()
        
    }
    
    func autoLayout() {
        
        mytabBar.translatesAutoresizingMaskIntoConstraints = false
        mytabBar.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        mytabBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mytabBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        mytabBar.heightAnchor.constraintEqualToConstant(50).active = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 64).active = true
        scrollView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        scrollView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        scrollView.bottomAnchor.constraintEqualToAnchor(mytabBar.topAnchor).active = true
        scrollView.contentSize = CGSizeMake(view.frame.width, view.frame.height)
        
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
        topView.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        topView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        topView.heightAnchor.constraintEqualToConstant(305).active = true
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.topAnchor.constraintEqualToAnchor(topView.topAnchor, constant: 5).active = true
        userImage.centerXAnchor.constraintEqualToAnchor(topView.centerXAnchor).active = true
        userImage.widthAnchor.constraintEqualToConstant(60).active = true
        userImage.heightAnchor.constraintEqualToConstant(60).active = true
        userImage.frame.size = CGSize(width: 60, height: 60)
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.topAnchor.constraintEqualToAnchor(userImage.bottomAnchor, constant: 5).active = true
        userName.centerXAnchor.constraintEqualToAnchor(topView.centerXAnchor).active = true
        userName.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        userName.heightAnchor.constraintEqualToConstant(26).active = true
        
        userHID.translatesAutoresizingMaskIntoConstraints = false
        userHID.topAnchor.constraintEqualToAnchor(userName.bottomAnchor, constant: 5).active = true
        userHID.centerXAnchor.constraintEqualToAnchor(topView.centerXAnchor).active = true
        userHID.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        userHID.heightAnchor.constraintEqualToConstant(25).active = true
        
        userSkills.translatesAutoresizingMaskIntoConstraints = false
        userSkills.topAnchor.constraintEqualToAnchor(userHID.bottomAnchor, constant: 5).active = true
        userSkills.centerXAnchor.constraintEqualToAnchor(topView.centerXAnchor).active = true
        userSkills.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        userSkills.heightAnchor.constraintEqualToConstant(47).active = true
        
        userDesription.translatesAutoresizingMaskIntoConstraints = false
        userDesription.topAnchor.constraintEqualToAnchor(userHID.bottomAnchor, constant: 5).active = true
        userDesription.centerXAnchor.constraintEqualToAnchor(userSkills.centerXAnchor).active = true
        userDesription.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        userDesription.heightAnchor.constraintEqualToConstant(75).active = true
        
        btnMessage.translatesAutoresizingMaskIntoConstraints = false
        btnMessage.bottomAnchor.constraintEqualToAnchor(topView.bottomAnchor, constant: -10).active = true
        btnMessage.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 10).active = true
        btnMessage.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 1/2, constant: -20).active = true
        btnMessage.heightAnchor.constraintEqualToConstant(42).active = true
        
        btnBlock.translatesAutoresizingMaskIntoConstraints = false
        btnBlock.bottomAnchor.constraintEqualToAnchor(topView.bottomAnchor, constant: -10).active = true
        btnBlock.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        btnBlock.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 1/2, constant: -20).active = true
        btnBlock.heightAnchor.constraintEqualToConstant(42).active = true
        
        if self.user_id == globalUserId.userID {
            btnBlock.hidden = true
            btnMessage.hidden = true
        }
        
    }
    
    func loadUserinfo(sender: String) {
        
        //user Data...
        var name: String!
        var image: String!
        var skills: String!
        var message: String!
        var happID : String!
        
        
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "\(globalvar.GET_USER_INFO_ACTION)",
            "d"           : "0",
            "lang"        : "jp",
            "user_id"     : "\(sender)"
        ]

        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
     
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if json!["result"] != nil {
                    name    = json!["result"]!["name"] as! String
                    
                    if let _ = json!["result"]!["h_id"] as? NSNull {
                        happID = ""
                        self.userHID.hidden = true
                    } else {
                        happID = json!["result"]!["h_id"] as? String
                        self.userHID.hidden = false
                    }

                    
                    if let _ = json!["result"]!["icon"] as? NSNull {
                        image = ""
                    } else {
                        image = json!["result"]!["icon"] as? String
                    }
                    
                    
                    
                    if let _ = json!["result"]!["skills"] as? NSNull {
                        skills = ""
                        self.userSkills.hidden = true
                    } else {
                        skills = json!["result"]!["skills"] as? String
                        self.userSkills.hidden = false
                    }
                    
                    message = json!["result"]!["mess"] as! String
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
                    
                    let radius = min(self.userImage!.frame.width/2 , self.userImage!.frame.height/2)
                    self.userImage.layer.cornerRadius = radius
                    self.userImage.clipsToBounds = true
                    
                    let imageURL = image.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                    
                    let data = NSData(contentsOfURL: NSURL(string: "\(imageURL)")!)
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        
                        self.userName.text = name
                        self.userSkills.text = skills
                        self.userDesription.text = message
                        self.userHID.text = happID
                        
                        //pass the name of the user to send teh message
                        firebaseId.userName = name
                        
                                        
                        if data != nil {
                            self.userImage.image = UIImage(data: data!)
                        } else {
                            self.userImage.image = UIImage(named: "noPhoto")
                        }
                    })
                })

            
                
            } catch {
                print(error)
            }
            
        }
        task.resume()

    
    }


     func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {

        if(item.tag == 0) {
            self.goToTimeline()
        } else if(item.tag == 1) {
            self.goToMessages()
        }
        else if(item.tag == 2) {
            self.goToReservation()
        }
        else if(item.tag == 3) {
            self.goToSituation()
        } else {
            self.goToConfiguration()
        }
        
    }
    
    func getTimelineUser() {
        
        //get usertimeline parameters...
        let getTimeline = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_timeline",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(self.user_id)",
        ]
        
        let httpRequest = HttpDataRequest(postData: getTimeline)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                
                if let resultArray = json!.valueForKey("result") as? NSArray {
                    
                    for item in resultArray {
                        
                        if let resultDict = item as? NSDictionary {
                            let timeline_id = resultDict["fields"]!["from_user_id"]! as! String
                            if timeline_id != self.user_id {
                                continue
                            }
                            
                            if let userPostModied = resultDict.valueForKey("post_modified") {
                                self.userDate.append(userPostModied as! String)
                            }
                            
                            if let postContent = resultDict.valueForKey("fields")  {
                                
                                if let body = postContent.valueForKey("body") {
                                    self.userContent.append(body as! String)
                                }
                                if let body = postContent.valueForKey("from_user_id") {
                                    self.fromID.append(body as! String)
                                }
                            }
                        }
                        
                    }
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.mytableView.reloadData()
                        }
                    }
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userContent.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.mytableView.dequeueReusableCellWithIdentifier("userCellPost", forIndexPath: indexPath) as! onlyUserPost
        cell.userPostContent.text = self.userContent[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 1.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)
        
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func goToTimeline() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("UserTimeline") as! UserTimelineViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    func goToMessages() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Messages") as! MessageTableViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    func goToReservation() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Reservation") as! ReservationViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    func goToSituation() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Congestion") as! CongestionViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    func goToConfiguration() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Configuration") as! ConfigurationViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    



}
