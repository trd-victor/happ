//
//  ChangeNewPasswordViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 25/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class ChangeNewPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var save: UIBarButtonItem!

    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var currentPass: UILabel!
    @IBOutlet var newPass: UILabel!
    @IBOutlet var reenterpass: UILabel!
    
    @IBOutlet var currentPassField: UITextField!
    @IBOutlet var newPassField: UITextField!
    @IBOutlet var reenterPassField: UITextField!
    @IBOutlet var originalPass: UITextField!
    
    
    @IBOutlet var navBackChangePass: UIBarButtonItem!
    

    var language: String!
    var userId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load language set.
        language = setLanguage.appLanguage
        
        self.loadConfigure()
        
        userId = globalUserId.userID
//        self.loaduserPassword()
        
        self.originalPass.hidden = true
        
        self.navBackChangePass.action = Selector("backToConfiguration:")
        
        //set delegate..
        currentPassField.delegate = self
        newPassField.delegate = self
        reenterPassField.delegate = self
        
        view.endEditing(true)
    
    }
    
    func loadConfigure() {
        
        let config = SYSTEM_CONFIG()
        
        navTitle.title = config.translate("title_change_password")
        save.title = config.translate("button_save")
        currentPass.text = config.translate("label_current_password")
        newPass.text = config.translate("label_new_password")
        reenterpass.text = config.translate("label_re-enter_password")
        
        currentPassField.placeholder = config.translate("label_current_password")
        newPassField.placeholder = config.translate("label_new_password")
        reenterPassField.placeholder = config.translate("label_re-enter_password")
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
//        presentViewController(viewControllerToPresent, animated: false, completion: nil)
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
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func Save(sender: AnyObject) {
        
         let config = SYSTEM_CONFIG()
         let currentPass1 = currentPassField.text!
         let newPass1 = newPassField.text!
         let reEnterPass1 = reenterPassField.text!
//         let origPass = originalPass.text!
        
        if currentPass1 == ""  {
            self.displayMyAlertMessage(config.translate("empty_current_password"))
        } else if newPass1 == ""  {
            self.displayMyAlertMessage(config.translate("empty_new_password"))
        } else if reEnterPass1 == "" {
            self.displayMyAlertMessage(config.translate("empty_reenter_password"))
        }
        else if newPass1 != reEnterPass1 {
            self.displayMyAlertMessage(config.translate("not_match_password"))
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
            
            //set targeted string
            let targetedData: String = "passwd"
            
            //set parameters...
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "user_update",
                "d"           : "0",
                "lang"        : "\(language)",
                "user_id"     : "\(userId)",
                "passwd"      : "\(newPass1)",
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
                        self.displayMyAlertMessage(message)
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        var errorMessage: Int
                        if json!["error"] != nil {
                            errorMessage = json!["error"] as! Int
                            if errorMessage == 1 {
                                self.displayMyAlertMessage(message)
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            task.resume()
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func loaduserPassword() {
//        //let URL
//        let viewDataURL = "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php"
//        
//        //created NSURL
//        let requestURL = NSURL(string: viewDataURL)
//        
//        
//        //creating NSMutableURLRequest
//        let request = NSMutableURLRequest(URL: requestURL!)
//        
//        //set boundary string..
//        let boundary = generateBoundaryString()
//        
//        //set value for image upload
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        //setting the method to post
//        request.HTTPMethod = "POST"
//        
//        //        if language == "ja" {
//        //            language = "jp"
//        //        }
//        //        set parameters...
//        let param = [
//            "sercret"     : "jo8nefamehisd",
//            "action"      : "api",
//            "ac"          : "get_userinfo",
//            "d"           : "1",
//            "lang"        : "\(language)",
//            "user_id"     : "\(userId)"
//        ]
//        
//        //adding the parameters to request body
//        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
//            data, response, error  in
//            
//            //user Data...
////            var passwd: String!
//            
//            if error != nil{
//                print("\(error)")
//                return;
//            }
//            do {
//                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
//                
////                if json!["result"] != nil {
////                    passwd = json!["result"]!["passwd"] as! String
////                }
//                print(json)
//                dispatch_async(dispatch_get_main_queue()) {
////                    self.originalPass.text = passwd
////                    print(passwd)
//                }
//                
//            } catch {
//                print(error)
//            }
//        }
//        task.resume()
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
