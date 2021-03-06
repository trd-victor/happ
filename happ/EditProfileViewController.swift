//
//  EditProfileViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 26/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var skillView: UIView!
    @IBOutlet var separator: UIView!
    @IBOutlet var separator2: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var navBackProfile: UIBarButtonItem!
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var StatusItem: UIBarButtonItem!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var labelSkills: UILabel!
    
    @IBOutlet var labelName: UILabel!
    @IBOutlet var userNamefield: UITextField!
    
    let userDescription: UITextView = UITextView()
    let separatorLine: UIView = UIView()
    let selectContainer: UIView = UIView()
    let selectSkillLbl: UILabel = UILabel()
    let goToSelectSkill: UIImageView = UIImageView()
    let selectedSkillsLbl: UILabel = UILabel()
    let listOfSkills: UILabel = UILabel()
    let happLbl: UILabel = UILabel()
    
    var language: String!
    var userId: String = ""
    var imageName: String = ""
    var checkNewImage: Bool = false
    var galleryPicker = UIImagePickerController()
    var loadingScreen: UIView!
    var firstLoad: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.addSubview(self.happLbl)
        self.scrollView.addSubview(self.selectContainer)
        self.scrollView.addSubview(self.userDescription)
        self.selectContainer.addSubview(self.selectSkillLbl)
        self.selectContainer.addSubview(self.goToSelectSkill)
        self.selectContainer.addSubview(self.separatorLine)
        self.scrollView.addSubview(self.selectedSkillsLbl)
        self.scrollView.addSubview(self.listOfSkills)
        
        self.selectContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectSkill"))
        
        //set delegate ..
        userNamefield.delegate = self
        galleryPicker.delegate = self
        
        //load language set.
        language = setLanguage.appLanguage
        
        if language == "ja" {
            language = "jp"
        }
        
        self.loadConfigure()
        
        //get user Id...
        userId = globalUserId.userID
        
        if userId != "" {
            self.setRounded(userImage)
            self.loadUserData()
        }
        
        self.navBackProfile.action = Selector("backToConfiguration:")
        
        //add clickable profile image
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:Selector("openGallery"))
        userImage.userInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
        
        view.endEditing(true)
        
        autoLayout()
        reg_user.didUpdate = false
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeBackTimeline:");
        swipeRight.direction = .Right
        
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func swipeBackTimeline(sender: UISwipeGestureRecognizer){
        let transition: CATransition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var skills = ""
        let config = SYSTEM_CONFIG()
        
        self.selectSkillLbl.text = config.translate("select_skill")
        self.selectedSkillsLbl.text = config.translate("selected_skill")
        self.userDescription.textViewDidChange(self.userDescription)
        if reg_user.didUpdate {
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
            reg_user.didUpdate = false
        }
        
    }
    
    func selectSkill(){
        let vc = SelectSkillViewController()
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
        
        self.StatusItem.tintColor = UIColor.whiteColor()
        view.backgroundColor = UIColor(hexString: "#272727")
        navBar.tintColor = UIColor(hexString: "#272727")
        
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
        userImage.contentMode = .ScaleAspectFill
        userImage.layer.cornerRadius = 37
        userImage.clipsToBounds = true
        
        happLbl.translatesAutoresizingMaskIntoConstraints = false
        happLbl.centerXAnchor.constraintEqualToAnchor(userNamefield.centerXAnchor).active = true
        happLbl.topAnchor.constraintEqualToAnchor(userImage.bottomAnchor).active = true
        happLbl.widthAnchor.constraintEqualToAnchor(userNamefield.widthAnchor).active = true
        happLbl.heightAnchor.constraintEqualToConstant(38).active = true
        happLbl.textAlignment = .Center
        happLbl.textColor = UIColor.grayColor()
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        separator.topAnchor.constraintEqualToAnchor(happLbl.bottomAnchor, constant: 5).active = true
        separator.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        userNamefield.translatesAutoresizingMaskIntoConstraints = false
        userNamefield.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        userNamefield.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        userNamefield.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        userNamefield.heightAnchor.constraintEqualToConstant(38).active = true
        userNamefield.setRightPaddingPoints(10)
        userNamefield.setLeftPaddingPoints(65)
        userNamefield.tintColor = UIColor.blackColor()
        
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
        userDescription.topAnchor.constraintEqualToAnchor(separator2.bottomAnchor, constant: 5).active = true
        userDescription.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        userDescription.heightAnchor.constraintEqualToConstant(100).active = true
        userDescription.tintColor = UIColor.blackColor()
        userDescription.font = UIFont.systemFontOfSize(15)
        userDescription.tag = 200
        
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
        
        self.separatorLine.translatesAutoresizingMaskIntoConstraints = false
        self.separatorLine.topAnchor.constraintEqualToAnchor(self.selectContainer.bottomAnchor).active = true
        self.separatorLine.leftAnchor.constraintEqualToAnchor(self.selectContainer.leftAnchor).active = true
        self.separatorLine.widthAnchor.constraintEqualToAnchor(self.selectContainer.widthAnchor).active = true
        self.separatorLine.heightAnchor.constraintEqualToConstant(1).active = true
        self.separatorLine.backgroundColor = UIColor(hexString: "#DDDDDD")
        
        self.selectContainer.translatesAutoresizingMaskIntoConstraints = false
        self.selectContainer.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor).active = true
        self.selectContainer.topAnchor.constraintEqualToAnchor(self.labelSkills.bottomAnchor).active = true
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
    }
    
    
    func loadConfigure() {
        
        let config = SYSTEM_CONFIG()
        
        //set label text..
        navTitle.title = config.translate("title_edit_profile")
        StatusItem.title = config.translate("button_save")
        labelName.text = config.translate("text_name")
        userNamefield.placeholder = config.translate("holder_15_more_char")
        labelSkills.text = config.translate("subtitle_skills")
        
        self.userDescription.addPlaceholder(config.translate("holder_profile_statement"))
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
    
    func backToConfiguration(sender: UIBarButtonItem) -> () {
        reg_user.selectedSkills = []
        reg_user.didUpdate = false
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("Configuration") as! ConfigurationViewController
        
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.dissmissDetail(vc)
    }
    
    func dissmissDetail(viewControllerToPresent: UIViewController){
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserData() {
        if loadingScreen == nil {
            loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        let config = SYSTEM_CONFIG()
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(URL: globalvar.API_URL)
        
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
            "sercret"     : globalvar.secretKey,
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

            //user Data...
            var name: String = ""
            var hID: String = ""
            var image: String = ""
            var skills: String = ""
            var message: String = ""
            
            if error != nil || data == nil{
                self.loadUserData()
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        dispatch_async(dispatch_get_main_queue()){
                            
                            if json["success"] != nil {
                                if json["result"] != nil {
                                    if let user_name  = json["result"]!["name"] as? String {
                                        name = user_name
                                    }
                                    
                                    if let h_id = json["result"]!["h_id"] as? String {
                                        hID = h_id
                                    }
                                    
                                    if let skill_data = json["result"]!["skills"] as? String {
                                        let arrayData = skill_data.characters.split(",")
                                        reg_user.selectedSkills = []
                                        
                                        if arrayData.count == 0 {
                                            self.listOfSkills.text = config.translate("empty_skills")
                                            self.listOfSkills.textAlignment = .Center
                                        }else{
                                            for var i = 0; i < arrayData.count; i++ {
                                                let id = String(arrayData[i])
                                                if (Int(id) != nil) {
                                                    reg_user.selectedSkills.append(Int(id)!)
                                                    
                                                    skills += config.getSkillByID(String(arrayData[i]))
                                                }else{
                                                    skills += skills
                                                }
                                                
                                                if i == arrayData.count - 1 {
                                                    self.listOfSkills.text = skills
                                                    self.listOfSkills.textAlignment = .Justified
                                                }else{
                                                    skills += ", "
                                                }
                                            }
                                        }
                                    }
                                    
                                    if let icon = json["result"]!["icon"] as? String {
                                        image = icon
                                    } else {
                                        image = ""
                                    }
                                    
                                    let url = image.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
                                    let data = NSData(contentsOfURL: NSURL(string: "\(url)")!)
                                    
                                    dispatch_async(dispatch_get_main_queue()){
                                        self.userNamefield.text = name
                                        self.happLbl.text = hID
                                        
                                        if data != nil {
                                            //save new photo on firebase database
                                            if self.checkNewImage {
                                                let uid = FIRAuth.auth()?.currentUser?.uid
                                                FIRDatabase.database().reference().child("users").child(uid!).child("photoUrl").setValue(image)
                                                self.checkNewImage = false
                                            }
                                            self.userImage.image = UIImage(data: data!)
                                        } else {
                                            self.userImage.image = UIImage(named: "noPhoto")
                                        }
                                        
                                        if let message = json["result"]!["mess"] as? String {
                                            self.userDescription.text = message.stringByDecodingHTMLEntities
                                            
                                            self.userDescription.textViewDidChange(self.userDescription)
                                        }
                                        
                                        if self.loadingScreen != nil {
                                            UIViewController.removeSpinner(self.loadingScreen)
                                            self.loadingScreen = nil
                                        }
                                    }
                                }else{
                                    if self.loadingScreen != nil {
                                        UIViewController.removeSpinner(self.loadingScreen)
                                        self.loadingScreen = nil
                                    }
                                    
                                    self.logoutMessage()
                                }

                            }else{
                                if self.loadingScreen != nil {
                                    UIViewController.removeSpinner(self.loadingScreen)
                                    self.loadingScreen = nil
                                }
                                
                                self.logoutMessage()
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
        
    }
    
    func logoutMessage(){
        let config = SYSTEM_CONFIG()
        let myAlert = UIAlertController(title: "", message: config.translate("message_account_deleted"), preferredStyle: UIAlertControllerStyle.Alert)
        myAlert.addAction(UIAlertAction(title: config.translate("label_logout"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
            do {
                try FIRAuth.auth()?.signOut()
                
                config.removeSYS_VAL("userID")
                globalUserId.userID = ""
            } catch (let error) {
                print((error as NSError).code)
            }
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewControllerWithIdentifier("MainBoard") as! ViewController
            
            let transition: CATransition = CATransition()
            transition.duration = 0.40
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromBottom
            self.view.window!.layer.addAnimation(transition, forKey: nil)
            self.presentViewController(vc, animated: false, completion: nil)
        }))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func removeFIRObserver(firID: String){
        FIRDatabase.database().reference().child("registration-token").child(firID).child("token").setValue("")
        FIRDatabase.database().reference().child("users").removeAllObservers()
        FIRDatabase.database().reference().child("user-badge").child("freetime").child(firID).removeAllObservers()
        FIRDatabase.database().reference().child("user-badge").child("timeline").child(firID).removeAllObservers()
        FIRDatabase.database().reference().child("user-badge").child("reservation").child(firID).removeAllObservers()
        FIRDatabase.database().reference().child("chat").child("last-message").child(firID).removeAllObservers()
        FIRDatabase.database().reference().child("chat").child("last-message").child(firID).queryOrderedByChild("timestamp").removeAllObservers()
        FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(firID).child("unread").removeAllObservers()
        if chatVar.RoomID != "" {
            FIRDatabase.database().reference().child("chat").child("members").child(chatVar.RoomID).removeAllObservers()
            FIRDatabase.database().reference().child("chat").child("messages").child(chatVar.RoomID).queryOrderedByChild("timestamp").removeAllObservers()
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func StatusItem(sender: AnyObject) {
        self.scrollView.setContentOffset(CGPointMake(0.0, 0.0), animated: true);
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        if loadingScreen == nil {
            loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        //setting up the textbox...
        let name = userNamefield.text!
        let userDesc = userDescription.text!
        let config = SYSTEM_CONFIG()
        
        if name == "" || userDesc == ""  {
            displayMyAlertMessage(config.translate("mess_fill_missing_field"))
        }else if name.characters.count > 15{
            displayMyAlertMessage(config.translate("mess_15_or_more"))
        }
        else {
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(URL: globalvar.API_URL)
            
            //set boundary string..
            let boundary = generateBoundaryString()
            
            //set value for image upload
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            //setting the method to post
            request.HTTPMethod = "POST"
            
            let skills2 = reg_user.selectedSkills.flatMap({String($0)}).joinWithSeparator(",")
            globalUserId.skills = skills2
            
            var targetedData: String
            
            //check if there is new Image selected on gallery
            if checkNewImage {
                targetedData = "name,skills,mess,icon"
            }else{
                targetedData = "name,skills,mess"
            }
            
            //set parameters...
            let param = [
                "sercret"     : globalvar.secretKey,
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
                
                if error != nil || data == nil{
                    self.StatusItem(sender)
                }else {
                    do {
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            let vc = LaunchScreenViewController()
                            vc.getAllUserInfo()
                            
                            if json!["message"] != nil {
                                message = json!["message"] as! String
                            }
                            
                            if json!["result"] != nil {
                                message = json!["result"]!["mess"] as! String
                            }
                            
                            var errorMessage: Int
                            if json!["error"] != nil {
                                errorMessage = json!["error"] as! Int
                                if errorMessage == 1 {
                                    self.displayMyAlertMessage(message)
                                }
                            }
                            if json!["success"] != nil {
                                //updating image url on firebase
                                self.setImageToFirebaseUser(message)
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
        if loadingScreen != nil {
            UIViewController.removeSpinner(loadingScreen)
            loadingScreen = nil
        }
        
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func setImageToFirebaseUser(message: String){
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(URL: globalvar.API_URL)
        
        //set boundary string..
        let boundary = generateBoundaryString()
        
        //set value for image upload
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //setting the method to post
        request.HTTPMethod = "POST"
        
        //        set parameters...
        let param = [
            "sercret"     : globalvar.secretKey,
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
            
            if error != nil || data == nil{
               self.setImageToFirebaseUser(message)
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if json["result"] != nil {
                            var image: String!
                            
                            if let _ = json["result"]!["icon"] as? NSNull {
                                image = ""
                            } else {
                                image = json["result"]!["icon"] as? String
                            }
                            
                            dispatch_async(dispatch_get_main_queue()){
                                
                                self.updateNotif(image){
                                    (complete: Bool) in
                                    self.updateData(image, mess: message)
                                }
                            }
                        }
                    }
                    
                } catch {
                    print(error)
                }

            }
        }
        task.resume()
    }
    
    func updateData(image: String, mess: String){
        let name = self.userNamefield.text!
        self.getChatRoomID({
            (data: [FIRDataSnapshot]) in
            self.getMessageData(data, image: image, name: name){
                (result: Bool) in
                
                self.getLastMessage(image, name: name, mess: mess)
            }
        })
    }
    
    
    func getChatRoomID(completion: (data: [FIRDataSnapshot])-> Void){
        
        let userid = FIRAuth.auth()?.currentUser?.uid
        let membersDb = FIRDatabase.database().reference().child("chat").child("members").queryOrderedByChild(String(userid!)).queryEqualToValue(true)
        membersDb.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if let result =  snapshot.children.allObjects as? [FIRDataSnapshot] {
                completion(data: result)
            }
        })
    }
    
    func getLastMessage(image: String, name: String, mess: String){
        
        if let fid = FIRAuth.auth()?.currentUser?.uid {
            
            let lmDB = FIRDatabase.database().reference().child("chat").child("last-message").child(fid)
            lmDB.observeSingleEventOfType(.Value, withBlock: {(snap) in
                if snap.exists(){
                    if let result = snap.children.allObjects as? [FIRDataSnapshot] {
                        for data in result {
                            if let value = data.value as? NSDictionary {
                                if let mateID = value["chatmateId"] as? String {
                                    self.eachLastMessage(data.key,chatmateID: mateID, image: image, name: name)
                                }
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.displayMyAlertMessage(mess)
                }
            });
        }
    }
    
    func eachLastMessage(roomID: String,chatmateID: String,image: String, name: String){
        
        if roomID == "" || chatmateID == "" {
            return
        }
        let lmDB = FIRDatabase.database().reference().child("chat").child("last-message").child(chatmateID).child(roomID)
        
        lmDB.child("name").setValue(name)
        lmDB.child("photoUrl").setValue(image)
    }
    
    func getMessageData(data: [FIRDataSnapshot], image: String, name: String, completion: (result: Bool)->Void){
        let firID = FIRAuth.auth()?.currentUser?.uid
        
        if data.count > 0 {
            for s in data {
                let key = s.key
                let messageDB = FIRDatabase.database().reference().child("chat").child("messages").child(key)
                
                messageDB.observeSingleEventOfType(.Value, withBlock: {(snap) in
                    if let result =  snap.children.allObjects as? [FIRDataSnapshot] {
                        if result.count > 0 {
                            for data in result {
                                if let value = data.value as? NSDictionary {
                                    if let user_id = value["userId"] as? String {
                                        
                                        if user_id == firID! {
                                            let mess_key = data.key
                                            
                                            messageDB.child(mess_key).child("name").setValue(name)
                                            messageDB.child(mess_key).child("photoUrl").setValue(image)
                                        }
                                    }
                                }
                            }
                        }
                    }
                })
            }
        }
        
        dispatch_async(dispatch_get_main_queue()){
            completion(result: true)
        }
    }
    
    func updateNotif(image: String, completion: (complete: Bool)-> Void){
        let name = userNamefield.text!
        let firID = FIRAuth.auth()?.currentUser?.uid
        let notifDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-all")
            .queryOrderedByChild("userId").queryEqualToValue(firID!)
        
        let notifAllDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-all")
        
        notifDB.observeSingleEventOfType(.Value, withBlock: {(snap) in
            if let result =  snap.children.allObjects as? [FIRDataSnapshot] {
                if result.count > 0 {
                    for data in result {
                        if let value = data.value as? NSDictionary {
                            if let user_id = value["userId"] as? String {
                                if user_id == firID! {
                                    let mess_key = data.key
                                    notifAllDB.child(mess_key).child("name").setValue(name)
                                    notifAllDB.child(mess_key).child("photoUrl").setValue(image)
                                }
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                completion(complete: true)
            }
        })
    }    
}