//
//  SignupViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 03/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//
import UIKit


class SignupViewController: UIViewController, UITextFieldDelegate {

    /*Setting up variable*/
    @IBOutlet var userEmailField: UITextField!
    @IBOutlet var userPasswordField: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var labelUserEmail: UILabel!
    @IBOutlet var labelPassword: UILabel!
    
    @IBOutlet var forgotPass: UIButton!
    @IBOutlet var navBack: UIBarButtonItem!
    @IBOutlet var navTitle: UINavigationItem!
    
    //set up static param
    var loginParam = [
        
        "en": [
            "navTitle": "Login",
            "navBack": "Back",
            "labelUserEmail": "Mail address",
            "userEmailPlaceholder":"example@xxx.com",
            "labelPassword": "Password",
            "userPasswordPlaceholder": "Enter Password",
            "loginButton": "Log-in",
            "forgotPass":"Click here if you have forgotten your password"
        ],
        
        "ja":[
            "navTitle": "ログイン",
            "navBack": "バック",
            "labelUserEmail": "メールアドレス",
            "userEmailPlaceholder":"example@xxx.com",
            "labelPassword": "パスワード",
            "userPasswordPlaceholder": "半角英数字4文字以上",
            "loginButton": "ログインする",
            "forgotPass": "パスワードをお忘れの方はこちら"
        ]
    ]

    //set up language as global variable...
    var language: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup delegate
        userEmailField.delegate = self
        userPasswordField.delegate = self
        
        //get the system language..
        //get system language..
        let systemLang =  NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)!
        if systemLang as! String == "ja" {
            language = systemLang as! String
        }else{
            language = "en"
        }
        
        navTitle.title = loginParam["\(language)"]!["navTitle"]
        navBack.title = loginParam["\(language)"]!["navBack"]
        labelUserEmail.text = loginParam["\(language)"]!["labelUserEmail"]
        userEmailField.placeholder = loginParam["\(language)"]!["userEmailPlaceholder"]
        labelPassword.text = loginParam["\(language)"]!["labelPassword"]
        userPasswordField.placeholder = loginParam["\(language)"]!["userPasswordPlaceholder"]
        
        //setTitle
        btnLogin.setTitle(loginParam["\(language)"]!["loginButton"], forState: .Normal)
        forgotPass.setTitle(loginParam["\(language)"]!["forgotPass"], forState: .Normal)
        
        //set button action...
        btnLogin.addTarget(self, action: "loginButton:", forControlEvents: .TouchUpInside)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginButton(sender: AnyObject) {
        let userEmail = userEmailField.text
        let userPass = userPasswordField.text
        
        if userEmail == "" || userPass == "" {
            displayMyAlertMessage("All Fields Required!")
        } else {
            let loginUrl = "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php"
            
            //created NSURL
            let requestURL = NSURL(string: loginUrl)
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(URL: requestURL!)
            
            //set boundary string..
            let boundary = generateBoundaryString()
            
            //set value for image upload
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            //setting the method to post
            request.HTTPMethod = "POST"
            
            //get data from texttfield..
            let email = userEmailField.text!
            let pass  = userPasswordField.text!
            

            if language == "ja" {
                language = "jp"
            }
            //set parameters...
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "user_login",
                "d"           : "1",
                "lang"        : "\(language)",
                "user_id"     : "",
                "email"       : "\(email)",
                "passwd"      : "\(pass)"
            ]
            
            
            //adding the parameters to request body
            request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                var mess: String = ""
                var user_id: NSNumber
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
                        if json!["result"]!["user_id"] != nil {
                            let value = json!["result"]!["user_id"] as! Int
                            user_id = value
                            mess = user_id.stringValue
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


