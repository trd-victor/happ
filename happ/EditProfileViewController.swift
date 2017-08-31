//
//  EditProfileViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 26/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var navBackProfile: UIBarButtonItem!
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var StatusItem: UIBarButtonItem!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var labelSkills: UILabel!
    @IBOutlet var userDescription: UITextField!
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var userNamefield: UITextField!
    
    //skills label..
    @IBOutlet var labelfrontEnd: UILabel!
    @IBOutlet var labelbackend: UILabel!
    @IBOutlet var labelAndroid: UILabel!
    @IBOutlet var labelIOS: UILabel!
    @IBOutlet var labelAppDesign: UILabel!
    @IBOutlet var labelwebdesign: UILabel!
    

    //Switch variabel...
    @IBOutlet var fronendswitch: UISwitch!
    @IBOutlet var backendswitch: UISwitch!
    @IBOutlet var androidswitch: UISwitch!
    @IBOutlet var iosswitch: UISwitch!
    @IBOutlet var appdesignswitch: UISwitch!
    @IBOutlet var backdesignswithc: UISwitch!

    
    var arrText = [
    
        "en" : [
            "navTitle": "Edit profile",
            "save" : "Save",
            "name" : "Name",
            "nameplaceholder" : "15 characters or less",
            "descplaceholder" : "Enter a profile statement",
            "skills" : "Skills",
            "frontEnd":"Front End",
            "backEnd":"Back End",
            "ios":"iOS",
            "android":"Android",
            "appdesign":"Application Design",
            "webdesign":"Web Design"
        ],
        
        "ja" : [
            "navTitle": "プロフィールの編集",
            "save" : "保存する",
            "name" : "お名前",
            "nameplaceholder" : "15文字以内",
            "descplaceholder" : "プロフィール文を入力する",
            "skills" : "スキル",
            "frontEnd":"フロントエンド",
            "backEnd":"サーバーサイド",
            "ios":"iOSアプリ",
            "android":"Androidアプリ",
            "appdesign":"アプリデザイン",
            "webdesign":"ウェブデザイン"
        ]
    
    ]

    var language: String!
    var userId: String = ""
//    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set delegate ..
        userDescription.delegate = self
        userNamefield.delegate = self

        //load language set.
        language = setLanguage.appLanguage
        
        self.loadConfigure()
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, self.userDescription.frame.height))
        userDescription.leftView = paddingView
        userDescription.leftViewMode = UITextFieldViewMode.Always
        
        //get user Id...
        userId = globalUserId.userID
        
        if userId != "" {
            self.setRounded(userImage)
            self.loadUserData()
        }
        
        self.navBackProfile.action = Selector("backToConfiguration:")
        
//        //add it to the center...
//        myActivityIndicator.center = view.center
//        
//        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
//        myActivityIndicator.hidesWhenStopped = true
//        myActivityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
//        
//        view.addSubview(myActivityIndicator)
        
        view.endEditing(true)
        
    }
    
    func loadConfigure() {
        
        let config = SYSTEM_CONFIG()
        
        //set label text..
        navTitle.title = config.translate("title_edit_profile")
        StatusItem.title = config.translate("button_save")
        labelName.text = config.translate("text_name")
        userNamefield.placeholder = config.translate("holder_15_char/less")
        userDescription.placeholder = config.translate("holder_profile_statement")
        labelSkills.text = config.translate("subtitle_skills")
        labelfrontEnd.text = config.translate("label_front_end")
        labelbackend.text = config.translate("label_server_side")
        labelIOS.text = config.translate("label_IOS_application")
        labelAndroid.text = config.translate("label_android_application")
        labelAppDesign.text = config.translate("label_app_design")
        labelwebdesign.text = config.translate("label_web_design")
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
//        presentViewController(viewControllerToPresent, animated: false, completion: nil)
//        self.tabBarController?.presentViewController(viewControllerToPresent, animated: true, completion: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func backToConfiguration(sender: UIBarButtonItem) -> () {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserData() {
            //let URL
            let viewDataURL = "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php"
            
            //created NSURL
            let requestURL = NSURL(string: viewDataURL)
            
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(URL: requestURL!)
            
            //set boundary string..
            let boundary = generateBoundaryString()
            
            //set value for image upload
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            //setting the method to post
            request.HTTPMethod = "POST"
            
            //        if language == "ja" {
            //            language = "jp"
            //        }
            //        set parameters...
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "get_userinfo",
                "d"           : "0",
                "lang"        : "en",
                "user_id"     : "\(userId)"
            ]
    
            //adding the parameters to request body
            request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
