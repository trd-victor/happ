//
//  CurrentSettingsViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 26/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit



class CurrentSettingsViewController: UIViewController {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var separator: UIView!
    @IBOutlet var imgRightLang: UIImageView!
    @IBOutlet var currentSettingslang: UILabel!
    @IBOutlet var btnCurrentSettings: UIButton!
    
    @IBOutlet var navBackLang:
    UIBarButtonItem!
    
    @IBOutlet var navTitle: UINavigationItem!
    
    @IBOutlet var savelang:
    UIBarButtonItem!
    var userId: String!
    var language: String!
    
    let config = SYSTEM_CONFIG()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId = globalUserId.userID
    
        //load language set.
        language = setLanguage.appLanguage

        //set button text..
        self.loadConfigure()
        
        self.loadCurrentUserLang()
        self.savelang.action = Selector("saveLang:")
        self.navBackLang.action = Selector("backToConfiguration:")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "englishLang:", name: "changeLang", object: nil)
        autoLayout()
    }
    
    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        btnCurrentSettings.translatesAutoresizingMaskIntoConstraints = false
        btnCurrentSettings.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnCurrentSettings.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        btnCurrentSettings.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -20).active = true
        btnCurrentSettings.heightAnchor.constraintEqualToConstant(38).active = true
        
        
        imgRightLang.translatesAutoresizingMaskIntoConstraints = false
        imgRightLang.rightAnchor.constraintEqualToAnchor(btnCurrentSettings.rightAnchor).active = true
        imgRightLang.topAnchor.constraintEqualToAnchor(btnCurrentSettings.topAnchor, constant: 5).active = true
        imgRightLang.widthAnchor.constraintEqualToConstant(30).active = true
        imgRightLang.heightAnchor.constraintEqualToConstant(30).active = true
        
        currentSettingslang.translatesAutoresizingMaskIntoConstraints = false
        currentSettingslang.rightAnchor.constraintEqualToAnchor(btnCurrentSettings.rightAnchor, constant: -35).active = true
        currentSettingslang.topAnchor.constraintEqualToAnchor(btnCurrentSettings.topAnchor).active = true
        currentSettingslang.widthAnchor.constraintEqualToConstant(100).active = true
        currentSettingslang.heightAnchor.constraintEqualToConstant(38).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator.topAnchor.constraintEqualToAnchor(btnCurrentSettings.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
    }
    
    func englishLang(notification: NSNotification) {
        let lang = changeLang.lang
        
        if lang == "en" {
            self.currentSettingslang.text = lang
        } else {
            self.currentSettingslang.text = lang
        }
    }

    func loadConfigure() {
        let config = SYSTEM_CONFIG()
        btnCurrentSettings.setTitle(config.translate("label_current settings"), forState: .Normal)
        navTitle.title = config.translate("title_language_settings")
        savelang.title = config.translate("button_save")
        let lang = changeLang.lang
        if lang == "en" {
            self.currentSettingslang.text = config.translate("label_en")
        } else {
            self.currentSettingslang.text = config.translate("label_ja")
        }
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
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
    
    func changeSysLang() {
        
        // self controller load
        self.loadConfigure()
        
        // other controller load
        NSNotificationCenter.defaultCenter().postNotificationName("refreshUserTimeline", object: nil, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("refreshMessage", object: nil, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("refreshSituation", object: nil, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("refreshConfig", object: nil, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("refreshMenu", object: nil, userInfo: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadTimeline", object: nil, userInfo: nil)
        
    }
    
    func saveLang(sender: UIBarButtonItem) ->() {
        
        let new_lang = self.currentSettingslang.text!
        
        
        if new_lang == "English" || new_lang == "EnglishJP" {
            self.changeLanguage("en")
            self.currentSettingslang.text = new_lang
        } else {
            self.changeLanguage("ja")
            self.currentSettingslang.text = new_lang
        }
        
        self.changeSysLang()
        
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
        let targets = "change_lang"
        
        if language == "ja" {
            language = "jp"
        }
        
        //set parameters...
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "user_update",
            "d"           : "0",
            "lang"        : "\(language)",
            "user_id"     : "\(userId)",
            "change_lang" : "\(self.currentSettingslang.text!)",
            "targets"     : "\(targets)"
        ]
        
        //adding the parameters to request body
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil{
                print("\(error)")
                return;
            }
        }
        task.resume()

    }
    
    func changeLanguage(sender : String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(sender, forKey: "AppLanguage")
        userDefaults.synchronize()
    }
    
    
    func loadCurrentUserLang() {
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
        
        if language == "ja" {
            language = "jp"
        }
        
        //set parameters...
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_userinfo",
            "d"           : "0",
            "lang"        : "\(language)",
            "user_id"     : "\(userId)"
        ]
        
        //adding the parameters to request body
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            //user Data...
            var lang: String!

            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if json!["result"] != nil {
                    lang    = json!["result"]!["lang"] as! String
                }
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if changeLang.lang == "" {
                        
                        if lang == "en" {
                            self.currentSettingslang.text = "English"
                        } else {
                            self.currentSettingslang.text = "日本語"
                        }
                        
                    } else {
                        self.currentSettingslang.text = changeLang.lang
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
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
}
