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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        self.isAppAlreadyLaunchedOnce()
        
        btnBorder(btn_register)
        btnBorder(btn_login)
    
        var buttonText = [
            
            "en": [
                "btnRegister": "New member registration",
                "btnLogin": "Login",
                "changeLang" : "Choose Language"
            ],
            "ja" : [
                "btnRegister": "新規会員登録",
                "btnLogin": "ログイン",
                "changeLang" : "言語を選択する"
            ]
        ]
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let systemLang = userDefaults.valueForKey("AppLanguage") {
            setLanguage.appLanguage = systemLang as! String
            self.language = setLanguage.appLanguage
        } else {
            setLanguage.appLanguage = "en"
             self.language = setLanguage.appLanguage
        }
        autoLayout(view.frame.width,height: view.frame.height)
        
        btn_register.setTitle(buttonText["\(language)"]!["btnRegister"], forState: .Normal)
        btn_login.setTitle(buttonText["\(language)"]!["btnLogin"], forState: .Normal)
        
        let config = SYSTEM_CONFIG()
        
        let sysLang = config.getSYS_VAL("SYSTM_VAL")
        
        print(sysLang!["added_block"]!!["en"]!!)
        
    }
    
    func autoLayout(width: CGFloat, height: CGFloat){
        self.testView.translatesAutoresizingMaskIntoConstraints = false
        self.testView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        self.testView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
//        self.testView.widthAnchor.constraintEqualToConstant(view.frame.width).active = true
//        self.testView.heightAnchor.constraintEqualToConstant(view.frame.height).active = true
        self.testView.sizeThatFits(CGSizeMake(width,height))
        
        
        self.mView.translatesAutoresizingMaskIntoConstraints = false
        self.mView.centerXAnchor.constraintEqualToAnchor(self.testView.centerXAnchor).active = true
        self.mView.centerYAnchor.constraintEqualToAnchor(self.testView.centerYAnchor).active = true
        self.mView.widthAnchor.constraintEqualToConstant(self.testView.frame.width).active = true
        self.mView.heightAnchor.constraintEqualToConstant(self.testView.frame.height).active = true
        
        
        self.sView.frame.size = CGSizeMake(self.testView.frame.width,self.testView.frame.height + 200)
        self.sView.layoutIfNeeded()
        
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
        self.btn_register.topAnchor.constraintEqualToAnchor(self.subBottomView.topAnchor, constant: 60).active = true
        self.btn_register.widthAnchor.constraintEqualToConstant(250).active = true
        self.btn_register.heightAnchor.constraintEqualToConstant(50).active = true
        
        self.btn_login.translatesAutoresizingMaskIntoConstraints = false
        self.btn_login.centerXAnchor.constraintEqualToAnchor(self.subBottomView.centerXAnchor).active = true
        self.btn_login.topAnchor.constraintEqualToAnchor(self.btn_register.bottomAnchor, constant: 30).active = true
        self.btn_login.widthAnchor.constraintEqualToConstant(250).active = true
        self.btn_login.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sView.translatesAutoresizingMaskIntoConstraints = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
        
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let isAppAlreadyLaunchedOnce = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            //self.dismissViewControllerAnimated(true, completion: nil)
            return true
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            self.firstload()
            return false
        }
    }
    
    func firstload() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ChooseLanguage") as! FirstLaunchLanguage
        self.presentViewController(nextViewController, animated:true, completion:nil)
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

