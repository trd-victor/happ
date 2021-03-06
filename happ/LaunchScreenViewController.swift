//
//  LaunchScreenViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 29/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

class SYSTEM_CONFIG {
    internal var SYS_VAL = NSUserDefaults.standardUserDefaults()
    
    internal func setSYS_VAL(array: AnyObject, key: String){
        if self.SYS_VAL.valueForKey(key) != nil {
            self.SYS_VAL.removeObjectForKey(key)
        }
        self.SYS_VAL.setValue(array, forKey: key)
        self.SYS_VAL.synchronize()
    }
    
    internal func getSYS_VAL(key: String) -> AnyObject?{
        return self.SYS_VAL.valueForKey(key)
    }
    
    internal func removeSYS_VAL(key: String) {
        if self.SYS_VAL.valueForKey(key) != nil {
            self.SYS_VAL.removeObjectForKey(key)
        }
    }
    
    /**
     * @param key as String
     * System Language
     **/
    internal func translate(key: String) -> String {
        if var lang = self.getSYS_VAL("AppLanguage") as? String {
            if let textTranslate = self.getSYS_VAL("SYSTM_VAL") {
                if lang == "ja" {
                    lang = "jp"
                }else if lang == "en"{
                    lang = "en"
                }else{
                    lang = "jp"
                }
                
                if let translate = textTranslate[key] as? NSDictionary {
                    if let text = translate[lang] as? String {
                        return text
                    }else{
                        return ""
                    }
                }else{
                    return ""
                }
            }else{
                return ""
            }
        }else{
            return ""
        }
    }
    
