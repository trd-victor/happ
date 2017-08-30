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

class SearchDetailViewController: UIViewController, UITabBarDelegate {

   
    @IBOutlet var mytabBar: UITabBar!
    @IBOutlet var username: UILabel!
    
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userHID: UILabel!
    @IBOutlet var userSkills: UILabel!
    @IBOutlet var userDesription: UITextView!
    
    @IBOutlet var btnMessage: UIButton!
    @IBOutlet var btnBlock: UIButton!
    
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
    
    
    var timelineViewController: UIViewController!
    var configurationViewControllers: UIViewController!
    var viewControllers: [UIViewController]!
    
    var user_id: String!
    var stringName: String!
    var language: String!
    var useEmail : String!
    
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
//        print(self.user_id)
        
        self.useEmail = SearchDetailsView.userEmail
        
//        print(self.useEmail)
        
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
//                  print("\(uid)")
                    firebaseId.userId = uid
//                    print(uid)
                })
            }
        })
        
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
                    
                    if let happIDuser = json!["result"]!["h_id"] as? NSNull {
                        happID = "" as? String
                        self.userHID.hidden = true
                    } else {
                        happID = json!["result"]!["h_id"] as? String
                        self.userHID.hidden = false
                    }

                    
                    if let imageuser = json!["result"]!["icon"] as? NSNull {
                        image = "" as? String
                    } else {
                        image = json!["result"]!["icon"] as? String
                    }
                    
                    
                    
                    if let skillsUser = json!["result"]!["skills"] as? NSNull {
                        skills = "" as? String
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
                            self.userImage.image = UIImage(named: "photo")
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
