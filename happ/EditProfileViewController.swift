//
//  EditProfileViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 26/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var skillView: UIView!
    @IBOutlet var separator: UIView!
    @IBOutlet var separator2: UIView!
    @IBOutlet var separator3: UIView!
    @IBOutlet var separator4: UIView!
    @IBOutlet var separator5: UIView!
    @IBOutlet var separator6: UIView!
    @IBOutlet var separator7: UIView!
    @IBOutlet var separator8: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var navBackProfile: UIBarButtonItem!
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var StatusItem: UIBarButtonItem!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var labelSkills: UILabel!
    @IBOutlet var userDescription: UITextField!
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var userNamefield: UITextField!
    
    //skills label..
    @IBOutlet var labelfrontEnd: UILabel!
    @IBOutlet var labelbackend: UILabel!
    @IBOutlet var labelAndroid: UILabel!
    @IBOutlet var labelIOS: UILabel!
    @IBOutlet var labelAppDesign: UILabel!
    @IBOutlet var labelwebdesign: UILabel!
    
    
    //Switch variabel...
    @IBOutlet var fronendswitch: UISwitch!
    @IBOutlet var backendswitch: UISwitch!
    @IBOutlet var androidswitch: UISwitch!
    @IBOutlet var iosswitch: UISwitch!
    @IBOutlet var appdesignswitch: UISwitch!
    @IBOutlet var backdesignswithc: UISwitch!
    
    var language: String!
    var userId: String = ""
    var imageName: String = ""
    var checkNewImage: Bool = false
    var galleryPicker = UIImagePickerController()
    //    let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set delegate ..
        userDescription.delegate = self
        userNamefield.delegate = self
        galleryPicker.delegate = self
        
        //load language set.
        language = setLanguage.appLanguage
        
        self.loadConfigure()
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, self.userDescription.frame.height))
        userDescription.leftView = paddingView
        userDescription.leftViewMode = UITextFieldViewMode.Always
        
        //get user Id...
        userId = globalUserId.userID
        
        if userId != "" {
            self.setRounded(userImage)
            self.loadUserData()
        }
        
        self.navBackProfile.action = Selector("backToConfiguration:")
        
        //        //add it to the center...
        //        myActivityIndicator.center = view.center
        //
        //        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        //        myActivityIndicator.hidesWhenStopped = true
        //        myActivityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        //
        //        view.addSubview(myActivityIndicator)
        
        //add clickable profile image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("openGallery"))
        userImage.userInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
        
        view.endEditing(true)
        
        autoLayout()
        
    }
    
    func openGallery(){
        galleryPicker.allowsEditing = false
        galleryPicker.sourceType = .PhotoLibrary
        presentViewController(galleryPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
            imageName = imageUrl!.lastPathComponent!
            userImage.contentMode = .ScaleAspectFill
            userImage.image = pickedImage
            
            
            // checking for new profile picture
            checkNewImage = true
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func autoLayout() {
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
        scrollView.contentSize = CGSizeMake(view.frame.width,750)
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        userImage.topAnchor.constraintEqualToAnchor(scrollView.topAnchor, constant: 5).active = true
        userImage.widthAnchor.constraintEqualToConstant(74).active = true
        userImage.heightAnchor.constraintEqualToConstant(74).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        separator.topAnchor.constraintEqualToAnchor(userImage.bottomAnchor, constant: 5).active = true
        separator.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        userNamefield.translatesAutoresizingMaskIntoConstraints = false
        userNamefield.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        userNamefield.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        userNamefield.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        userNamefield.heightAnchor.constraintEqualToConstant(38).active = true
        
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.centerXAnchor.constraintEqualToAnchor(userNamefield.centerXAnchor).active = true
        labelName.topAnchor.constraintEqualToAnchor(userNamefield.topAnchor).active = true
        labelName.widthAnchor.constraintEqualToAnchor(userNamefield.widthAnchor, constant: -20).active = true
        labelName.heightAnchor.constraintEqualToConstant(38).active = true
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        separator2.topAnchor.constraintEqualToAnchor(userNamefield.bottomAnchor).active = true
        separator2.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator2.heightAnchor.constraintEqualToConstant(1).active = true
        
        
        userDescription.translatesAutoresizingMaskIntoConstraints = false
        userDescription.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        userDescription.topAnchor.constraintEqualToAnchor(userNamefield.bottomAnchor, constant: 5).active = true
        userDescription.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        userDescription.heightAnchor.constraintEqualToConstant(100).active = true
        
        skillView.translatesAutoresizingMaskIntoConstraints = false
        skillView.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        skillView.topAnchor.constraintEqualToAnchor(userDescription.bottomAnchor).active = true
        skillView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        skillView.heightAnchor.constraintEqualToConstant(38).active = true
        
        labelSkills.translatesAutoresizingMaskIntoConstraints = false
        labelSkills.centerXAnchor.constraintEqualToAnchor(skillView.centerXAnchor).active = true
        labelSkills.centerYAnchor.constraintEqualToAnchor(skillView.centerYAnchor).active = true
        labelSkills.widthAnchor.constraintEqualToAnchor(skillView.widthAnchor).active = true
        labelSkills.heightAnchor.constraintEqualToConstant(38).active = true
        
        labelfrontEnd.translatesAutoresizingMaskIntoConstraints = false
        labelfrontEnd.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelfrontEnd.topAnchor.constraintEqualToAnchor(skillView.bottomAnchor, constant: 10).active = true
        labelfrontEnd.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelfrontEnd.heightAnchor.constraintEqualToConstant(31).active = true
        
        fronendswitch.translatesAutoresizingMaskIntoConstraints = false
        fronendswitch.frame.size = CGSizeMake(51, 31)
        fronendswitch.topAnchor.constraintEqualToAnchor(skillView.bottomAnchor, constant: 10).active = true
        fronendswitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        separator3.translatesAutoresizingMaskIntoConstraints = false
        separator3.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        separator3.topAnchor.constraintEqualToAnchor(labelfrontEnd.bottomAnchor, constant: 5).active = true
        separator3.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator3.heightAnchor.constraintEqualToConstant(1).active = true
        
        labelbackend.translatesAutoresizingMaskIntoConstraints = false
        labelbackend.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelbackend.topAnchor.constraintEqualToAnchor(labelfrontEnd.bottomAnchor, constant: 10).active = true
        labelbackend.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelbackend.heightAnchor.constraintEqualToConstant(31).active = true
        
        backendswitch.translatesAutoresizingMaskIntoConstraints = false
        backendswitch.frame.size = CGSizeMake(51, 31)
        backendswitch.topAnchor.constraintEqualToAnchor(fronendswitch.bottomAnchor, constant: 10).active = true
        backendswitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        separator4.translatesAutoresizingMaskIntoConstraints = false
        separator4.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        separator4.topAnchor.constraintEqualToAnchor(labelbackend.bottomAnchor, constant: 5).active = true
        separator4.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator4.heightAnchor.constraintEqualToConstant(1).active = true
        
        labelAndroid.translatesAutoresizingMaskIntoConstraints = false
        labelAndroid.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelAndroid.topAnchor.constraintEqualToAnchor(labelbackend.bottomAnchor, constant: 10).active = true
        labelAndroid.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelAndroid.heightAnchor.constraintEqualToConstant(31).active = true
        
        androidswitch.translatesAutoresizingMaskIntoConstraints = false
        androidswitch.frame.size = CGSizeMake(51, 31)
        androidswitch.topAnchor.constraintEqualToAnchor(backendswitch.bottomAnchor, constant: 10).active = true
        androidswitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        separator5.translatesAutoresizingMaskIntoConstraints = false
        separator5.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        separator5.topAnchor.constraintEqualToAnchor(labelAndroid.bottomAnchor, constant: 5).active = true
        separator5.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator5.heightAnchor.constraintEqualToConstant(1).active = true
        
        labelIOS.translatesAutoresizingMaskIntoConstraints = false
        labelIOS.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelIOS.topAnchor.constraintEqualToAnchor(labelAndroid.bottomAnchor, constant: 10).active = true
        labelIOS.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelIOS.heightAnchor.constraintEqualToConstant(31).active = true
        
        iosswitch.translatesAutoresizingMaskIntoConstraints = false
        iosswitch.frame.size = CGSizeMake(51, 31)
        iosswitch.topAnchor.constraintEqualToAnchor(androidswitch.bottomAnchor, constant: 10).active = true
        iosswitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        separator6.translatesAutoresizingMaskIntoConstraints = false
        separator6.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        separator6.topAnchor.constraintEqualToAnchor(labelIOS.bottomAnchor, constant: 5).active = true
        separator6.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator6.heightAnchor.constraintEqualToConstant(1).active = true
        
        labelAppDesign.translatesAutoresizingMaskIntoConstraints = false
        labelAppDesign.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelAppDesign.topAnchor.constraintEqualToAnchor(labelIOS.bottomAnchor, constant: 10).active = true
        labelAppDesign.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelAppDesign.heightAnchor.constraintEqualToConstant(31).active = true
        
        appdesignswitch.translatesAutoresizingMaskIntoConstraints = false
        appdesignswitch.frame.size = CGSizeMake(51, 31)
        appdesignswitch.topAnchor.constraintEqualToAnchor(iosswitch.bottomAnchor, constant: 10).active = true
        appdesignswitch.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        separator7.translatesAutoresizingMaskIntoConstraints = false
        separator7.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        separator7.topAnchor.constraintEqualToAnchor(labelAppDesign.bottomAnchor, constant: 5).active = true
        separator7.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator7.heightAnchor.constraintEqualToConstant(1).active = true
        
        labelwebdesign.translatesAutoresizingMaskIntoConstraints = false
        labelwebdesign.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        labelwebdesign.topAnchor.constraintEqualToAnchor(labelAppDesign.bottomAnchor, constant: 10).active = true
        labelwebdesign.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        labelwebdesign.heightAnchor.constraintEqualToConstant(31).active = true
        
        backdesignswithc.translatesAutoresizingMaskIntoConstraints = false
        backdesignswithc.frame.size = CGSizeMake(51, 31)
        backdesignswithc.topAnchor.constraintEqualToAnchor(appdesignswitch.bottomAnchor, constant: 10).active = true
        backdesignswithc.rightAnchor.constraintEqualToAnchor(view.rightAnchor, constant: -10).active = true
        
        separator8.translatesAutoresizingMaskIntoConstraints = false
        separator8.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        separator8.topAnchor.constraintEqualToAnchor(labelwebdesign.bottomAnchor, constant: 5).active = true
        separator8.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator8.heightAnchor.constraintEqualToConstant(1).active = true
    }
    
    
    func loadConfigure() {
        
        let config = SYSTEM_CONFIG()
        
        //set label text..
        navTitle.title = config.translate("title_edit_profile")
        StatusItem.title = config.translate("button_save")
        labelName.text = config.translate("text_name")
        userNamefield.placeholder = config.translate("holder_15_char/less")
        userDescription.placeholder = config.translate("holder_profile_statement")
        labelSkills.text = config.translate("subtitle_skills")
        labelfrontEnd.text = config.translate("label_front_end")
        labelbackend.text = config.translate("label_server_side")
        labelIOS.text = config.translate("label_IOS_application")
        labelAndroid.text = config.translate("label_android_application")
        labelAppDesign.text = config.translate("label_app_design")
        labelwebdesign.text = config.translate("label_web_design")
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func backToConfiguration(sender: UIBarButtonItem) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Configuration") as! ConfigurationViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserData() {
        //let URL
        let viewDataURL = "https://happ.biz/wp-admin/admin-ajax.php"
        
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
        request.HTTPBody = createBodyWithParameters(param,  data: nil, boundary: boundary)
        
        //             self.myActivityIndicator.startAnimating()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            print("response", response);
            //user Data...
            var name: String!
            var image: String!
            var skills: String!
            var message: String!
            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                print(json)
                if json!["result"] != nil {
                    name    = json!["result"]!["name"] as! String
                    //                        image1   = json!["result"]!["icon"] as! String
                    
                    if let _ = json!["result"]!["icon"] as? NSNull {
                        image = ""
                    } else {
                        image = json!["result"]!["icon"] as? String
                    }
                    
                    
                    skills  = json!["result"]!["skills"] as! String
                    message = json!["result"]!["mess"] as! String
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
                    
                    let url = image.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                    
                    
                    let data = NSData(contentsOfURL: NSURL(string: "\(url)")!)
                    dispatch_async(dispatch_get_main_queue(), {() -> Void in
                        
                        self.userNamefield.text = name
                        if data != nil {
                            //save new photo on firebase database
                            if self.checkNewImage {
                                let uid = globalUserId.FirID
                                FIRDatabase.database().reference().child("users").child("\(uid)").child("photoUrl").setValue(image)
                                self.checkNewImage = false
                            }
                            self.userImage.image = UIImage(data: data!)
                        } else {
                            self.userImage.image = UIImage(named: "noPhoto")
                        }
                        
                        self.userDescription.text = message
                        self.getSkillNotArray(self.returnSkillState(skills))
                    })
                })
                
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func StatusItem(sender: AnyObject) {
        
        //setting up the textbox...
        let name = userNamefield.text!
        let userDesc = userDescription.text!
        
        
        if name == "" || userDesc == ""  {
            displayMyAlertMessage("All Fields Required")
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
            let frontEndSkill   = fronendswitch
            let backEndSkill    = backendswitch
            let iosSkill        = iosswitch
            let androidSkill    = androidswitch
            let appDesignSkill  = appdesignswitch
            let webDesignSkill  = backdesignswithc
            
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
            
            var skills2 = returnSkillValue(skills)
            if skills2 != "" {
                skills2 = String(skills2.characters.dropLast())
            }
            
            var targetedData: String
            
            //check if there is new Image selected on gallery
            if checkNewImage {
                targetedData = "name,skills,mess,icon"
            }else{
                targetedData = "name,skills,mess"
            }
            
            //set parameters...
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "user_update",
                "d"           : "0",
                "lang"        : "\(language)",
                "user_id"     : "\(userId)",
                "name"        : "\(name)",
                "mess"        : "\(userDesc)",
                "skills"      : "\(skills2)",
                "targets"     : "\(targetedData)"
            ]
            //adding the parameters to request body
            request.HTTPBody = createBodyWithParameters(param, data: UIImageJPEGRepresentation(userImage.image!, 0.7),  boundary: boundary)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                var message: String!
                
                if error != nil{
                    print("error is \(error)")
                    return;
                }
                
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
                        if json!["success"] != nil {
                            let uid = globalUserId.FirID
                            FIRDatabase.database().reference().child("users").child("\(uid)").child("name").setValue(name)
                            
                            //updating image url on firebase
                            self.setImageToFirebaseUser()
                        }
                        self.displayMyAlertMessage(message)
                    }
                    
                } catch {
                    print(error)
                }
            }
            task.resume()
        }
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
    
    func returnSkillState(sender: String) -> [String] {
        let userSkills = sender.componentsSeparatedByString(",")
        return userSkills
    }
    
    func getSkillNotArray(sender: [String]) {
        for intskill in sender {
            self.switchButtonOn(intskill)
        }
    }
    func switchButtonOn(skill: String)  {
        if skill == "Front end" {
            self.fronendswitch.setOn(true, animated: true)
        }
        if skill == "Server side" {
            self.backendswitch.setOn(true, animated: true)
        }
        if skill == "IOS application" {
            self.iosswitch.setOn(true, animated: true)
        }
        if skill == "Android application" {
            self.androidswitch.setOn(true, animated: true)
        }
        if skill == "App design" {
            self.appdesignswitch.setOn(true, animated: true)
        }
        if skill == "Web design" {
            self.backdesignswithc.setOn(true, animated: true)
        }
    }
    
    
    func setRounded(sender: UIImageView) {
        sender.layer.cornerRadius = 37
        sender.clipsToBounds = true
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func createBodyWithParameters(parameters: [String: String]?, data: NSData!,  boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        if data != nil && self.checkNewImage == true {
            
            let filename = "profile_\(globalUserId.userID)_\(self.randomString(6))_\(self.randomString(5)).jpg"
            
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"icon\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: image/jpg \r\n\r\n")
            body.appendData(data!)
            body.appendString("\r\n")
        }
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.characterAtIndex(Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func setImageToFirebaseUser(){
        //let URL
        let viewDataURL = "https://happ.biz/wp-admin/admin-ajax.php"
        
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
        request.HTTPBody = createBodyWithParameters(param,  data: nil, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                if json!["result"] != nil {
                    var image: String!
                    
                    if let _ = json!["result"]!["icon"] as? NSNull {
                        image = ""
                    } else {
                        image = json!["result"]!["icon"] as? String
                    }
                    
                    if self.checkNewImage {
                        let uid = globalUserId.FirID
                        FIRDatabase.database().reference().child("users").child("\(uid)").child("photoUrl").setValue(image)
                        self.checkNewImage = false
                    }
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}