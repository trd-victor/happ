
//  ChangePassViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 05/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var navBar: UINavigationBar!
    //setting up variable...
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var userEmailField: UITextField!
    @IBOutlet var userNote: UILabel!
    @IBOutlet var labelUserEmail: UILabel!
    
    @IBOutlet var navBackLogin: UIBarButtonItem!
    @IBOutlet var btnChangePass: UIButton!
    
    //var for global language..
    var language: String!
    var emptyEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //texfield delegate
        userEmailField.delegate = self
        
        //load language set..
        language = setLanguage.appLanguage
       
        //add listener action to changepass button
        btnChangePass.addTarget(self, action: "changePass:", forControlEvents: .TouchUpInside)
       
        //setBorder
        setBorder(userEmailField)
        self.navBackLogin.action = Selector("navBackLogin:")
        
        //set numberofline0
      
    
        //set border radius
        btnChangePass.layer.cornerRadius = 5
        btnChangePass.layer.borderWidth = 1
    
        autoLayout()
        
        self.loadConfigure()
    }
    
    @IBOutlet var mainView: UIView!
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func autoLayout() {
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
        
        userEmailField.translatesAutoresizingMaskIntoConstraints = false
        userEmailField.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        userEmailField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        userEmailField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        userEmailField.heightAnchor.constraintEqualToConstant(48).active = true
        userEmailField.setRightPaddingPoints(10)
        userEmailField.setLeftPaddingPoints(130)
        userEmailField.tintColor = UIColor.blackColor()
        userEmailField.clearsOnBeginEditing = false
        
        labelUserEmail.translatesAutoresizingMaskIntoConstraints = false
        labelUserEmail.leftAnchor.constraintEqualToAnchor(userEmailField.leftAnchor, constant: 5).active = true
        labelUserEmail.centerYAnchor.constraintEqualToAnchor(userEmailField.centerYAnchor).active = true
        labelUserEmail.widthAnchor.constraintEqualToConstant(200).active = true
        labelUserEmail.heightAnchor.constraintEqualToConstant(20).active = true
        
        userNote.translatesAutoresizingMaskIntoConstraints = false
        userNote.topAnchor.constraintEqualToAnchor(userEmailField.bottomAnchor, constant: 5).active = true
        userNote.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        userNote.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        
        btnChangePass.translatesAutoresizingMaskIntoConstraints = false
        btnChangePass.topAnchor.constraintEqualToAnchor(userNote.bottomAnchor, constant: 20).active = true
        btnChangePass.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnChangePass.widthAnchor.constraintEqualToConstant(280).active = true
        btnChangePass.heightAnchor.constraintEqualToConstant(40).active = true
    
    }
    
    func loadConfigure() {
        
        let config = SYSTEM_CONFIG()
    
        navTitle.title = config.translate("title_resetting_email")
        labelUserEmail.text = config.translate("label_e-mail_address")
        
        userEmailField.placeholder = config.translate("holder_ex.@xxx.com")
        userNote.text = config.translate("text_change_pass")
        
        //set button text..
        btnChangePass.setTitle(config.translate("subtitle_reconfiguration_URL"), forState: .Normal)
        
        userNote.numberOfLines = 0
        userNote.sizeToFit()
    }
    
    func navBackLogin(sender: UIBarButtonItem) ->() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changePass(sender: AnyObject) {
        let userEmail = userEmailField.text!
        let config = SYSTEM_CONFIG()
        if userEmail == "" {
            emptyEmail = config.translate("empty_email")
            displayMyAlertMessage("\(emptyEmail)")
        } else {
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(URL: globalvar.API_URL)
            
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
                "sercret"     : globalvar.secretKey,
                "action"      : "api",
                "ac"          : "user_rest_pw",
                "d"           : "0",
                "lang"        : "\(language)",
                "user_id"     : "",
                "email"       : "\(userEmail)"
            ]
            
            
            //adding the parameters to request body
            request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                if error != nil{
                    print("\(error)")
                    return;
                }
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    if json!["message"] != nil {
                    }
                    if json!["result"] != nil {
                        if json!["result"]!["mess"] != nil {
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        if json!["error"] != nil {
                            if json!["message"] != nil {
                                self.displayMyAlertMessage(json!["message"] as! String)
                            }
                        }else{
                            if json!["result"] != nil {
                                if json!["result"]!["mess"] != nil {
                                    self.displayMyAlertMessage(json!["result"]!["mess"] as! String)
                                }
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
    
    func dismisskeyboard() {
        self.view.endEditing(true)
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
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
    
    func setBorder(textField: UITextField) {
        textField.layer.backgroundColor = UIColor.whiteColor().CGColor
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 0.0
        textField.layer.cornerRadius = 1
        textField.layer.masksToBounds = false
        textField.layer.shadowRadius = 1.0
        textField.layer.shadowColor = UIColor.lightGrayColor().CGColor
        textField.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        textField.layer.shadowOpacity = 0.3
    }
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

   
    

}
