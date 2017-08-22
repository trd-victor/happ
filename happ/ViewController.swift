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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        self.isAppAlreadyLaunchedOnce()
        
        btnBorder(btn_register)
        btnBorder(btn_login)
    
        var buttonText = [
            
            "en": [
                "btnRegister": "New member registration",
                "btnLogin": "Login"
            ],
            "ja" : [
                "btnRegister": "新規会員登録",
                "btnLogin": "ログイン"
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
        
        btn_register.setTitle(buttonText["\(language)"]!["btnRegister"], forState: .Normal)
        btn_login.setTitle(buttonText["\(language)"]!["btnLogin"], forState: .Normal)
        
        self.scrollview = UIScrollView()
        self.scrollview.delegate = self
        self.scrollview.contentSize = CGSizeMake(1000, 1000)
        view.addSubview(scrollview)
        
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
        self.view.setNeedsDisplay()
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

