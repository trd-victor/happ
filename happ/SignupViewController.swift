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
import Crashlytics

struct globalUserId {
    static var userID: String = ""
    static var FirID: String = ""
    static var skills: String = ""
}


class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var navBar: UINavigationBar!
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
    
    //set up language as global variable...
    var language: String!
    var real_userID: String!
    var emptyFields: String!
    var realID: String!
    var loadingScreen: UIView!
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
        autoLayout()
        
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
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        userEmailField.translatesAutoresizingMaskIntoConstraints = false
        userEmailField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        userEmailField.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        userEmailField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        userEmailField.heightAnchor.constraintEqualToConstant(48).active = true
        userEmailField.setLeftPaddingPoints(125)
        userEmailField.setRightPaddingPoints(10)
        userEmailField.tintColor = UIColor.blackColor()
        
        labelUserEmail.translatesAutoresizingMaskIntoConstraints = false
        labelUserEmail.centerXAnchor.constraintEqualToAnchor(userEmailField.centerXAnchor).active = true
        labelUserEmail.topAnchor.constraintEqualToAnchor(userEmailField.topAnchor).active = true
        labelUserEmail.widthAnchor.constraintEqualToAnchor(userEmailField.widthAnchor, constant: -20).active = true
        labelUserEmail.heightAnchor.constraintEqualToConstant(48).active = true
        
        userPasswordField.translatesAutoresizingMaskIntoConstraints = false
        userPasswordField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        userPasswordField.topAnchor.constraintEqualToAnchor(userEmailField.bottomAnchor).active = true
        userPasswordField.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        userPasswordField.heightAnchor.constraintEqualToConstant(48).active = true
        userPasswordField.setLeftPaddingPoints(125)
        userPasswordField.setRightPaddingPoints(10)
        userPasswordField.tintColor = UIColor.blackColor()
        
        labelPassword.translatesAutoresizingMaskIntoConstraints = false
        labelPassword.centerXAnchor.constraintEqualToAnchor(userPasswordField.centerXAnchor).active = true
        labelPassword.topAnchor.constraintEqualToAnchor(userPasswordField.topAnchor).active = true
        labelPassword.widthAnchor.constraintEqualToAnchor(userPasswordField.widthAnchor, constant: -20).active = true
        labelPassword.heightAnchor.constraintEqualToConstant(48).active = true
        
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        btnLogin.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnLogin.topAnchor.constraintEqualToAnchor(userPasswordField.bottomAnchor, constant: 20).active = true
        btnLogin.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -40).active = true
        btnLogin.heightAnchor.constraintEqualToConstant(48).active = true
        
        
        forgetPass.translatesAutoresizingMaskIntoConstraints = false
        forgetPass.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        forgetPass.topAnchor.constraintEqualToAnchor(btnLogin.bottomAnchor, constant: 25).active = true
        forgetPass.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        forgetPass.heightAnchor.constraintEqualToConstant(48).active = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        userPasswordField.placeholder = config.translate("holder_6_or_more_char")
        
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
        if loadingScreen == nil {
            loadingScreen = UIViewController.displaySpinner(self.view)
        }
        let userEmail = userEmailField.text!
        let userPass = userPasswordField.text!
        let config = SYSTEM_CONFIG()
        
        if userEmail == ""  {
            displayMyAlertMessage(config.translate("mess_fail_auth"))
        }else if userPass == "" {
            displayMyAlertMessage(config.translate("mess_fail_auth"))
        }
        else {
            
            if language == "ja" {
                language = "jp"
            }
            
            var FCMtoken = ""
            if let token = FIRInstanceID.instanceID().token() {
                //register token on firebase
                FCMtoken = token
            }
            
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "\(globalvar.LOGIN_ACTION)",
                "d"           : "0",
                "lang"        : "jp",
                "email"       : "\(userEmail)",
                "passwd"      : "\(userPass)",
                 "fcmtoken"    : "\(FCMtoken)"
            ]
            
            let httpRequest = HttpDataRequest(postData: param)
            let request = httpRequest.requestGet()
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                if error != nil || data == nil{
                    print("\(error)")
                    self.loginButton(sender)
                }else{
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            var mess: String = ""
                            var user_id: NSNumber
                            var value: Int
                            
                            if json!["result"] != nil {
                                if json!["result"]!["user_id"] != nil {
                                    value = json!["result"]!["user_id"] as! Int
                                    user_id = value
                                    mess = user_id.stringValue
                                    
                                    globalUserId.userID = mess
                                    let config = SYSTEM_CONFIG()
                                    config.setSYS_VAL(globalUserId.userID, key: "userID")
                                }
                            }
                            
                            var errorMessage : Bool
                            if json!["error"] != nil {
                                errorMessage = json!["error"] as! Bool
                                if json!["message"] != nil {
                                    mess = json!["message"] as! String
                                }
                                if errorMessage == true {
                                    self.displayMyAlertMessage(config.translate("mess_fail_auth"))
                                }
                            } else {
                                let launch = LaunchScreenViewController()
                                launch.getAllUserInfo()
                                
                                self.loginFirebase(userEmail, pass: userPass)
                            }
                        }


                    } catch {
                        print(error)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func loginFirebase(email: String, pass : String ) {
        let config = SYSTEM_CONFIG()
        
        FIRAuth.auth()?.signInWithEmail(email, password: pass) { (user, error) in
            if error == nil {
                globalUserId.FirID = (FIRAuth.auth()?.currentUser?.uid)!
                
                config.setSYS_VAL(globalUserId.FirID, key: "FirebaseID")
                
                let registTokendb = FIRDatabase.database().reference().child("registration-token").child((user?.uid)!)
                registTokendb.child("token").setValue(String(FIRInstanceID.instanceID().token()!))
                
                self.saveFirebase(email, pass: pass)
                
            } else {
                self.displayMyAlertMessage(config.translate("mess_fail_auth"))
            }
            
        }
    }
    
    func saveFirebase(email: String, pass: String){
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "\(globalvar.LOGIN_ACTION)",
            "d"           : "0",
            "lang"        : "jp",
            "email"       : email,
            "passwd"      : pass,
            "firebase"    : globalUserId.FirID
        ]
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil{
                self.saveFirebase(email, pass: pass)
            }else{
                dispatch_async(dispatch_get_main_queue()){
                    self.connectToFcm()
                    self.redirectLogin()
                    
                    if self.loadingScreen != nil {
                        UIViewController.removeSpinner(self.loadingScreen)
                        self.loadingScreen = nil
                    }
                }
            }
        }
        
        task.resume()
    }
    
    func connectToFcm(){
        FIRMessaging.messaging().connectWithCompletion {(error) in
            
            if(error != nil){
             
            }else{
                FIRMessaging.messaging().subscribeToTopic("timeline-push-notification")
                FIRMessaging.messaging().subscribeToTopic("free-time-push-notification")
                FIRMessaging.messaging().subscribeToTopic("reservation")
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
        
        delay(2.0){
            self.userEmailField.text = ""
            self.userPasswordField.text = ""
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
        if self.loadingScreen != nil {
            UIViewController.removeSpinner(self.loadingScreen)
            self.loadingScreen = nil
        }
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
}