    internal func getTranslate(key: String, lang: String) -> String {
        if let textTranslate = self.getSYS_VAL("SYSTM_VAL") as? NSDictionary {
            
            if let key_text = textTranslate[key] as? NSDictionary{
                if let text = key_text[lang] as? String {
                    return text
                }else{
                    return ""
                }
            }else{
                return ""
            }
        }else{
            return ""
        }
    }

    
    internal func getSkillByID(id: String) -> String {
        var lang = self.getSYS_VAL("AppLanguage") as? String
        let skills = self.getSYS_VAL("SYSTM_SKILL") as? NSDictionary
        if lang! == "ja" {
            lang = "jp"
        }
        if (Int(id) != nil){
            if skills![id] != nil {
                return String(skills![id]![lang!]!!)
            }
            return ""
        }else{
            return id
        }
    }
}

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet var logo: UIImageView!
    var myTimer : NSTimer!
    var language: String!
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.activityIndicatorViewStyle = .Gray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        autoLayout()
        
        //setup Views..
        self.setUpView()
        
        
        //Setup Configurations
    }
    
    func autoLayout() {
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        logo.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
        logo.image = UIImage(named: "logo")
        activityIndicator.topAnchor.constraintEqualToAnchor(logo.bottomAnchor, constant: 5).active = true
        activityIndicator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        activityIndicator.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        activityIndicator.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    override func viewDidAppear(animated: Bool) {
        activityIndicator.startAnimating()
        self.isAppAlreadyLaunchedOnce()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let systemLang = userDefaults.valueForKey("AppLanguage") {
            setLanguage.appLanguage = systemLang as! String
            self.language = setLanguage.appLanguage
        } else {
            setLanguage.appLanguage = "en"
            self.language = setLanguage.appLanguage
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func gotoMainBoard() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            let config = SYSTEM_CONFIG()
            if let userid = config.getSYS_VAL("userID") as? String {
                if let fid = currentUser.uid as? String{
                    globalUserId.FirID = fid
                    globalUserId.userID = userid
                    config.setSYS_VAL(globalUserId.FirID, key: "FirebaseID")
                    if let token = FIRInstanceID.instanceID().token() {
                        dispatch_async(dispatch_get_main_queue()){
                            FIRDatabase.database().reference().child("registration-token").child(fid).child("token").setValue(token)
                        }
                    }
                    
                    let userTimeLineController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
                    self.presentViewController(userTimeLineController, animated:true, completion:nil)
                }else{
                    let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainBoard") as! ViewController
                    self.presentViewController(mainViewController, animated:false, completion:nil)
                }
            }else{
                let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainBoard") as! ViewController
                self.presentViewController(mainViewController, animated:false, completion:nil)
            }
        }else {
            let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainBoard") as! ViewController
            self.presentViewController(mainViewController, animated:false, completion:nil)
        }
    }
    
    func delayLaunchScreen() {
        self.activityIndicator.stopAnimating()
        dispatch_async(dispatch_get_main_queue()){
            self.dismissViewControllerAnimated(false, completion: nil)
            self.gotoMainBoard()
        }
    }
    
    func setUpView() {
        let viewbg = UIView()
        viewbg.backgroundColor = UIColor(hexString: "#eeeeee")
        view.addSubview(viewbg)
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let system = SYSTEM_CONFIG()
        
        let config = getSystemValue()
        
        config.getCallBackKey(){ (success: Bool) in
            config.getCallbackSkill(){ (success: Bool) in
                self.getCallbackUserInfo(){
                    (success: Bool) in
                    let defaults = NSUserDefaults.standardUserDefaults()
                    
                    if let _ = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
                        if let _ = system.getSYS_VAL("AppLanguage") as? String{
                            self.delayLaunchScreen()
                        }else {
                            dispatch_async(dispatch_get_main_queue()){
                                self.firstload()
                            }
                        }
                    }else{
                        defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
                        
                        self.activityIndicator.stopAnimating()
                        do {
                            try FIRAuth.auth()?.signOut()
                            
                            let sys = SYSTEM_CONFIG()
                            sys.removeSYS_VAL("userID")
                            globalUserId.userID = ""
                            UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                        } catch (let error) {
                            print((error as NSError).code)
                        }
                        dispatch_async(dispatch_get_main_queue()){
                            self.firstload()
                        }
                    }
                }
            }
        }
        return true
    }
        
    func getAllUserInfo() {
        let config = SYSTEM_CONFIG()
        
        let parameters = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "user_search",
            "d"           : "0",
            "lang"        : "en"
        ]
        
        let request1 = NSMutableURLRequest(URL: globalvar.API_URL)
        let boundary1 = generateBoundaryString()
        request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
        request1.HTTPMethod = "POST"
        request1.HTTPBody = createBodyWithParameters(parameters, boundary: boundary1)
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1) {
            data1, response1, error1 in
            if error1 != nil || data1 == nil{
                self.getAllUserInfo()
            }else{
                do {
                    if let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if let info = json2["result"] as? NSArray {
                            for profile in info {
                                config.setSYS_VAL(String(profile["user_id"]!!), key: "userid_\(profile["user_id"]!!)")
                                config.setSYS_VAL(profile["name"]!!, key: "username_\(profile["user_id"]!!)")
                                if let url = profile["icon"] as? String {
                                    config.setSYS_VAL(url, key: "userimage_\(profile["user_id"]!!)")
                                }else{
                                    config.setSYS_VAL("null", key: "userimage_\(profile["user_id"]!!)")
                                }
                                config.setSYS_VAL(profile["skills"]!!, key: "user_skills_\(profile["user_id"]!!)")
                                config.setSYS_VAL(profile["email"]!!, key: "useremail_\(profile["user_id"]!!)")
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task2.resume()
    }
    
    func getCallbackUserInfo(completion: (success: Bool)-> Void) {
        let config = SYSTEM_CONFIG()
        
        let parameters = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "user_search",
            "d"           : "0",
            "lang"        : "en"
        ]
        
        let request1 = NSMutableURLRequest(URL: globalvar.API_URL)
        let boundary1 = generateBoundaryString()
        request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
        request1.HTTPMethod = "POST"
        request1.HTTPBody = createBodyWithParameters(parameters, boundary: boundary1)
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1) {
            data1, response1, error1 in
            if error1 != nil || data1 == nil{
                self.getCallbackUserInfo(completion)
            }else{
                do {
                    if let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if let info = json2["result"] as? NSArray {
                            for profile in info {
                                config.setSYS_VAL(String(profile["user_id"]!!), key: "userid_\(profile["user_id"]!!)")
                                config.setSYS_VAL(profile["name"]!!, key: "username_\(profile["user_id"]!!)")
                                if let url = profile["icon"] as? String {
                                    config.setSYS_VAL(url, key: "userimage_\(profile["user_id"]!!)")
                                }else{
                                    config.setSYS_VAL("null", key: "userimage_\(profile["user_id"]!!)")
                                }
                                config.setSYS_VAL(profile["skills"]!!, key: "user_skills_\(profile["user_id"]!!)")
                                config.setSYS_VAL(profile["email"]!!, key: "useremail_\(profile["user_id"]!!)")
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue()){
                            completion(success: true)
                        }
                    }else{
                        self.getCallbackUserInfo(completion)
                    }
                } catch {
                    self.getCallbackUserInfo(completion)
                }
            }
        }
        task2.resume()
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
    
    func firstload() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ChooseLanguage") as! FirstLaunchLanguage
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    
}