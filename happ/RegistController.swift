//
//  RegistController.swift
//  happ
//
//  Created by TokikawaTeppei on 18/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegistController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
//    @IBOutlet var navBack: UIBarButtonItem!
    @IBOutlet var navController: UINavigationItem!
    
    @IBOutlet var skillView: UIView!
    @IBOutlet var infoView: UIView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var navBack: UIBarButtonItem!
    @IBOutlet var labeltopTitle: UILabel!
    @IBOutlet var labelSkill: UILabel!
    @IBOutlet var labelFrontEnd: UILabel!
    @IBOutlet var labelBackEnd: UILabel!
    @IBOutlet var labelAndroid: UILabel!
    @IBOutlet var labelIOS: UILabel!
    @IBOutlet var labelAppDesign: UILabel!
    @IBOutlet var labelWebDesign: UILabel!
    @IBOutlet var btnUpdate: UIButton!
    
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelPass: UILabel!
    @IBOutlet var labelEmail: UILabel!
    @IBOutlet var labelReEnterPass: UILabel!

    /*setting up the UITextField variable...*/
    @IBOutlet var userName: UITextField!
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userReEnterPassword: UITextField!
    @IBOutlet var userPassword: UITextField!
    

    @IBOutlet var frontEndSwitch: UISwitch!
    @IBOutlet var backEndSwitch: UISwitch!
    @IBOutlet var iosSwitch: UISwitch!
    @IBOutlet var AndroidSwitch: UISwitch!
    @IBOutlet var appdesignSwitch: UISwitch!
    @IBOutlet var webdesignSwitch: UISwitch!
    
    
    
    var arrText = [
        "en": [
            "notMatchPassword": "Password did not match"
        ],
        "ja": [
            "notMatchPassword": "パスワードが一致しませんでした"
        ]
    ]
    var emptyString: String!
    var language: String!
    var notmatchPass: String!
    var FirebaseID : String!
    var FirebaseImage : String!
    var Firebaseemail : String!
    var Firebasename : String!
    var scrollview : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoLayout()
        
        //delegate textfield..
        userEmail.delegate = self
        userPassword.delegate = self
        userName.delegate = self
        userReEnterPassword.delegate = self

        //load language set.
        language = setLanguage.appLanguage
        
        
        //set border for textbox and label
        setBorder(userName)
        setBorder(userEmail)
        setBorder(userPassword)
