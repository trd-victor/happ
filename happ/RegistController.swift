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

struct reg_user {
    static var selectedSkills = [Int]()
    static var didUpdate: Bool = false
}

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

    var emptyString: String!
    var language: String!
    var notmatchPass: String!
    var FirebaseID : String!
    var FirebaseImage : String!
    var Firebaseemail : String!
    var Firebasename : String!
    var scrollview : UIScrollView!
    var loadingScreen: UIView!
    let separatorLine: UIView = UIView()
    let selectContainer: UIView = UIView()
    let selectSkillLbl: UILabel = UILabel()
    let goToSelectSkill: UIImageView = UIImageView()
    let selectedSkillsLbl: UILabel = UILabel()
    let listOfSkills: UILabel = UILabel()
    
    var mess: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.addSubview(self.selectContainer)
        self.selectContainer.addSubview(self.selectSkillLbl)
        self.selectContainer.addSubview(self.goToSelectSkill)
        self.selectContainer.addSubview(self.separatorLine)
        self.scrollView.addSubview(self.selectedSkillsLbl)
        self.scrollView.addSubview(self.listOfSkills)
        
        self.selectContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectSkills"))
        
        autoLayout()
        
        //delegate textfield..
        userEmail.delegate = self
        userPassword.delegate = self
        userName.delegate = self
        userReEnterPassword.delegate = self
        self.scrollView.scrollEnabled = true
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
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var skills = ""
        let config = SYSTEM_CONFIG()
        
        self.selectSkillLbl.text = config.translate("select_skill")
        self.selectedSkillsLbl.text = config.translate("selected_skill")
        
        if reg_user.selectedSkills.count == 0{
            self.listOfSkills.text = config.translate("empty_skills")
            self.listOfSkills.textAlignment = .Center
        }else{
            self.listOfSkills.textAlignment = .Justified
        }
        
        for var i = 0; i < reg_user.selectedSkills.count; i++ {
            skills = skills + config.getSkillByID(String(reg_user.selectedSkills[i]))
            
            if i == reg_user.selectedSkills.count - 1 {
                self.listOfSkills.text = skills
            }else{
                skills = skills + ", "
            }
        }
    }
    
    func selectSkills(){
        let vc = SelectSkillViewController()
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
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
        userName.tintColor = UIColor.blackColor()
        userName.setRightPaddingPoints(10)
        userName.setLeftPaddingPoints(75)
        
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
        userEmail.tintColor = UIColor.blackColor()
        userEmail.setLeftPaddingPoints(140)
        userEmail.setRightPaddingPoints(10)
        
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
        userPassword.tintColor = UIColor.blackColor()
        userPassword.setLeftPaddingPoints(110)
        userPassword.setRightPaddingPoints(10)
        
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
        userReEnterPassword.tintColor = UIColor.blackColor()
        userReEnterPassword.setLeftPaddingPoints(175)
        userReEnterPassword.setRightPaddingPoints(10)
        
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
        
        self.separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.separatorLine.topAnchor.constraintEqualToAnchor(self.selectContainer.bottomAnchor).active = true
        self.separatorLine.leftAnchor.constraintEqualToAnchor(self.selectContainer.leftAnchor).active = true
        self.separatorLine.widthAnchor.constraintEqualToAnchor(self.selectContainer.widthAnchor).active = true
        self.separatorLine.heightAnchor.constraintEqualToConstant(1).active = true
        self.separatorLine.backgroundColor = UIColor(hexString: "#DDDDDD")
        
        self.selectContainer.translatesAutoresizingMaskIntoConstraints = false
        self.selectContainer.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor).active = true
        self.selectContainer.topAnchor.constraintEqualToAnchor(self.labelSkill.bottomAnchor).active = true
        self.selectContainer.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        self.selectContainer.heightAnchor.constraintEqualToConstant(48).active = true
        self.selectContainer.backgroundColor = UIColor.whiteColor()
        
        self.selectSkillLbl.translatesAutoresizingMaskIntoConstraints = false
        self.selectSkillLbl.leftAnchor.constraintEqualToAnchor(self.selectContainer.leftAnchor, constant: 5).active = true
        self.selectSkillLbl.topAnchor.constraintEqualToAnchor(self.selectContainer.topAnchor, constant: 5).active = true
        self.selectSkillLbl.widthAnchor.constraintEqualToAnchor(self.selectContainer.widthAnchor, constant: -40).active = true
        self.selectSkillLbl.heightAnchor.constraintEqualToConstant(38).active = true
        self.selectSkillLbl.textColor = UIColor.blackColor()
        
        self.goToSelectSkill.image = UIImage(named: "right-icon")
        self.goToSelectSkill.tintColor = UIColor(hexString: "#C7C7CC")
        self.goToSelectSkill.translatesAutoresizingMaskIntoConstraints = false
        self.goToSelectSkill.rightAnchor.constraintEqualToAnchor(self.selectContainer.rightAnchor, constant: -10).active = true
        self.goToSelectSkill.centerYAnchor.constraintEqualToAnchor(self.selectContainer.centerYAnchor).active = true
        self.goToSelectSkill.widthAnchor.constraintEqualToConstant(25).active = true
        self.goToSelectSkill.heightAnchor.constraintEqualToConstant(25).active = true
        
        self.selectedSkillsLbl.translatesAutoresizingMaskIntoConstraints = false
        self.selectedSkillsLbl.topAnchor.constraintEqualToAnchor(self.selectContainer.bottomAnchor, constant: 10).active = true
        self.selectedSkillsLbl.centerXAnchor.constraintEqualToAnchor(self.scrollView.centerXAnchor).active = true
        self.selectedSkillsLbl.widthAnchor.constraintEqualToAnchor(self.selectContainer.widthAnchor).active = true
        self.selectedSkillsLbl.textAlignment = .Center
        self.selectedSkillsLbl.textColor = UIColor.blackColor()
        
        self.listOfSkills.translatesAutoresizingMaskIntoConstraints = false
        self.listOfSkills.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.listOfSkills.topAnchor.constraintEqualToAnchor(self.selectedSkillsLbl.bottomAnchor, constant: 10).active = true
        self.listOfSkills.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.listOfSkills.textColor = UIColor(hexString: "#888888")
        self.listOfSkills.numberOfLines = 0
        self.listOfSkills.lineBreakMode = .ByWordWrapping
        
        self.btnUpdate.translatesAutoresizingMaskIntoConstraints = false
        self.btnUpdate.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        self.btnUpdate.topAnchor.constraintEqualToAnchor(self.listOfSkills.bottomAnchor, constant: 10).active = true
        self.btnUpdate.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -40).active = true
        self.btnUpdate.heightAnchor.constraintEqualToConstant(48).active = true

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
        
        btnUpdate.setTitle(config.translate("btn_regist_new_member"), forState: .Normal)
    }
    
    func backHome(sender: UIBarButtonItem) -> () {
        reg_user.selectedSkills = []
        reg_user.didUpdate = false
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func registerUser(sender: AnyObject) {
        //scroll to top
        self.scrollView.setContentOffset(CGPointMake(0.0, 0.0), animated: true);
        
        //setting up the textbox...
        let email = userEmail.text!
        let pass = userPassword.text!
        let name = userName.text!
        let reEnterpassword = userReEnterPassword.text!
        
//        let registError = Error()
        
        let config = SYSTEM_CONFIG()
        
        if email == "" || pass == "" || name == "" || reEnterpassword == "" {
            displayMyAlertMessage(config.translate("mess_fill_missing_field"))
        }else if pass.characters.count < 6 {
            displayMyAlertMessage(config.translate("mess_password_min_char"))
        }else if pass != reEnterpassword {
            displayMyAlertMessage(config.translate("mess_password_not_match"))
        }
        else {
            if loadingScreen == nil {
                loadingScreen = UIViewController.displaySpinner(self.view)
            }
            
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
            

            //set skill into variable and targets...
            let keyskill = reg_user.selectedSkills.flatMap({String($0)}).joinWithSeparator(",")
            
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

                if error != nil || data == nil{
                    self.registerUser(sender)
                }else{
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            if json!["message"] != nil {
                                self.mess = json!["message"] as! String
                            }
                            if json!["result"] != nil {
                                if json!["result"]!["mess"] != nil {
                                    self.mess = json!["result"]!["mess"] as! String
                                }
                            }
                            
                            var errorMessage : Bool
                            if json!["error"] != nil {
                                errorMessage = json!["error"] as! Bool
                                if errorMessage == true {
                                    self.displayMyAlertMessage(self.mess)
                                }
                            } else {
                               
                                self.loadUserData(name, userEmail: email, password: pass)
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
    
    func successMessageAlert(userMessage: String) {
        if self.loadingScreen != nil {
            UIViewController.removeSpinner(self.loadingScreen)
            self.loadingScreen = nil
        }
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.userEmail.text = ""
            self.userPassword.text = ""
            self.userName.text = ""
            self.userReEnterPassword.text = ""
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
                
                 self.successMessageAlert(self.mess)
                
                
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

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}