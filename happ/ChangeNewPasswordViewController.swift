//
//  ChangeNewPasswordViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 25/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

class ChangeNewPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var separator: UIView!
    @IBOutlet var separator2: UIView!
    @IBOutlet var separator3: UIView!

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
        
        if language == "ja" {
            language = "jp"
        }
        
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
        
        autoLayout()
    }
    
    func autoLayout() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        currentPassField.translatesAutoresizingMaskIntoConstraints = false
        currentPassField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        currentPassField.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        currentPassField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        currentPassField.heightAnchor.constraintEqualToConstant(44).active = true
        
        currentPass.translatesAutoresizingMaskIntoConstraints = false
        currentPass.centerXAnchor.constraintEqualToAnchor(currentPassField.centerXAnchor).active = true
        currentPass.topAnchor.constraintEqualToAnchor(currentPassField.topAnchor).active = true
        currentPass.widthAnchor.constraintEqualToAnchor(currentPassField.widthAnchor, constant: -20).active = true
        currentPass.heightAnchor.constraintEqualToConstant(44).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator.topAnchor.constraintEqualToAnchor(currentPassField.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        newPassField.translatesAutoresizingMaskIntoConstraints = false
        newPassField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        newPassField.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        newPassField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        newPassField.heightAnchor.constraintEqualToConstant(44).active = true
        
        newPass.translatesAutoresizingMaskIntoConstraints = false
        newPass.centerXAnchor.constraintEqualToAnchor(newPassField.centerXAnchor).active = true
        newPass.topAnchor.constraintEqualToAnchor(newPassField.topAnchor).active = true
        newPass.widthAnchor.constraintEqualToAnchor(newPassField.widthAnchor, constant: -20).active = true
        newPass.heightAnchor.constraintEqualToConstant(44).active = true
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator2.topAnchor.constraintEqualToAnchor(newPassField.bottomAnchor).active = true
        separator2.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator2.heightAnchor.constraintEqualToConstant(1).active = true
        
        reenterPassField.translatesAutoresizingMaskIntoConstraints = false
        reenterPassField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        reenterPassField.topAnchor.constraintEqualToAnchor(separator2.bottomAnchor).active = true
        reenterPassField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        reenterPassField.heightAnchor.constraintEqualToConstant(44).active = true
        
        reenterpass.translatesAutoresizingMaskIntoConstraints = false
        reenterpass.centerXAnchor.constraintEqualToAnchor(reenterPassField.centerXAnchor).active = true
        reenterpass.topAnchor.constraintEqualToAnchor(reenterPassField.topAnchor).active = true
        reenterpass.widthAnchor.constraintEqualToAnchor(reenterPassField.widthAnchor, constant: -20).active = true
        reenterpass.heightAnchor.constraintEqualToConstant(44).active = true
        
        separator3.translatesAutoresizingMaskIntoConstraints = false
        separator3.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator3.topAnchor.constraintEqualToAnchor(reenterpass.bottomAnchor).active = true
        separator3.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator3.heightAnchor.constraintEqualToConstant(1).active = true
        
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
         let email = config.getSYS_VAL("useremail_\(self.userId)")
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
            FIRAuth.auth()?.signInWithEmail(email as! String,  password: currentPass1) { (user, error) in
                if error == nil {
                    //created NSURL
                    let URL_SAVE_TEAM = "https://happ.biz/wp-admin/admin-ajax.php"
                    
                    //created NSURL
                    let requestURL = NSURL(string: URL_SAVE_TEAM)
                    
                    //creating NSMutableURLRequest
                    let request = NSMutableURLRequest(URL: requestURL!)
                    
                    //set boundary string..
                    let boundary = self.generateBoundaryString()
                    
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
                        "lang"        : "\(self.language)",
                        "user_id"     : "\(self.userId)",
                        "passwd"      : "\(newPass1)",
                        "targets"     : "\(targetedData)"
                    ]
                    
                    //adding the parameters to request body
                    request.HTTPBody = self.createBodyWithParameters(param,  boundary: boundary)
                    
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                        data, response, error  in
                        
                        var message: String!
                        
                        if error != nil || data == nil{
                            self.Save(sender)
                        }else {
                            do {
                                FIRAuth.auth()?.currentUser?.updatePassword(newPass1, completion: nil)
                                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                                
                                dispatch_async(dispatch_get_main_queue()) {
                                    var errorMessage: Int
                                    if json!["error"] != nil {
                                        errorMessage = json!["error"] as! Int
                                        if errorMessage == 1 {
                                            if json!["message"] != nil {
                                                message = json!["message"] as! String
                                            }
                                            self.displayMyAlertMessage(message)
                                        }else{
                                            if json!["result"] != nil {
                                                message = json!["result"]!["mess"] as! String
                                                self.displayMyAlertMessage(message)
                                            }
                                        }
                                    }
                                }
                                
                            } catch {
                                print(error)
                            }
                            
                        }
                        
                    }
                    task.resume()
                } else {
                    self.displayMyAlertMessage(config.translate("empty_current_password"))
                }
            }
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