//             self.myActivityIndicator.startAnimating()
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                //user Data...
                var name: String!
                var image: String!
                var skills: String!
                var message: String!
                
                if error != nil{
                    print("\(error)")
                    return;
                }
                do {
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if json!["result"] != nil {
                        name    = json!["result"]!["name"] as! String
//                        image1   = json!["result"]!["icon"] as! String
                        
                        if let imageuser = json!["result"]!["icon"] as? NSNull {
                             image = "" as? String
                        } else {
                            image = json!["result"]!["icon"] as? String
                        }
                        
                        
                        skills  = json!["result"]!["skills"] as! String
                       message = json!["result"]!["mess"] as! String
                    }
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
                        
                        let url = image.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                        
                        
                         let data = NSData(contentsOfURL: NSURL(string: "\(url)")!)
                        dispatch_async(dispatch_get_main_queue(), {() -> Void in
                           
                            self.userNamefield.text = name
                            if data != nil {
                                self.userImage.image = UIImage(data: data!)
                            } else {
                                self.userImage.image = UIImage(named: "noPhoto")
                            }
                           
                            self.userDescription.text = message
                            self.getSkillNotArray(self.returnSkillState(skills))
                        })
                    })

                    
                } catch {
                    print(error)
                }
                
            }
            task.resume()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func StatusItem(sender: AnyObject) {
        
        //setting up the textbox...
        let name = userNamefield.text!
        let userDesc = userDescription.text!
        
        
        if name == "" || userDesc == ""  {
            displayMyAlertMessage("All Fields Required")
        }
        else {
            //created NSURL
            let URL_SAVE_TEAM = "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php"
            
            //created NSURL
            let requestURL = NSURL(string: URL_SAVE_TEAM)
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(URL: requestURL!)
            
            //set boundary string..
            let boundary = generateBoundaryString()
            
            //set value for image upload
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            //setting the method to post
            request.HTTPMethod = "POST"

        
            //declaring button state
            let frontEndSkill   = fronendswitch
            let backEndSkill    = backendswitch
            let iosSkill        = iosswitch
            let androidSkill    = androidswitch
            let appDesignSkill  = appdesignswitch
            let webDesignSkill  = backdesignswithc
        
            //get state
            let frontEndState   = switchButtonCheck(frontEndSkill)
            let backEndState    = switchButtonCheck(backEndSkill)
            let iosState        = switchButtonCheck(iosSkill)
            let androidState    = switchButtonCheck(androidSkill)
            let appDesignState  = switchButtonCheck(appDesignSkill)
            let webDesignState  = switchButtonCheck(webDesignSkill)
        
            let skills: [Int: String] = [
                1  : "\(frontEndState)",
                2  : "\(backEndState)",
                3  : "\(iosState)",
                4  : "\(androidState)",
                5  : "\(appDesignState)",
                6  : "\(webDesignState)"
            ]
            let skills2 = returnSkillValue(skills)
            let targetedData: String = "name,skills,mess"
            
            
            //set parameters...
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "user_update",
                "d"           : "0",
                "lang"        : "\(language)",
                "user_id"     : "\(userId)",
                "name"        : "\(name)",
                "mess"        : "\(userDesc)",
                "skills"      : "\(skills2)",
                "targets"     : "\(targetedData)"
            ]
            
            //adding the parameters to request body
            request.HTTPBody = createBodyWithParameters(param,  boundary: boundary)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                var message: String!
                
                if error != nil{
                    print("error is \(error)")
                    return;
                }
                
                do {

                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if json!["message"] != nil {
                        message = json!["message"] as! String
                    }
                    
                    if json!["result"] != nil {
                        message = json!["result"]!["mess"] as! String
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var errorMessage: Int
                        if json!["error"] != nil {
                            errorMessage = json!["error"] as! Int
                            if errorMessage == 1 {
                                self.displayMyAlertMessage(message)
                            }
                        }
                        self.displayMyAlertMessage(message)
                    }
                    
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
    }
    
    //check state..
    func switchButtonCheck(switchButton : UISwitch) -> String {
        var State: String = ""
        if switchButton.on {
            State = "On"
        } else {
            State = "Off"
        }
        return State
    }
    
    //return skill value
    func returnSkillValue(parameters : [Int : String]?) -> String {
        var retString: String = "";
        if parameters != nil {
            for(key, value) in parameters! {
                if value != "On" { continue }
                retString += "\(key),"
            }
        }
        return retString
    }
    
    func returnSkillState(sender: String) -> [String] {
        let userSkills = sender.componentsSeparatedByString(",")
        return userSkills
    }
    
    func getSkillNotArray(sender: [String]) {
        for intskill in sender {
            self.switchButtonOn(intskill)
        }
    }
    func switchButtonOn(skill: String)  {
        if skill == "1" {
            self.fronendswitch.setOn(true, animated: true)
        }
        if skill == "2" {
            self.backendswitch.setOn(true, animated: true)
        }
        if skill == "3" {
            self.iosswitch.setOn(true, animated: true)
        }
        if skill == "4" {
            self.androidswitch.setOn(true, animated: true)
        }
       if skill == "5" {
            self.appdesignswitch.setOn(true, animated: true)
        }
      if skill == "6" {
            self.backdesignswithc.setOn(true, animated: true)
        }
    }
    
    
    func setRounded(sender: UIImageView) {
        let radius = min(sender.frame.width/2 , sender.frame.height/2)
        sender.layer.cornerRadius = radius
        sender.clipsToBounds = true
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
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
  

}
