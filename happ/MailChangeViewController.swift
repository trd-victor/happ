//
//  MailChangeViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 25/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class MailChangeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var separator: UIView!
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var Save: UIBarButtonItem!
    @IBOutlet var txtMail: UITextField!
    @IBOutlet var labelMail: UILabel!
    @IBOutlet var userRealEmail: UITextField!
    @IBOutlet var mainView: UIView!
    
    @IBOutlet var navBack: UIBarButtonItem!
    
    var arrText = [
        
        "en" : [
            "navTitle": "E-mail address change",
            "save" : "Save",
            "name" : "Mail Address",
            "nameplaceholder" : "hogehoge@gmail.com"
        ],
        "ja" : [
            "navTitle": "メールアドレスの変更",
            "save" : "保存する",
            "labelMail" : "メールアドレス",
            "mailPlaceholder" : "hogehoge@gmail.com"
        ]
    ]

    var language: String!
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load language set.
        language = setLanguage.appLanguage
    
        if language == "ja" {
            language = "jp"
        }
        
        userId = globalUserId.userID
        self.loaduserEmail()
        
        
        self.loadConfigure()
        
        //hide original email
        self.userRealEmail.hidden = true
        
         self.navBack.action = Selector("backToConfiguration:")
        
        txtMail.delegate = self
        
        view.endEditing(true)
        
        view.sendSubviewToBack(mainView)
        
        autoLayout()
    }
    
    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        mainView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mainView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        mainView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        txtMail.translatesAutoresizingMaskIntoConstraints = false
        txtMail.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        txtMail.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor, constant: 10).active = true
        txtMail.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        txtMail.heightAnchor.constraintEqualToConstant(44).active = true
        txtMail.setLeftPaddingPoints(135)
        txtMail.setRightPaddingPoints(10)
        txtMail.tintColor = UIColor.blackColor()
        
        labelMail.translatesAutoresizingMaskIntoConstraints = false
        labelMail.centerXAnchor.constraintEqualToAnchor(txtMail.centerXAnchor).active = true
        labelMail.centerYAnchor.constraintEqualToAnchor(txtMail.centerYAnchor).active = true
        labelMail.widthAnchor.constraintEqualToAnchor(txtMail.widthAnchor, constant: -20).active = true
        labelMail.heightAnchor.constraintEqualToConstant(44).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator.topAnchor.constraintEqualToAnchor(txtMail.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
    }
    
    func loadConfigure() {
        
        let config = SYSTEM_CONFIG()
        
        navTitle.title = config.translate("title_e-mail_add_change")
        Save.title = config.translate("button_save")
        txtMail.placeholder = config.translate("holder_ex.@xx.com")
        labelMail.text = config.translate("label_email_address")
    }
    

    
    @IBAction func Save(sender: AnyObject) {
        if userId != "" {
            self.updateEmail()
        } else {
            self.displayMyAlertMessage("No user Login!")
        }
    }
    
    func updateEmail() {
        
        let config = SYSTEM_CONFIG()
        
        let email = txtMail.text!
        
        if email == "" {
            self.displayMyAlertMessage(config.translate("empty_email"))
        }
        else {
            //created NSURL
            let URL_SAVE_TEAM = "http://dev.happ.timeriverdesign.com/wp-admin/admin-ajax.php"
            
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
            let targetedData: String = "email"
        
            //set parameters...
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "user_update",
                "d"           : "0",
                "lang"        : "\(language)",
                "user_id"     : "\(userId)",
                "email"       : "\(email)",
                "targets"     : "\(targetedData)"
            ]
            
            //adding the parameters to request body
            request.HTTPBody = createBodyWithParameters(param,  boundary: boundary)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                var message: String!
                
                if error != nil || data == nil{
                    self.updateEmail()
                }else{
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
                
             }
            task.resume()
        }
        
    }
    
    func loaduserEmail() {
        //let URL
        let viewDataURL = "http://dev.happ.timeriverdesign.com/wp-admin/admin-ajax.php"
        
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
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            //user Data...
            var email: String!
            
            if error != nil || data == nil{
                self.loaduserEmail()
            }else{
                do {
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if json!["result"] != nil {
                        email = json!["result"]!["email"] as! String
                    }
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {() -> Void in
                        dispatch_async(dispatch_get_main_queue(), {() -> Void in
                            self.txtMail.text = email
                        })
                    })
                    
                } catch {
                    print(error)
                }
            }
           
        }
        task.resume()
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        //self.tabBarController!.presentViewController(viewControllerToPresent, animated: false, completion: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func backToConfiguration(sender: UIBarButtonItem) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Configuration") as! ConfigurationViewController
        
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
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