//        addLabelBorder(labelFrontEnd)
//        addLabelBorder(labelBackEnd)
//        addLabelBorder(labelAndroid)
//        addLabelBorder(labelIOS)
//        addLabelBorder(labelAppDesign)
        
        //add button clicked function..
        btnUpdate.addTarget(self, action: "registerUser:", forControlEvents: .TouchUpInside)
        self.navBack.action = Selector("backHome:")
        
        //set border 
        btnUpdate.layer.cornerRadius = 5
        btnUpdate.layer.borderWidth = 1
        
        self.loadConfigure()
    }
    
    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        scrollView.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        scrollView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        scrollView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        scrollView.contentSize = CGSizeMake(view.frame.width,950)
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        infoView.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
        infoView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        infoView.heightAnchor.constraintEqualToConstant(38).active = true
        
        labeltopTitle.translatesAutoresizingMaskIntoConstraints = false
        labeltopTitle.centerXAnchor.constraintEqualToAnchor(infoView.centerXAnchor).active = true
        labeltopTitle.centerYAnchor.constraintEqualToAnchor(infoView.centerYAnchor).active = true
        labeltopTitle.widthAnchor.constraintEqualToAnchor(infoView.widthAnchor).active = true
        labeltopTitle.heightAnchor.constraintEqualToConstant(38).active = true
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        userName.topAnchor.constraintEqualToAnchor(infoView.bottomAnchor).active = true
        userName.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        userName.heightAnchor.constraintEqualToConstant(48).active = true
        
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.centerXAnchor.constraintEqualToAnchor(userName.centerXAnchor).active = true
        labelName.topAnchor.constraintEqualToAnchor(userName.topAnchor).active = true
        labelName.widthAnchor.constraintEqualToAnchor(userName.widthAnchor, constant: -20).active = true
        labelName.heightAnchor.constraintEqualToConstant(48).active = true
        
        userEmail.translatesAutoresizingMaskIntoConstraints = false
        userEmail.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        userEmail.topAnchor.constraintEqualToAnchor(userName.bottomAnchor).active = true
        userEmail.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        userEmail.heightAnchor.constraintEqualToConstant(48).active = true
        
        labelEmail.translatesAutoresizingMaskIntoConstraints = false
        labelEmail.centerXAnchor.constraintEqualToAnchor(userEmail.centerXAnchor).active = true
        labelEmail.topAnchor.constraintEqualToAnchor(userEmail.topAnchor).active = true
        labelEmail.widthAnchor.constraintEqualToAnchor(userEmail.widthAnchor, constant: -20).active = true
        labelEmail.heightAnchor.constraintEqualToConstant(48).active = true
        
        userPassword.translatesAutoresizingMaskIntoConstraints = false
        userPassword.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        userPassword.topAnchor.constraintEqualToAnchor(userEmail.bottomAnchor).active = true
        userPassword.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        userPassword.heightAnchor.constraintEqualToConstant(48).active = true
        
        labelPass.translatesAutoresizingMaskIntoConstraints = false
        labelPass.centerXAnchor.constraintEqualToAnchor(userPassword.centerXAnchor).active = true
        labelPass.topAnchor.constraintEqualToAnchor(userPassword.topAnchor).active = true
        labelPass.widthAnchor.constraintEqualToAnchor(userPassword.widthAnchor, constant: -20).active = true
        labelPass.heightAnchor.constraintEqualToConstant(48).active = true
        
        userReEnterPassword.translatesAutoresizingMaskIntoConstraints = false
        userReEnterPassword.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        userReEnterPassword.topAnchor.constraintEqualToAnchor(userPassword.bottomAnchor).active = true
        userReEnterPassword.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        userReEnterPassword.heightAnchor.constraintEqualToConstant(48).active = true
        
        labelReEnterPass.translatesAutoresizingMaskIntoConstraints = false
        labelReEnterPass.centerXAnchor.constraintEqualToAnchor(userReEnterPassword.centerXAnchor).active = true
        labelReEnterPass.topAnchor.constraintEqualToAnchor(userReEnterPassword.topAnchor).active = true
        labelReEnterPass.widthAnchor.constraintEqualToAnchor(userReEnterPassword.widthAnchor, constant: -20).active = true
        labelReEnterPass.heightAnchor.constraintEqualToConstant(48).active = true
        
        skillView.translatesAutoresizingMaskIntoConstraints = false
        skillView.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        skillView.topAnchor.constraintEqualToAnchor(userReEnterPassword.bottomAnchor).active = true
        skillView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        skillView.heightAnchor.constraintEqualToConstant(38).active = true
        
        labelSkill.translatesAutoresizingMaskIntoConstraints = false
        labelSkill.centerXAnchor.constraintEqualToAnchor(skillView.centerXAnchor).active = true
        labelSkill.topAnchor.constraintEqualToAnchor(skillView.topAnchor).active = true
        labelSkill.widthAnchor.constraintEqualToAnchor(skillView.widthAnchor).active = true
        labelSkill.heightAnchor.constraintEqualToConstant(38).active = true
        
        labelFrontEnd.translatesAutoresizingMaskIntoConstraints = false
        labelFrontEnd.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelFrontEnd.topAnchor.constraintEqualToAnchor(skillView.bottomAnchor, constant: 10).active = true
        labelFrontEnd.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelFrontEnd.heightAnchor.constraintEqualToConstant(31).active = true
        
        labelBackEnd.translatesAutoresizingMaskIntoConstraints = false
        labelBackEnd.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelBackEnd.topAnchor.constraintEqualToAnchor(labelFrontEnd.bottomAnchor, constant: 10).active = true
        labelBackEnd.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelBackEnd.heightAnchor.constraintEqualToConstant(31).active = true
        
        labelAndroid.translatesAutoresizingMaskIntoConstraints = false
        labelAndroid.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelAndroid.topAnchor.constraintEqualToAnchor(labelBackEnd.bottomAnchor, constant: 10).active = true
        labelAndroid.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelAndroid.heightAnchor.constraintEqualToConstant(31).active = true
        
        labelIOS.translatesAutoresizingMaskIntoConstraints = false
        labelIOS.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelIOS.topAnchor.constraintEqualToAnchor(labelAndroid.bottomAnchor, constant: 10).active = true
        labelIOS.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelIOS.heightAnchor.constraintEqualToConstant(31).active = true
        
        labelAppDesign.translatesAutoresizingMaskIntoConstraints = false
        labelAppDesign.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelAppDesign.topAnchor.constraintEqualToAnchor(labelIOS.bottomAnchor, constant: 10).active = true
        labelAppDesign.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelAppDesign.heightAnchor.constraintEqualToConstant(31).active = true
        
        labelWebDesign.translatesAutoresizingMaskIntoConstraints = false
        labelWebDesign.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelWebDesign.topAnchor.constraintEqualToAnchor(labelAppDesign.bottomAnchor, constant: 10).active = true
        labelWebDesign.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelWebDesign.heightAnchor.constraintEqualToConstant(31).active = true
        
        btnUpdate.translatesAutoresizingMaskIntoConstraints = false
        btnUpdate.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        btnUpdate.topAnchor.constraintEqualToAnchor(labelWebDesign.bottomAnchor, constant: 25).active = true
        btnUpdate.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -40).active = true
        btnUpdate.heightAnchor.constraintEqualToConstant(48).active = true
        
        frontEndSwitch.translatesAutoresizingMaskIntoConstraints = false
        frontEndSwitch.frame.size = CGSizeMake(51, 31)
        frontEndSwitch.topAnchor.constraintEqualToAnchor(skillView.bottomAnchor, constant: 10).active = true
        frontEndSwitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        backEndSwitch.translatesAutoresizingMaskIntoConstraints = false
        backEndSwitch.frame.size = CGSizeMake(51, 31)
        backEndSwitch.topAnchor.constraintEqualToAnchor(frontEndSwitch.bottomAnchor, constant: 10).active = true
        backEndSwitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        AndroidSwitch.translatesAutoresizingMaskIntoConstraints = false
        AndroidSwitch.frame.size = CGSizeMake(51, 31)
        AndroidSwitch.topAnchor.constraintEqualToAnchor(backEndSwitch.bottomAnchor, constant: 10).active = true
        AndroidSwitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        iosSwitch.translatesAutoresizingMaskIntoConstraints = false
        iosSwitch.frame.size = CGSizeMake(51, 31)
        iosSwitch.topAnchor.constraintEqualToAnchor(AndroidSwitch.bottomAnchor, constant: 10).active = true
        iosSwitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        appdesignSwitch.translatesAutoresizingMaskIntoConstraints = false
        appdesignSwitch.frame.size = CGSizeMake(51, 31)
        appdesignSwitch.topAnchor.constraintEqualToAnchor(iosSwitch.bottomAnchor, constant: 10).active = true
        appdesignSwitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        webdesignSwitch.translatesAutoresizingMaskIntoConstraints = false
        webdesignSwitch.frame.size = CGSizeMake(51, 31)
        webdesignSwitch.topAnchor.constraintEqualToAnchor(appdesignSwitch.bottomAnchor, constant: 10).active = true
        webdesignSwitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
    }
    
    func loadConfigure() {
        
        let config = SYSTEM_CONFIG()
        
        //change text value according to language...
        navController.title = config.translate("button_new_member_registration")
        labeltopTitle.text = config.translate("subtitle_basic_information")
        labelName.text = config.translate("text_name")
        userName.placeholder = config.translate("holder_15_char/less")
        labelEmail.text = config.translate("label_e-mail_address")
        userEmail.placeholder = config.translate("holder_ex.@xxx.com")
        labelPass.text = config.translate("label_Password")
        userPassword.placeholder = config.translate("holder_4/more_char")
        labelReEnterPass.text = config.translate("holder_re-enter_password")
        userReEnterPassword.placeholder = config.translate("holder_re-enter_password")
        
        labelSkill.text = config.translate("subtitle_skills")
        labelFrontEnd.text = config.translate("label_front_end")
        labelBackEnd.text = config.translate("label_server_side")
        labelIOS.text = config.translate("label_IOS_application")
        labelAndroid.text = config.translate("label_android_application")
        labelAppDesign.text = config.translate("label_app design")
        labelWebDesign.text = config.translate("label_web_design")
        
        btnUpdate.setTitle(config.translate("btn_regist_new_member"), forState: .Normal)
    }
    
    func backHome(sender: UIBarButtonItem) -> () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func registerUser(sender: AnyObject) {
        //setting up the textbox...
        let email = userEmail.text!
        let pass = userPassword.text!
        let name = userName.text!
        let reEnterpassword = userReEnterPassword.text!
        
//        let registError = Error()
        
        let config = SYSTEM_CONFIG()
        
        if email == ""  {
            displayMyAlertMessage(config.translate("empty_email"))
        } else if pass == "" {
            displayMyAlertMessage(config.translate("empty_passwd"))
        } else if  name == ""  {
            displayMyAlertMessage(config.translate("empty_name"))
        } else if pass != reEnterpassword {
            displayMyAlertMessage(config.translate("not_match_password"))
        }
        else {
            //created NSURL
            let URL_SAVE_TEAM = "https://happ.biz/wp-admin/admin-ajax.php"
            
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
            
            //declaring button state
            let frontEndSkill   = frontEndSwitch
            let backEndSkill    = backEndSwitch
            let iosSkill        = iosSwitch
            let androidSkill    = AndroidSwitch
            let appDesignSkill  = appdesignSwitch
            let webDesignSkill  = webdesignSwitch
            
            //get state
            let frontEndState   = switchButtonCheck(frontEndSkill)
            let backEndState    = switchButtonCheck(backEndSkill)
            let iosState        = switchButtonCheck(iosSkill)
            let androidState    = switchButtonCheck(androidSkill)
            let appDesignState  = switchButtonCheck(appDesignSkill)
            let webDesignState  = switchButtonCheck(webDesignSkill)
            
            let skills: [Int: String] = [
                1  : "\(frontEndState)",
                2  : "\(backEndState)",
                3  : "\(iosState)",
                4  : "\(androidState)",
                5  : "\(appDesignState)",
                6  : "\(webDesignState)"
            ]
            
            //set skill into variable and targets...
            var keyskill = returnSkillValue(skills)
            if keyskill != "" {
                keyskill = String(keyskill.characters.dropLast())
            }
            
            let targetedData: String = "email,passwd,name,skills,change_lang"
            if language == "ja" {
                language = "jp"
            }
            //set parameters...
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "user_update",
                "d"           : "0",
                "lang"        : "\(language)",
                "email"       : "\(email)",
                "passwd"      : "\(pass)",
                "name"        : "\(name)",
                "skills"      : "\(keyskill)",
                "change_lang" : "jp",
                "targets"     : "\(targetedData)"
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
                        var errorMessage : Bool
                        if json!["error"] != nil {
                            errorMessage = json!["error"] as! Bool
                            if errorMessage == true {
                                self.displayMyAlertMessage(mess)
                            }
                        } else {
                            self.successMessageAlert(mess)
                            self.loadUserData(name, userEmail: email, password: pass)
                        }
                    }
                } catch {
                    print(error)
                }
 
            }
            task.resume()
        }
    }
    
    func successMessageAlert(userMessage: String) {
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.userEmail.text = ""
            self.userPassword.text = ""
            self.userName.text = ""
            self.userReEnterPassword.text = ""
            self.frontEndSwitch.setOn(false, animated: true)
            self.backEndSwitch.setOn(false, animated: true)
            self.iosSwitch.setOn(false, animated: true)
            self.AndroidSwitch.setOn(false, animated: true)
            self.appdesignSwitch.setOn(false, animated: true)
            self.webdesignSwitch.setOn(false, animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
     }
    
    func loadUserData(sender : String, userEmail: String, password: String) {
        
        let request1 = NSMutableURLRequest(URL: globalvar.API_URL)
        let boundary1 = generateBoundaryString()
        request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
        request1.HTTPMethod = "POST"
        
        let parameters = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "user_search",
            "d"           : "0",
            "lang"        : "en",
            "name"     : "\(sender)"
        ]
        
        request1.HTTPBody = createBodyWithParameters(parameters, boundary: boundary1)
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1){
            data1, response1, error1 in
            
            if error1 != nil || data1 == nil{
                self.loadUserData(sender, userEmail: userEmail, password:  password)
            }else{
                do {
                    let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    let result = json2!["result"] as! NSArray
                    for data in result {
                        
                        let email = data["email"] as! String
                        if email == userEmail {
                            let userId = data["user_id"] as! Int
                            let uid: Int = userId
                            self.FirebaseImage = data["icon"] as? String ?? ""
                            self.Firebaseemail = data["email"] as! String
                            self.Firebasename = data["name"] as! String
                            
                            self.insertUserFB(self.Firebaseemail, userPassword: password, name: self.Firebasename, image: self.FirebaseImage, userID: uid)
                        }
                        else {
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                let userId = data["user_id"] as! Int
                                let uid: Int = userId
                                self.FirebaseImage = data["icon"] as? String ?? ""
                                self.Firebaseemail = data["email"] as! String
                                self.Firebasename = data["name"] as! String
                                
                                self.insertUserFB(self.Firebaseemail, userPassword: password, name: self.Firebasename, image: self.FirebaseImage, userID: uid )
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
        
        task2.resume()
    }
    
    
    func insertUserFB(userEmail: String, userPassword: String, name: String, image: String, userID : Int ) {
        FIRAuth.auth()?.createUserWithEmail(userEmail, password: userPassword, completion: { (user: FIRUser?, error) in
            if error == nil {
//                //connect to firebase db.
                let db = FIRDatabase.database().reference().child("users").child((user?.uid)!)
                
                let token = FIRInstanceID.instanceID().token()!
//                //set users array to insert...
                let userDetails: [String : AnyObject] = [
                    "email"     : userEmail,
                    "id"        : userID,
                    "name"      : name,
                    "photoUrl"  : "null"
                ]
//                //insert to users
                db.setValue(userDetails)
                
                //register token on firebase
                let registTokendb = FIRDatabase.database().reference().child("registration-token").child((user?.uid)!)
                registTokendb.child("token").setValue(String(token))
                
                do {
                    try FIRAuth.auth()?.signOut()
                } catch (let error) {
                    print((error as NSError).code)
                }
            }else{
                print(error)
                self.displayMyAlertMessage("Error: Not Successfully Registered to firebase")
            }
        })
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
    
    //check state..
    func switchButtonCheck(switchButton : UISwitch) -> String {
        var State: String = ""
        if switchButton.on {
            State = "On"
        } else {
            State = "Off"
        }
        return State
    }
    
    //return skill value
    func returnSkillValue(parameters : [Int : String]?) -> String {
        var retString: String = "";
        if parameters != nil {
            for(key, value) in parameters! {
                if value != "On" { continue }
                if key == 1 {
                    retString += "Front end,"
                }else if key == 2 {
                    retString += "Server side,"
                }else if key == 3 {
                    retString += "IOS application,"
                }else if key == 4 {
                    retString += "Android application,"
                }else if key == 5 {
                    retString += "App design,"
                }else if key == 6 {
                    retString += "Web design,"
                }
            }
        }
        return retString
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func addLabelBorder(label: UILabel) {
        label.layer.backgroundColor = UIColor.whiteColor().CGColor
        label.layer.borderColor = UIColor.grayColor().CGColor
        label.layer.borderWidth = 0.0
        label.layer.cornerRadius = 1
        label.layer.masksToBounds = false
        label.layer.shadowRadius = 1.0
        label.layer.shadowColor = UIColor.lightGrayColor().CGColor
        label.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        label.layer.shadowOpacity = 0.3
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

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}