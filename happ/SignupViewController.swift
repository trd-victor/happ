//
//  SignupViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 03/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth

struct globalUserId {
    static var userID: String = ""
    static var FirID: String = ""
}


class SignupViewController: UIViewController, UITextFieldDelegate {

    /*Setting up variable*/
    @IBOutlet var userEmailField: UITextField!
    @IBOutlet var userPasswordField: UITextField!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var labelUserEmail: UILabel!
    @IBOutlet var labelPassword: UILabel!
    
    @IBOutlet var backLogin: UIBarButtonItem!
    @IBOutlet var forgetPass: UIButton!
    
    @IBOutlet var underline_jp: UIView!

    
    
    
//    @IBOutlet var navBack: UIBarButtonItem!
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
            "emtpyFields": "All Fields Required",
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
            "forgotPass": "パスワードをお忘れの方はこちら",
            "emtpyFields": "必要なすべてのフィールド"
        ]
    ]
    
    
    
    //set up language as global variable...
    var language: String!
    var real_userID: String!
    var emptyFields: String!
    var realID: String!
    //Create Activity Indicator
    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup delegate
        userEmailField.delegate = self
        userPasswordField.delegate = self
        
        //set border for textbox...
        setBorder(userEmailField)
        setBorder(userPasswordField)

        //set language
        language = setLanguage.appLanguage
        
        //set button action...
        btnLogin.addTarget(self, action: "loginButton:", forControlEvents: .TouchUpInside)
        
        //dismiss view login controller..
        self.backLogin.action = Selector("backHome:")
        
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        //set corner radius
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 1
        
        
        myActivityIndicator.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        myActivityIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5)
        view.addSubview(myActivityIndicator)
        view.endEditing(true)
    
        
        //load settings
        self.loadConfigure()
       
    }
    
    func loadConfigure(){
        let config = SYSTEM_CONFIG()
        
      //  config.translate("button_regist")
        // Set Translations
        navTitle.title = config.translate("title_login")
        labelUserEmail.text = config.translate("label_email_address")
    
        userEmailField.placeholder = config.translate("holder_ex.@xx.com")
        labelPassword.text = config.translate("label_Password")
        userPasswordField.placeholder = config.translate("holder_4/more_char")
        
        //setTitle
        btnLogin.setTitle(config.translate("title_login"), forState: .Normal)
        forgetPass.setTitle(config.translate("label_forgot_password"), forState: .Normal)
    }
    
    
    func backHome(sender: UIBarButtonItem) ->() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loginButton(sender: AnyObject) {
        let userEmail = userEmailField.text!
        let userPass = userPasswordField.text!
        let config = SYSTEM_CONFIG()
        
        
//        let error = Error()
        
        if userEmail == ""  {
            displayMyAlertMessage(config.translate("empty_email"))
        }else if userPass == "" {
            displayMyAlertMessage(config.translate("empty_passwd"))
        }
        else {

            if language == "ja" {
                language = "jp"
            }
            
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "\(globalvar.LOGIN_ACTION)",
                "d"           : "0",
                "lang"        : "jp",
                "email"       : "\(userEmail)",
                "passwd"      : "\(userPass)"
            ]
            
            let httpRequest = HttpDataRequest(postData: param)
            let request = httpRequest.requestGet()
            
            self.myActivityIndicator.startAnimating()
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                var mess: String = ""
                var user_id: NSNumber
                var value: Int
                
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
                            value = json!["result"]!["user_id"] as! Int
                            user_id = value
                            mess = user_id.stringValue
                            globalUserId.userID = mess
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.myActivityIndicator.stopAnimating()
                        self.myActivityIndicator.hidesWhenStopped = true
                        
                        var errorMessage : Bool
                        if json!["error"] != nil {
                            errorMessage = json!["error"] as! Bool
                            if errorMessage == true {
                                self.displayMyAlertMessage(config.translate("login_fail"))
                            }
                        } else {
                            self.loginFirebase(userEmail, pass: userPass)
                        }
                    }
                    
                    } catch {
                    print(error)
                }
                
            }
            task.resume()
        }
    }
    
    func loginFirebase(email: String, pass : String ) {
        FIRAuth.auth()?.signInWithEmail(email, password: pass) { (user, error) in
            if error == nil {
                globalUserId.FirID = (FIRAuth.auth()?.currentUser?.uid)!
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let fireabaseID = userDefaults.setValue(globalUserId.FirID, forKey: "FirebaseID")
                userDefaults.synchronize()
                self.redirectLogin()
            } else {
                self.displayMyAlertMessage("Don't have Account!")
            }
        
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func redirectLogin() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let userTimeLineController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as!
            MenuViewController
        self.presentViewController(userTimeLineController, animated:true, completion:nil)
        
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


