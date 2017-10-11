//
//  SelectSkillViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 06/10/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

struct timeline_post_skills {
    static var selectedSkills = [Int]()
    static var didUpdate: Bool = false
}

struct timeline_create_post {
    static var imgView1: UIImageView = UIImageView()
    static var imgView2: UIImageView = UIImageView()
    static var imgView3: UIImageView = UIImageView()
    static var content: String = ""
}

class CreateTimelineSkillSelection: UIViewController {
    
    let viewLoading: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.6
        view.hidden = true
        return view
    }()
    
    let activityLoading: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.activityIndicatorViewStyle = .WhiteLarge
        return view
    }()
    
    let scrollView: UIScrollView = UIScrollView()
    let navBar: UINavigationBar = UINavigationBar()
    let categoryBox: UIView = UIView()
    var box: NSLayoutConstraint?
    var currentSkill = [Int]()
    
    var height = 48
    var loadingScreen: UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let config = SYSTEM_CONFIG()
        
        self.view.backgroundColor = UIColor(hexString: "#272727")
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.navBar)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.categoryBox)
        self.scrollView.scrollEnabled = true
        
        let skillBox: UIView = UIView(frame: CGRect(x: 0.0, y: 0, width: self.view.layer.frame.size.width, height: 48))
        
        let skillName: UILabel = UILabel()
        let skillSwitch: UISwitch = UISwitch()
        let separator: UIView = UIView()
        
        skillBox.addSubview(skillSwitch)
        skillBox.addSubview(skillName)
        
        skillBox.addSubview(separator)
        
        skillSwitch.addTarget(self, action: "switchBtnToggle:", forControlEvents: UIControlEvents.ValueChanged)
        
        skillName.translatesAutoresizingMaskIntoConstraints = false
        skillName.centerYAnchor.constraintEqualToAnchor(skillBox.centerYAnchor).active = true
        skillName.leftAnchor.constraintEqualToAnchor(skillBox.leftAnchor, constant: 10).active = true
        skillName.widthAnchor.constraintEqualToAnchor(skillBox.widthAnchor, constant: -50).active = true
        skillName.text = config.translate("all_users")
        
        skillSwitch.translatesAutoresizingMaskIntoConstraints = false
        skillSwitch.frame.size = CGSizeMake(51, 31)
        skillSwitch.centerYAnchor.constraintEqualToAnchor(skillBox.centerYAnchor).active = true
        skillSwitch.rightAnchor.constraintEqualToAnchor(skillBox.rightAnchor, constant: -10).active = true
        skillSwitch.tag = 0
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraintEqualToAnchor(skillBox.bottomAnchor).active = true
        separator.leftAnchor.constraintEqualToAnchor(skillBox.leftAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(skillBox.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        separator.backgroundColor = UIColor(hexString: "#DDDDDD")
        
        self.categoryBox.addSubview(skillBox)
        
        view.addSubview(viewLoading)
        view.bringSubviewToFront(viewLoading)
        viewLoading.backgroundColor = UIColor.grayColor()
        viewLoading.addSubview(activityLoading)
        
        autoLayout()
        loadConfig()
        self.loadSkill()
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, CGFloat(self.height + 200))
        self.box?.constant = CGFloat(self.height)
        self.view.layoutIfNeeded()
    }
    
    func loadSkill(){
        if loadingScreen == nil {
            loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        var language = setLanguage.appLanguage
        
        if language == "ja" {
            language = "jp"
        }
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(URL: globalvar.API_URL)
        
        //set boundary string..
        let boundary = generateBoundaryString()
        
        //set value for image upload
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //setting the method to post
        request.HTTPMethod = "POST"
        
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_skill",
            "d"           : "0",
            "lang"        : "\(language)",
            "with_cat"     : "1"
        ]
        
        //adding the parameters to request body
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            
            if error != nil || data == nil{
                print("error kay ", error)
                if self.loadingScreen != nil {
                    UIViewController.removeSpinner(self.loadingScreen)
                    self.loadingScreen = nil
                }
                self.loadSkill()
            }else{
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    var count = 0
                    dispatch_async(dispatch_get_main_queue()){
                        if let _ = json!["success"] {
                            if let result = json!["result"] as? NSArray{
                                for(value) in result {
                                    count++
                                    if let children = value["children"] as? NSArray {
                                        dispatch_async(dispatch_get_main_queue()){
                                            self.addSubSkill(value["name"] as! String, children: children)
                                        }
                                    }
                                    
                                    if count == result.count {
                                        if self.loadingScreen != nil {
                                            UIViewController.removeSpinner(self.loadingScreen)
                                            self.loadingScreen = nil
                                        }
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    if self.loadingScreen != nil {
                        UIViewController.removeSpinner(self.loadingScreen)
                        self.loadingScreen = nil
                    }
                    print("error kay2 ", error)
                }
                
            }
            
        }
        task.resume()
        
    }
    
    func addSubSkill(title: String, children: NSArray){
        let subTitle: UILabel = UILabel(frame: CGRect(x: 0.0, y: CGFloat(self.height), width: self.view.layer.frame.size.width, height: 38.0))
        subTitle.backgroundColor = UIColor(hexString: "#e9dbc6")
        subTitle.textAlignment = .Center
        self.categoryBox.addSubview(subTitle)
        subTitle.text = title
        self.height = self.height + 38
        for (value) in children {
            if let data = value as? NSDictionary {
                let skillBox: UIView = UIView(frame: CGRect(x: 0.0, y: CGFloat(self.height), width: self.view.layer.frame.size.width, height: 48))
                
                let skillName: UILabel = UILabel()
                let skillSwitch: UISwitch = UISwitch()
                let separator: UIView = UIView()
                
                skillBox.addSubview(skillSwitch)
                skillBox.addSubview(skillName)
                
                skillBox.addSubview(separator)
                
                skillSwitch.addTarget(self, action: "switchBtnToggle:", forControlEvents: UIControlEvents.ValueChanged)
                
                skillName.translatesAutoresizingMaskIntoConstraints = false
                skillName.centerYAnchor.constraintEqualToAnchor(skillBox.centerYAnchor).active = true
                skillName.leftAnchor.constraintEqualToAnchor(skillBox.leftAnchor, constant: 10).active = true
                skillName.widthAnchor.constraintEqualToAnchor(skillBox.widthAnchor, constant: -50).active = true
                
                skillSwitch.translatesAutoresizingMaskIntoConstraints = false
                skillSwitch.frame.size = CGSizeMake(51, 31)
                skillSwitch.centerYAnchor.constraintEqualToAnchor(skillBox.centerYAnchor).active = true
                skillSwitch.rightAnchor.constraintEqualToAnchor(skillBox.rightAnchor, constant: -10).active = true
                
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.topAnchor.constraintEqualToAnchor(skillBox.bottomAnchor).active = true
                separator.leftAnchor.constraintEqualToAnchor(skillBox.leftAnchor).active = true
                separator.widthAnchor.constraintEqualToAnchor(skillBox.widthAnchor).active = true
                separator.heightAnchor.constraintEqualToConstant(1).active = true
                separator.backgroundColor = UIColor(hexString: "#DDDDDD")
                
                
                if let name = data["name"] as? String {
                    skillName.text = name
                }else {
                    skillName.text = ""
                }
                
                if let id = data["post_id"] as? Int{
                    skillSwitch.tag = id
                    
                    if reg_user.selectedSkills.contains(id) {
                        skillSwitch.setOn(true, animated: true)
                    }
                }
                
                self.height = self.height + 48
                self.categoryBox.addSubview(skillBox)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func switchBtnToggle(sender: UISwitch) {
        
        
        if sender.on {
            if sender.tag == 0 {
                timeline_post_skills.selectedSkills.removeAll()
                for subviews in view.subviews {
                    if let scrollview = subviews as? UIScrollView {
                        for subsubviews in scrollview.subviews {
                            for skillview in subsubviews.subviews {
                                for skillviewsubviews in skillview.subviews {
                                    if let swtch = skillviewsubviews as? UISwitch {
                                        swtch.setOn(true, animated: true)
                                        if swtch.tag != 0 {
                                            timeline_post_skills.selectedSkills.append(swtch.tag)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                timeline_post_skills.selectedSkills.append(sender.tag)
                sender.setOn(true, animated: true)
            }
        }else{
            if sender.tag == 0 {
                
                for subviews in view.subviews {
                    if let scrollview = subviews as? UIScrollView {
                        for subsubviews in scrollview.subviews {
                            for skillview in subsubviews.subviews {
                                for skillviewsubviews in skillview.subviews {
                                    if let swtch = skillviewsubviews as? UISwitch {
                                        swtch.setOn(false, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
                timeline_post_skills.selectedSkills.removeAll()
            }else{
                for var i = 0; i < timeline_post_skills.selectedSkills.count; i++ {
                    if timeline_post_skills.selectedSkills[i] == sender.tag {
                        timeline_post_skills.selectedSkills.removeAtIndex(i)
                    }
                }
                sender.setOn(false, animated: true)
            }
        }
    }
    
    func loadConfig(){
        let config = SYSTEM_CONFIG()
        let navItem = UINavigationItem(title: "")
        let btnBack = UIBarButtonItem(image: UIImage(named: "Image"), style: .Plain, target: self, action: Selector("backToPreviousView"))
        btnBack.tintColor = UIColor.whiteColor()
        
        //closer to left anchor nav
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15
        
        navItem.setLeftBarButtonItems([negativeSpacer, btnBack], animated: false)
        
        let saveBtn = UIBarButtonItem(title: config.translate("button_post"), style: .Plain, target: self, action: "saveSkill")
        saveBtn.tintColor = UIColor.whiteColor()
        navItem.setRightBarButtonItem(saveBtn, animated: false)
        
        self.navBar.setItems([navItem], animated: false)
        self.navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    func saveSkill(){
        
        if timeline_post_skills.selectedSkills.count == 0 {
            let config = SYSTEM_CONFIG()
            self.displayErrorMessage(config.translate("no_selected_skill"))
            return
        }
        
        let config = SYSTEM_CONFIG()
        let myAlert = UIAlertController(title: "", message: config.translate("mess_send_post_promt"), preferredStyle: UIAlertControllerStyle.ActionSheet)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
            self.viewLoading.hidden = false
            self.activityLoading.startAnimating()
            
            var body = timeline_create_post.content
            if body == config.translate("holder_post_content") {
                body = " "
            }
            var skills = ""
            for i in 0...(timeline_post_skills.selectedSkills.count - 1){
                skills += "\(timeline_post_skills.selectedSkills[i]),"
            }
            
            let postTimeline = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "update_timeline",
                "d"           : "0",
                "lang"        : "en",
                "user_id"     : "\(globalUserId.userID)",
                "body"        : "\(body)",
                "skills"      : "\(skills)"
            ]
            
            //save post data
            self.savePost(postTimeline)
            
        }))
        myAlert.addAction(UIAlertAction(title: config.translate("btn_cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func backToPreviousView(){
        self.dismissViewControllerAnimated(true, completion: nil)
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
    
    func autoLayout(){
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraintEqualToAnchor(self.navBar.bottomAnchor).active = true
        self.scrollView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        self.scrollView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        self.scrollView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        self.navBar.translatesAutoresizingMaskIntoConstraints = false
        self.navBar.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        self.navBar.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.navBar.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        self.navBar.heightAnchor.constraintEqualToConstant(66).active = true
        self.navBar.barTintColor = UIColor(hexString: "#272727")
        
        self.categoryBox.translatesAutoresizingMaskIntoConstraints = false
        self.categoryBox.topAnchor.constraintEqualToAnchor(self.scrollView.topAnchor).active = true
        self.categoryBox.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor).active = true
        self.categoryBox.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
        box = self.categoryBox.heightAnchor.constraintEqualToAnchor(self.scrollView.heightAnchor)
        box?.active = true
        
        viewLoading.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        viewLoading.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        viewLoading.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        viewLoading.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        activityLoading.centerXAnchor.constraintEqualToAnchor(viewLoading.centerXAnchor).active = true
        activityLoading.centerYAnchor.constraintEqualToAnchor(viewLoading.centerYAnchor).active = true
        activityLoading.widthAnchor.constraintEqualToAnchor(viewLoading.widthAnchor).active = true
        activityLoading.heightAnchor.constraintEqualToAnchor(viewLoading.heightAnchor).active = true
        
    }
    
    func savePost(parameters: [String: String]?) {

        var mess: Bool!
        let config = SYSTEM_CONFIG()
        
        let request1 = NSMutableURLRequest(URL: globalvar.API_URL)
        let boundary1 = generateBoundaryString()
        request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
        request1.HTTPMethod = "POST"
        
        
        request1.HTTPBody = createBodyWithParameters2(parameters, boundary: boundary1)
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1){
            data1, response1, error1 in
            
            if error1 != nil || data1 == nil{
                self.savePost(parameters)
            }else {
                do {
                    let json3 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    dispatch_async(dispatch_get_main_queue()) {
                        if json3!["success"] != nil {
                            mess = json3!["success"] as! Bool
                            let postID = json3!["result"] as? Int
                            
                            let notif = NotifController()
                            notif.saveNotificationMessage(postID!, type: "timeline")
                        }
                        
                        if mess != nil && mess == true {
                            NSNotificationCenter.defaultCenter().postNotificationName("reloadTimeline", object: nil, userInfo: nil)
                            self.displayMyAlertMessage(config.translate("saved_post"))
                        }
                    }
                    
                } catch {
                    print(error)
                }
                
            }
            
        }
        task2.resume()
        
    }
    
    func createBodyWithParameters2(parameters: [String: String]?,  boundary: String) -> NSData {
        let body = NSMutableData();
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        if timeline_create_post.imgView1.image != nil {
            body.appendString("--\(boundary)\r\n")
            let imageData = UIImageJPEGRepresentation(timeline_create_post.imgView1.image!,0.5)
            let fileName = "\(randomString(16))-\(randomString(16)).jpg"
            body.appendString("Content-Disposition: form-data; name=\"images[0]\"; filename=\"\(fileName)\"\r\n")
            body.appendString("Content-Type: image/jpg \r\n\r\n")
            body.appendData(imageData!)
            body.appendString("\r\n")
        }
        if timeline_create_post.imgView2.image != nil {
            body.appendString("--\(boundary)\r\n")
            let imageData = UIImageJPEGRepresentation(timeline_create_post.imgView2.image!,0.5)
            let fileName = "\(randomString(16))-\(randomString(16)).jpg"
            body.appendString("Content-Disposition: form-data; name=\"images[1]\"; filename=\"\(fileName)\"\r\n")
            body.appendString("Content-Type: image/jpg \r\n\r\n")
            body.appendData(imageData!)
            body.appendString("\r\n")
        }
        if timeline_create_post.imgView3.image != nil {
            body.appendString("--\(boundary)\r\n")
            let imageData = UIImageJPEGRepresentation(timeline_create_post.imgView3.image!,0.5)
            let fileName = "\(randomString(16))-\(randomString(16)).jpg"
            body.appendString("Content-Disposition: form-data; name=\"images[2]\"; filename=\"\(fileName)\"\r\n")
            body.appendString("Content-Type: image/jpg \r\n\r\n")
            body.appendData(imageData!)
            body.appendString("\r\n")
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.characterAtIndex(Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func displayMyAlertMessage(userMessage:String){
        if self.loadingScreen != nil {
            UIViewController.removeSpinner(self.loadingScreen)
            self.loadingScreen = nil
        }
        
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.viewLoading.hidden = true
            self.activityLoading.stopAnimating()
            let presentingViewController = self.presentingViewController
            self.dismissViewControllerAnimated(false, completion: {
                presentingViewController!.dismissViewControllerAnimated(true, completion: {})
            })
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func displayErrorMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.viewLoading.hidden = true
            self.activityLoading.stopAnimating()
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    
}