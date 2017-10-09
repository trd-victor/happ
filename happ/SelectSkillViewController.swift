//
//  SelectSkillViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 06/10/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase


class SelectSkillViewController: UIViewController {
    
    let scrollView: UIScrollView = UIScrollView()
    let navBar: UINavigationBar = UINavigationBar()
    let categoryBox: UIView = UIView()
    var box: NSLayoutConstraint?
    var currentSkill = [Int]()
    
    var height = 0
    var loadingScreen: UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "#272727")
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.navBar)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.categoryBox)
        self.scrollView.scrollEnabled = true
        
        self.currentSkill = reg_user.selectedSkills
        
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
        loadingScreen = UIViewController.displaySpinner(self.view)
        
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
                                        }
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    if self.loadingScreen != nil {
                        UIViewController.removeSpinner(self.loadingScreen)
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
                }else{
                    skillSwitch.tag = 0
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
            reg_user.selectedSkills.append(sender.tag)
            sender.setOn(true, animated: true)
        }else{
            for var i = 0; i < reg_user.selectedSkills.count; i++ {
                if reg_user.selectedSkills[i] == sender.tag {
                    reg_user.selectedSkills.removeAtIndex(i)
                }
            }
            sender.setOn(false, animated: true)
        }
    }
    
    func loadConfig(){
        let config = SYSTEM_CONFIG()
        let navItem = UINavigationItem(title: config.translate("selection_skill"))
        let btnBack = UIBarButtonItem(image: UIImage(named: "Image"), style: .Plain, target: self, action: Selector("backToPreviousView"))
        btnBack.tintColor = UIColor.whiteColor()
        
        //closer to left anchor nav
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15
        
        navItem.setLeftBarButtonItems([negativeSpacer, btnBack], animated: false)
        
        let saveBtn = UIBarButtonItem(title: config.translate("button_save"), style: .Plain, target: self, action: "saveSkill")
        saveBtn.tintColor = UIColor.whiteColor()
        navItem.setRightBarButtonItem(saveBtn, animated: false)
        
        self.navBar.setItems([navItem], animated: false)
        self.navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    func saveSkill(){
        reg_user.didUpdate = true
        
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.dissmissDetail()
    }
    
    func backToPreviousView(){
        reg_user.selectedSkills = self.currentSkill
        
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.dissmissDetail()
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
    
    func dissmissDetail(){
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        self.dismissViewControllerAnimated(false, completion: nil)
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
    }
    
}