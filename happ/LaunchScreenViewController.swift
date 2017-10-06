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
    
    internal func                                                                                                                        getSYS_VAL(key: String) -> AnyObject?{
        return self.SYS_VAL.valueForKey(key)
    }
    
    /**
     * @param key as String
     * System Language
     **/
    internal func translate(key: String) -> String {
        var lang = self.getSYS_VAL("AppLanguage") as! String
        let textTranslate = self.getSYS_VAL("SYSTM_VAL")
        
        if lang == "ja" {
            lang = "jp"
        }
        
        if textTranslate![key] != nil {
            return textTranslate![key]!![lang]!! as! String
        }else{
            return ""
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
        logo.widthAnchor.constraintEqualToConstant(240).active = true
        logo.heightAnchor.constraintEqualToConstant(130).active = true
        
        logo.image = UIImage(named: "logo")
        activityIndicator.topAnchor.constraintEqualToAnchor(logo.bottomAnchor, constant: 5).active = true
        activityIndicator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        activityIndicator.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        activityIndicator.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    override func viewDidAppear(animated: Bool) {
        activityIndicator.startAnimating()
        self.isAppAlreadyLaunchedOnce()
        
        let user = ViewController()
        user.getAllUserInfo()
        
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
        
        if let firID = FIRAuth.auth()?.currentUser?.uid {
            let userdb = FIRDatabase.database().reference().child("users").child(firID)
            
            globalUserId.FirID = firID
            
            let user = ViewController()
            user.getAllUserInfo()
            
            let config = SYSTEM_CONFIG()
            config.setSYS_VAL(globalUserId.FirID, key: "FirebaseID")
            
            if let token = FIRInstanceID.instanceID().token() {
                FIRDatabase.database().reference().child("registration-token").child(firID).child("token").setValue(token)
            }
            
            dispatch_async(dispatch_get_main_queue()){
                userdb.observeSingleEventOfType(.Value, withBlock: {(snap) in
                    if let data = snap.value as? NSDictionary{
                        globalUserId.userID = String(data["id"]!)
                        
                        let userTimeLineController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
                        self.presentViewController(userTimeLineController, animated:true, completion:nil)
                    }else{
                        let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainBoard") as! ViewController
                        self.presentViewController(mainViewController, animated:false, completion:nil)
                    }
                })
            }
            
            
            self.delay(12.0){
                let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainBoard") as! ViewController
                self.presentViewController(mainViewController, animated:false, completion:nil)
            }
        }else {
            let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainBoard") as! ViewController
            self.presentViewController(mainViewController, animated:false, completion:nil)
        }
    }
    
    func delayLaunchScreen() {
        self.delay(3.0) {
            self.activityIndicator.stopAnimating()
            dispatch_async(dispatch_get_main_queue()){
                self.dismissViewControllerAnimated(false, completion: nil)
                self.gotoMainBoard()
            }
        }
    }
    
    func setUpView() {
        let viewbg = UIView()
        viewbg.backgroundColor = UIColor(hexString: "#eeeeee")
        view.addSubview(viewbg)
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        
        //        self.delayLaunchScreen()
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = defaults.stringForKey("isAppAlreadyLaunchedOnce"){
            //self.dismissViewControllerAnimated(true, completion: nil)
            self.delayLaunchScreen()
            return true
        }else{
            defaults.setBool(true, forKey: "isAppAlreadyLaunchedOnce")
            let config = getSystemValue()
            config.getKey()
            self.delay(5.0){
                self.activityIndicator.stopAnimating()
                do {
                    try FIRAuth.auth()?.signOut()
                } catch (let error) {
                    print((error as NSError).code)
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.firstload()
                }
            }
            return false
        }
    }
    
    func firstload() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ChooseLanguage") as! FirstLaunchLanguage
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    
}