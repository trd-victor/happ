//
//  ChangePassViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 05/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController, UITextFieldDelegate {
    
    //setting up variable...
    @IBOutlet var navBack: UIBarButtonItem!
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var userEmailField: UITextField!
    @IBOutlet var labelUserEmail: UILabel!
    @IBOutlet var userNote: UILabel!
    
    @IBOutlet var btnChangePass: UIButton!
    
    var changePassparam = [
        "en": [
            "navTitle": "Send resetting e-mail",
            "navBack": "Back",
            "emailLabel": "Mail address",
            "emailPlaceholder": "example@xxx.com",
            "userNote": "Please Enter a Registered Email Address!",
            "changePassbutton": "Issue reconfiguration URL"
        ],
        
        "ja" : [
            "navTitle": "再設定メール送信",
            "navBack": "バック",
            "emailLabel": "メールアドレス",
            "emailPlaceholder": "example@xxx.com",
            "userNote": "登録されたメールアドレスを入力してください",
            "changePassbutton": "再設定用URLを発行する"
        ]
    ]
    
    
    //var for global language..
    var language: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //texfield delegate
        userEmailField.delegate = self
        
        //get system language...
        let systemLang =  NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)!
        if systemLang as! String == "ja" {
            language = systemLang as! String
        }else{
            language = "en"
        }
        
        //set text field text and value
        navTitle.title = changePassparam["\(language)"]!["navTitle"]
        navBack.title  = changePassparam["\(language)"]!["navBack"]
        labelUserEmail.text = changePassparam["\(language)"]!["emailLabel"]
        userEmailField.placeholder = changePassparam["\(language)"]!["emailPlaceholder"]
        userNote.text = changePassparam["\(language)"]!["userNote"]
        
        //set button text..
        btnChangePass.setTitle(changePassparam["\(language)"]!["changePassbutton"], forState: .Normal)
        
        //add listener action to changepass button
        btnChangePass.addTarget(self, action: "changePass:", forControlEvents: .TouchUpInside)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changePass(sender: AnyObject) {
        let userEmail = userEmailField.text!
        
        if userEmail == "" {
            displayMyAlertMessage("Enter your Email")
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
                "d"           : "1",
                "lang"        : "\(language)",
                "user_id"     : "",
                "email"       : "\(userEmail)"
            ]
            
            
            //adding the parameters to request body
            request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                var mess: String = ""
                if error != nil{
                    print("\(error)")
                    return;
                }
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    if json!["message"] != nil {
                        mess = json!["message"] as! String
                    }
                    if json!["result"] != nil {
                        if json!["result"]!["mess"] != nil {
                            mess = json!["result"]!["mess"] as! String
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.displayMyAlertMessage(mess)
                    }
                    
                } catch {
                    print(error)
                }
                
            }
            task.resume()
            
        }
        
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
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
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

   
    

}
