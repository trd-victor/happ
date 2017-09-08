
//  ChangePassViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 05/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController, UITextFieldDelegate {
    
    //setting up variable...
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var userEmailField: UITextField!
    @IBOutlet var userNote: UILabel!
    @IBOutlet var labelUserEmail: UILabel!
    
    @IBOutlet var navBackLogin: UIBarButtonItem!
    @IBOutlet var btnChangePass: UIButton!
    
    var changePassparam = [
        "en": [
            "navTitle": "Send resetting e-mail",
            "navBack": "Back",
            "emailLabel": "Mail address",
            "emailPlaceholder": "example@xxx.com",
            "userNote": "Please Enter a Registered Email Address!",
            "changePassbutton": "Issue reconfiguration URL",
            "emptyEmail":"Enter Email",
            "note1" : "Please enter the registered email address and tap the button below. A mail with the URL for resetting will be sent.",
            "note2" : "If you do not receive the e-mail, please re-tap the button after confirming that you do not set domain rejected setting."
        ],
        
        "ja" : [
            "navTitle": "再設定メール送信",
            "navBack": "バック",
            "emailLabel": "メールアドレス",
            "emailPlaceholder": "example@xxx.com",
            "userNote": "登録されたメールアドレスを入力してください",
            "changePassbutton": "再設定用URLを発行する",
            "emptyEmail":"メールアドレスを入力して",
            "note1" : "登録済みのメールアドレスを入力し、下のボタンをタップしてください。再設定用URLが書かれたメールが送信されます。",
            "note2" : "メールが届かない場合は、ドメイン着信拒否設定をしていないかご確認の上、ボタンを再タップしてください。"
        ]
    ]
    
    
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
    
        
       self.loadConfigure()
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
        
        if userEmail == "" {
            emptyEmail = changePassparam["\(language)"]!["emptyEmail"]
            displayMyAlertMessage("\(emptyEmail)")
        } else {
            let changePassUrl = "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php"
            
            //created NSURL
            let requestURL = NSURL(string: changePassUrl)
            
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
                        let MailError = Error()
                        self.displayMyAlertMessage(MailError.ErrorList["\(self.language)"]!["not_regist_email"]!)
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
