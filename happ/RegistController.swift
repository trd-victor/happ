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
            "navigation":"Registration",
            "navBack":"Back",
            "basicInfo":"Basic information",
            "email":"Mail address",
            "emailPlaceholder": "example@xxx.com",
            "pass":"Password",
            "passPlaceholder":"Enter Password",
            "repeatPass":"Re-enter Password",
            "repeatPassPlaceholder":"Re-enter Password",
            "name":"Name",
            "namePlaceholder": "15 characters or less",
            "skills": "Skills",
            "frontEnd":"Front End",
            "backEnd":"Back End",
            "ios":"iOS",
            "android":"Android",
            "appdesign":"Application Design",
            "webdesign":"Web Design",
            "update":"Register as a new member",
            "emtpyFields": "All Fields Required",
            "notMatchPassword": "Password did not match"
            
            
        ],
        "ja": [
            "navigation":"新規会員登録",
            "navBack":"バック",
            "basicInfo":"基本情報",
            "email":"メールアドレス",
            "pass":"パスワード",
            "repeatPass":"パスワード再入力",
            "msg":"Message Jp",
            "name":"お名前",
            "namePlaceholder": "15文字以内",
            "emailPlaceholder":"example@xxx.com",
            "passPlaceholder":"半角英数字4文字以上",
            "repeatPassPlaceholder":"上と同じものを入力",
            "skills": "基本情報",
            "frontEnd":"フロントエンド",
            "backEnd":"サーバーサイド",
            "ios":"iOSアプリ",
            "android":"Androidアプリ",
            "appdesign":"アプリデザイン",
            "webdesign":"ウェブデザイン",
            "update":"新規会員登録する",
            "emtpyFields": "必要なすべてのフィールド",
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
        
        self.scrollview = UIScrollView()
        self.scrollview.delegate = self
        self.scrollview.contentSize = CGSizeMake(1000, 1000)
        view.addSubview(scrollview)
        
        
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
            notmatchPass = arrText["\(language)"]!["notMatchPassword"]
            displayMyAlertMessage(config.translate("not_match_password"))
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
            let keyskill = returnSkillValue(skills)
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
                            self.displayMyAlertMessage(mess)
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
            
            if error1 != nil{
                print("\(error1)")
                return;
            }
            do {
                let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                let result = json2!["result"] as! NSArray
                for data in result {
                
                    let email = data["email"] as! String
                    if email == userEmail {
                        let userId = data["user_id"] as! Int
                        let x: Int = userId
                        let idUser = String(x)
                        self.FirebaseID = idUser
                        self.FirebaseImage = data["icon"] as! String as? String ?? ""
                        self.Firebaseemail = data["email"] as! String
                        self.Firebasename = data["name"] as! String
                        
                         self.insertUserFB(self.Firebaseemail, userPassword: password, name: self.Firebasename, image: self.FirebaseImage, userID:  self.FirebaseID)
                    }
                    else {
                        
                        dispatch_async(dispatch_get_main_queue()) {

                        let userId = data["user_id"] as! Int
                        let x: Int = userId
                        let idUser = String(x)
                        self.FirebaseID = idUser
                        self.FirebaseImage = data["icon"] as? String ?? ""
                        self.Firebaseemail = data["email"] as! String
                        self.Firebasename = data["name"] as! String
                        
                        self.insertUserFB(self.Firebaseemail, userPassword: password, name: self.Firebasename, image: self.FirebaseImage, userID: self.FirebaseID )
                        }
                    }
                }
                
            } catch {
                print(error)
            }
        }
        
        task2.resume()
    }
    
    
    func insertUserFB(userEmail: String, userPassword: String, name: String, image: String, userID : String ) {
        FIRAuth.auth()?.createUserWithEmail(userEmail, password: userPassword, completion: { (user: FIRUser?, error) in
            if error == nil {
//                //connect to firebase db.
                let db = FIRDatabase.database().reference().child("users").childByAutoId()
                
                let token = FIRInstanceID.instanceID().token()!
//                //set users array to insert...
                let userDetails: [String : AnyObject] = [
                    "email"     : userEmail,
                    "id"        : userID,
                    "name"      : name,
                    "photoUrl"  : image,
                    "token"     : token
                ]
//                //insert to users
                db.setValue(userDetails)
                
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
                retString += "\(key),"
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