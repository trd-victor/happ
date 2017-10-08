//
//  ViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 03/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit


struct setLanguage {
    static var appLanguage: String = ""
}

struct sysCache {
    var cache = NSCache()
}

class ViewController: UIViewController, UIScrollViewDelegate {
    
    /*variable declaration..*/
    @IBOutlet var btn_register: UIButton!
    @IBOutlet var btn_login: UIButton!
    var language: String!
    var scrollview : UIScrollView!
    @IBOutlet var changeLang: UIButton!
    
    @IBOutlet var testView: UIView!
    @IBOutlet var sView: UIScrollView!
    @IBOutlet var mView: UIView!
    @IBOutlet var subTopView: UIView!
    @IBOutlet var subBottomView: UIView!
    @IBOutlet var imageLogo: UIImageView!
    @IBOutlet var btnCLang: UIButton!
    
    //basepath
    let baseUrl: NSURL = NSURL(string: "http://dev.happ.timeriverdesign.com/wp-admin/admin-ajax.php")!
    
    var portrait: Bool = false
    var landscape: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAllViews()
        self.getAllUserInfo()
        
        let config = SYSTEM_CONFIG()
        if let count = config.getSYS_VAL("runningApp") as? Int {
            if count > 1 {
                self.btnCLang.hidden = true
            }
        }
        self.btnCLang.addTarget(self, action: Selector("gotoLang"), forControlEvents: .TouchUpInside)
    }
    
    func setupAllViews() {
        
        
        //set button border
        btnBorder(btn_register)
        btnBorder(btn_login)
        
        
        //set scrollview wiew width and height
        self.sView.frame.size = CGSizeMake(self.testView.frame.width,self.testView.frame.height + 200)
        
        //check orient and add autolayout..
        checkOrientation()
        autoLayout()
        
        loadConfigure()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadConfigure()
    }
    
    func gotoLang() {
                
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ChooseLanguage") as! FirstLaunchLanguage
        
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.addAnimation(transition, forKey: kCATransition)
        
        self.presentViewController(nextViewController, animated: false, completion: nil)
        
    }

    
    
    func displayTimestamp(ts: Double) -> String {
        let date = NSDate(timeIntervalSince1970: ts)
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.systemTimeZone()
        
        if NSCalendar.currentCalendar().isDateInToday(date) {
            formatter.dateStyle = .NoStyle
            formatter.timeStyle = .ShortStyle
        } else {
            formatter.dateStyle = .ShortStyle
            formatter.timeStyle = .NoStyle
        }
        
        return formatter.stringFromDate(date)
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
    
    
    func getAllUserInfo() {
        
        let config = SYSTEM_CONFIG()
        
        let parameters = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "user_search",
            "d"           : "0",
            "lang"        : "en"
        ]
        let request1 = NSMutableURLRequest(URL: self.baseUrl)
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
                    let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    if let info = json2!["result"] as? NSArray {
                        
                        for profile in info {
                            config.setSYS_VAL(String(profile["user_id"]!!), key: "userid_\(profile["user_id"]!!)")
                            config.setSYS_VAL(profile["name"]!!, key: "username_\(profile["user_id"]!!)")
                            if let url = profile["icon"] as? String {
                                config.setSYS_VAL(url, key: "userimage_\(profile["user_id"]!!)")
                            }else{
                                config.setSYS_VAL("null", key: "userimage_\(profile["user_id"]!!)")
                            }
                            config.setSYS_VAL(profile["email"]!!, key: "useremail_\(profile["user_id"]!!)")
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task2.resume()
    }
    
    func loadConfigure(){
        let config = SYSTEM_CONFIG()
    
        // Set Translations
        btn_register.setTitle(config.translate("button_regist"), forState: .Normal)
        btn_login.setTitle(config.translate("subtitle_Login"),forState: .Normal)
        self.btnCLang.setTitle(config.translate("sys_change_lang"), forState: .Normal)

    }
    
    //get sysetm value
    func get_system_val() -> AnyObject {
        let config = SYSTEM_CONFIG()
        let sysLang = config.getSYS_VAL("SYSTM_VAL")
        return sysLang!
    }
    
    //get language set by user..
    func get_language() -> String {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let systemLang = userDefaults.valueForKey("AppLanguage") {
            setLanguage.appLanguage = systemLang as! String
            self.language = setLanguage.appLanguage
        } else {
            setLanguage.appLanguage = "en"
            self.language = setLanguage.appLanguage
        }
        return self.language
    }
    
    func checkOrientation(){
        if UIDevice.currentDevice().orientation.isPortrait {
          self.portrait = true
        }else{
            self.landscape = true
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
            
            let orient = UIApplication.sharedApplication().statusBarOrientation
            
            switch orient {
            case .Portrait:
                if self.portrait == true {
                    self.sView.frame.size = CGSizeMake(self.testView.frame.width,self.testView.frame.height + 200)
                    self.mView.translatesAutoresizingMaskIntoConstraints = true
                    self.mView.frame.size = CGSizeMake(self.testView.frame.width,self.testView.frame.height)
                }else{
                    self.sView.frame.size = CGSizeMake(self.testView.frame.height,self.testView.frame.width + 200)
                    self.mView.translatesAutoresizingMaskIntoConstraints = true
                    self.mView.frame.size = CGSizeMake(self.testView.frame.height,self.testView.frame.width)
                    
                }
                self.view.layoutIfNeeded()
                print(self.sView.frame.size)
                break
                // Do something
            default:
                if self.portrait == true {
                    self.sView.frame.size = CGSizeMake(self.testView.frame.height,self.testView.frame.width + 200)
                    self.mView.translatesAutoresizingMaskIntoConstraints = true
                    self.mView.frame.size = CGSizeMake(self.testView.frame.height,self.testView.frame.width)
                }else{
                    self.sView.frame.size = CGSizeMake(self.testView.frame.width,self.testView.frame.height + 200)
                    self.mView.translatesAutoresizingMaskIntoConstraints = true
                    self.mView.frame.size = CGSizeMake(self.testView.frame.width,self.testView.frame.height)
                    
                }
                
                self.view.layoutIfNeeded()
                print(self.sView.frame.size)
                // Do something else
                break
            }
            }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
               
        })
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    
    
    func autoLayout(){
        
        self.testView.translatesAutoresizingMaskIntoConstraints = false
        self.testView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        self.testView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        self.testView.widthAnchor.constraintEqualToConstant(view.frame.width).active = true
        self.testView.heightAnchor.constraintEqualToConstant(view.frame.height).active = true
        
        self.mView.translatesAutoresizingMaskIntoConstraints = false
        self.mView.centerXAnchor.constraintEqualToAnchor(self.testView.centerXAnchor).active = true
        self.mView.centerYAnchor.constraintEqualToAnchor(self.testView.centerYAnchor).active = true
        self.mView.widthAnchor.constraintEqualToConstant(self.testView.frame.width).active = true
        self.mView.heightAnchor.constraintEqualToConstant(self.testView.frame.height).active = true
        
        self.subTopView.translatesAutoresizingMaskIntoConstraints = false
        self.subTopView.topAnchor.constraintEqualToAnchor(self.mView.topAnchor).active = true
        self.subTopView.leftAnchor.constraintEqualToAnchor(self.mView.leftAnchor).active = true
        self.subTopView.widthAnchor.constraintEqualToAnchor(self.mView.widthAnchor).active = true
        self.subTopView.heightAnchor.constraintEqualToAnchor(self.mView.heightAnchor, multiplier: 1/2).active = true
        
        self.subBottomView.translatesAutoresizingMaskIntoConstraints = false
        self.subBottomView.topAnchor.constraintEqualToAnchor(self.subTopView.bottomAnchor).active = true
        self.subBottomView.leftAnchor.constraintEqualToAnchor(self.mView.leftAnchor).active = true
        self.subBottomView.widthAnchor.constraintEqualToAnchor(self.mView.widthAnchor).active = true
        self.subBottomView.heightAnchor.constraintEqualToAnchor(self.mView.heightAnchor, multiplier: 1/2).active = true
        
        self.imageLogo.translatesAutoresizingMaskIntoConstraints = false
        self.imageLogo.centerXAnchor.constraintEqualToAnchor(self.subTopView.centerXAnchor).active = true
        self.imageLogo.centerYAnchor.constraintEqualToAnchor(self.subTopView.centerYAnchor).active = true
        self.imageLogo.widthAnchor.constraintEqualToConstant(193).active = true
        self.imageLogo.heightAnchor.constraintEqualToConstant(102).active = true
        
        self.btn_register.translatesAutoresizingMaskIntoConstraints = false
        self.btn_register.centerXAnchor.constraintEqualToAnchor(self.subBottomView.centerXAnchor).active = true
        self.btn_register.topAnchor.constraintEqualToAnchor(self.subBottomView.topAnchor, constant: 30).active = true
        self.btn_register.widthAnchor.constraintEqualToConstant(250).active = true
        self.btn_register.heightAnchor.constraintEqualToConstant(50).active = true
        
        self.btn_login.translatesAutoresizingMaskIntoConstraints = false
        self.btn_login.centerXAnchor.constraintEqualToAnchor(self.subBottomView.centerXAnchor).active = true
        self.btn_login.topAnchor.constraintEqualToAnchor(self.btn_register.bottomAnchor, constant: 20).active = true
        self.btn_login.widthAnchor.constraintEqualToConstant(250).active = true
        self.btn_login.heightAnchor.constraintEqualToConstant(50).active = true
        
        self.btnCLang.translatesAutoresizingMaskIntoConstraints = false
        self.btnCLang.bottomAnchor.constraintEqualToAnchor(subBottomView.bottomAnchor, constant: -10).active = true
        self.btnCLang.centerXAnchor.constraintEqualToAnchor(self.subBottomView.centerXAnchor).active = true
        self.btnCLang.widthAnchor.constraintEqualToConstant(200).active = true
        self.btnCLang.heightAnchor.constraintEqualToConstant(40).active = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sView.translatesAutoresizingMaskIntoConstraints = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func btnBorder(sender: UIButton) {
        sender.backgroundColor = UIColor.clearColor()
        sender.layer.cornerRadius = 2
        sender.layer.borderWidth = 1
        sender.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    

}
extension NSUserDefaults {
    // check for is first launch - only true on first invocation after app install, false on all further invocations
    static func isFirstLaunch() -> Bool {
        let firstLaunchFlag = "FirstLaunchFlag"
        let isFirstLaunch = NSUserDefaults.standardUserDefaults().stringForKey(firstLaunchFlag) == nil
        if (isFirstLaunch) {
            NSUserDefaults.standardUserDefaults().setObject("false", forKey: firstLaunchFlag)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        return isFirstLaunch
    }
}

