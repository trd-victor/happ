//
//  CreatePostViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 31/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase


class CreatePostViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var navBack: UIBarButtonItem!
    @IBOutlet var saveItem: UIBarButtonItem!
    @IBOutlet var saveContent: UITextField!
    @IBOutlet var content: UITextView!
    @IBOutlet var btnCamera: UIButton!
    @IBOutlet var btnGallery: UIButton!
    @IBOutlet var separator: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var imgList = [UIImage]()
    var imgView = [UIImageView]()
    
    
    //basepath
    let baseUrl: NSURL = NSURL(string: "https://happ.biz/wp-admin/admin-ajax.php")!
    var language: String!
    
    var empty_post = "false"
    var withContent = "false"
    var withImage = "false"
    var keyboardCheck = "false"
    var keyboardHeight: CGFloat = 0.0
    var viewHeight:CGFloat = 0.0
    
    //get usertimeline parameters...
    var getTimeline = [
        "sercret"     : "jo8nefamehisd",
        "action"      : "api",
        "ac"          : "get_timeline",
        "d"           : "0",
        "lang"        : "en",
        "user_id"     : "\(globalUserId.userID)",
    ]
    
    let kboardView = UIView(frame: CGRectMake(0, 0, 10, 44))
    
    
    let subView1: UIView = {
        let view = UIView()
        return view
    }()
    
    let subView2: UIView = {
        let view = UIView()
        return view
    }()
    
    
    let subView3: UIView = {
        let view = UIView()
        return view
    }()
    
    
    
    let btnRemove: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    
    let btnRemove2: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    
    let btnRemove3: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    let imgView1: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    
    let imgView2: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    
    let imgView3: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.subView1.clipsToBounds = true
        self.subView2.clipsToBounds = true
        self.subView3.clipsToBounds = true
        
        self.scrollView.addSubview(self.subView1)
        self.scrollView.addSubview(self.subView2)
        self.scrollView.addSubview(self.subView3)
        
        self.kboardView.backgroundColor = UIColor(red: 253, green: 252, blue: 251, alpha: 1)
        
        self.kboardView.addSubview(btnCamera)
        self.kboardView.addSubview(btnGallery)
        self.kboardView.addSubview(separator)
        
        //load language set.
        language = setLanguage.appLanguage
        
        if language == "ja" {
            language = "jp"
        }
        
        self.content.delegate = self
        self.content.textColor = UIColor.lightGrayColor()
        
        self.content.inputAccessoryView = self.kboardView
        
        //set navback transition...
        self.navBack.action = Selector("dismissMe:")
        
        self.content.delegate = self
        self.loadConfigure()
        
        let btnTap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "removeImage1")
        self.btnRemove.addGestureRecognizer(btnTap1)
        let btnTap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "removeImage2")
        self.btnRemove2.addGestureRecognizer(btnTap2)
        let btnTap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "removeImage3")
        self.btnRemove3.addGestureRecognizer(btnTap3)
        
        autoLayout()
    }
    
    func autoLayout() {
        self.navBar.translatesAutoresizingMaskIntoConstraints = false
        self.navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        self.navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        self.navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        self.navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraintEqualToAnchor(self.navBar.bottomAnchor).active = true
        self.scrollView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        self.scrollView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        self.scrollView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width,height: 400)
        
        self.content.translatesAutoresizingMaskIntoConstraints = false
        self.content.centerXAnchor.constraintEqualToAnchor(self.scrollView.centerXAnchor).active = true
        self.content.topAnchor.constraintEqualToAnchor(self.scrollView.topAnchor).active = true
        self.content.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
        self.content.heightAnchor.constraintEqualToAnchor(self.scrollView.heightAnchor).active = true
        
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.topAnchor.constraintEqualToAnchor(self.kboardView.topAnchor).active = true
        self.separator.centerXAnchor.constraintEqualToAnchor(self.kboardView.centerXAnchor).active = true
        self.separator.widthAnchor.constraintEqualToAnchor(self.kboardView.widthAnchor).active = true
        self.separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        self.btnCamera.translatesAutoresizingMaskIntoConstraints = false
        self.btnCamera.leftAnchor.constraintEqualToAnchor(self.kboardView.leftAnchor,constant: 3).active = true
        self.btnCamera.topAnchor.constraintEqualToAnchor(self.kboardView.topAnchor, constant: 2).active = true
        self.btnCamera.widthAnchor.constraintEqualToConstant(44).active = true
        self.btnCamera.heightAnchor.constraintEqualToConstant(44).active = true
        
        self.btnGallery.translatesAutoresizingMaskIntoConstraints = false
        self.btnGallery.leftAnchor.constraintEqualToAnchor(self.btnCamera.rightAnchor,constant: 3).active = true
        self.btnGallery.topAnchor.constraintEqualToAnchor(self.kboardView.topAnchor, constant: 2).active = true
        self.btnGallery.widthAnchor.constraintEqualToConstant(44).active = true
        self.btnGallery.heightAnchor.constraintEqualToConstant(44).active = true
        
        self.subView1.translatesAutoresizingMaskIntoConstraints = false
        self.subView2.translatesAutoresizingMaskIntoConstraints = false
        self.subView3.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @IBAction func btnGallery(sender: AnyObject) {
        handlerGallery()
    }
    
    @IBAction func btnCamera(sender: AnyObject) {
        handlerCamera()
    }
    
    func loadConfigure() {
        let config = SYSTEM_CONFIG()
        //set text
        self.saveItem.title = config.translate("button_post")
        self.content.text = config.translate("holder_post_content")
    }
    
    func dismissMe(sender: UIBarButtonItem) -> () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveItem(sender: UIBarButtonItem) {
        
        let config = SYSTEM_CONFIG()
        
        if ( withContent == "true" || withImage == "true" ) {
            var body = self.content.text!
            if body == config.translate("holder_post_content") {
                body = " "
            }
            let postTimeline = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "update_timeline",
                "d"           : "0",
                "lang"        : "en",
                "user_id"     : "\(globalUserId.userID)",
                "body"        : "\(body)"
            ]
            
            //save post data
            empty_post = "false"
            self.savePost(postTimeline)
        }else{
            empty_post = "true"
            self.displayMyAlertMessage(config.translate("empty_post"))
        }
        
    }
    
    func textViewDidChange(textView: UITextView) {
        let calcHeight = calcTextHeight(self.content.text, frame: self.content.frame.size, fontsize: 14)
        if calcHeight.height > 80 {
            let height = Int(calcHeight.height)
            self.content.removeConstraints(self.content.constraints)
            self.content.translatesAutoresizingMaskIntoConstraints = true
            self.content.translatesAutoresizingMaskIntoConstraints = false
            self.content.centerXAnchor.constraintEqualToAnchor(self.scrollView.centerXAnchor).active = true
            self.content.topAnchor.constraintEqualToAnchor(self.scrollView.topAnchor).active = true
            self.content.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
            self.content.heightAnchor.constraintEqualToConstant(CGFloat(height) + 20).active = true
        }
        if textView.text.characters.count > 0 {
            self.withContent = "true"
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if self.content.textColor == UIColor.lightGrayColor() {
            self.content.text = ""
            self.content.textColor = UIColor.blackColor()
        }
        if self.content.text.characters.count == 0 {
            self.withContent = "false"
        }else{
            self.withContent = "true"
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        let config = SYSTEM_CONFIG()
        if self.content.text == "" {
            withContent = "false"
            self.content.text = config.translate("holder_post_content")
            self.content.textColor = UIColor.lightGrayColor()
        }
    }
    
    private func calcTextHeight(text: String, frame: CGSize, fontsize: CGFloat) -> CGRect{
        let size = CGSize(width: frame.width, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(fontsize)], context: nil)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func savePost(parameters: [String: String]?) {
        
        let loadingView: UIView = UIView()
        
        saveItem.enabled = false
        navBack.enabled = false
        content.userInteractionEnabled = false
        loadingView.backgroundColor = UIColor.grayColor()
        loadingView.alpha = 0.3
        view.addSubview(loadingView)
        view.sendSubviewToBack(scrollView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        loadingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loadingView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        loadingView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        
        var mess: Bool!
        let config = SYSTEM_CONFIG()
        
        let request1 = NSMutableURLRequest(URL: self.baseUrl)
        let boundary1 = generateBoundaryString()
        request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
        request1.HTTPMethod = "POST"
        
        
        request1.HTTPBody = createBodyWithParameters(parameters, boundary: boundary1)
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1){
            data1, response1, error1 in
            
            if error1 != nil || data1 == nil{
                self.savePost(parameters)
            }else {
                do {
                    let json3 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if json3!["success"] != nil {
                            mess = json3!["success"] as! Bool
                            let postID = json3!["result"] as? Int
                            
                            let notif = NotifController()
                            notif.saveNotificationMessage(postID!, type: "timeline")
                        }
                        
                        if mess == true {
                            NSNotificationCenter.defaultCenter().postNotificationName("reloadTimeline", object: nil, userInfo: nil)
                            self.displayMyAlertMessage(config.translate("saved_post"))
                            self.content.text = config.translate("holder_post_content")
                        }
                    }
                    
                } catch {
                    print(error)
                }
                
            }
            
        }
        task2.resume()
        
        
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
        
        if self.imgView1.image != nil {
            body.appendString("--\(boundary)\r\n")
            let imageData = UIImageJPEGRepresentation(self.imgView1.image!,0.5)
            let fileName = "\(randomString(16))-\(randomString(16)).jpg"
            body.appendString("Content-Disposition: form-data; name=\"images[0]\"; filename=\"\(fileName)\"\r\n")
            body.appendString("Content-Type: image/jpg \r\n\r\n")
            body.appendData(imageData!)
            body.appendString("\r\n")
        }
        if self.imgView2.image != nil {
            body.appendString("--\(boundary)\r\n")
            let imageData = UIImageJPEGRepresentation(self.imgView2.image!,0.5)
            let fileName = "\(randomString(16))-\(randomString(16)).jpg"
            body.appendString("Content-Disposition: form-data; name=\"images[1]\"; filename=\"\(fileName)\"\r\n")
            body.appendString("Content-Type: image/jpg \r\n\r\n")
            body.appendData(imageData!)
            body.appendString("\r\n")
        }
        if self.imgView3.image != nil {
            body.appendString("--\(boundary)\r\n")
            let imageData = UIImageJPEGRepresentation(self.imgView3.image!,0.5)
            let fileName = "\(randomString(16))-\(randomString(16)).jpg"
            body.appendString("Content-Disposition: form-data; name=\"images[2]\"; filename=\"\(fileName)\"\r\n")
            body.appendString("Content-Type: image/jpg \r\n\r\n")
            body.appendData(imageData!)
            body.appendString("\r\n")
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyz0123456789abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
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
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if self.empty_post != "true" {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func loadTimelineImagePost(){
        withImage = "false"
        var tmpText = ""
        if let text = self.content.text {
            tmpText = text
        }
        
        self.content.text = tmpText
        
        
        for views in self.scrollView.subviews {
            views.removeFromSuperview()
        }
        
        self.scrollView.addSubview(self.subView1)
        self.scrollView.addSubview(self.subView2)
        self.scrollView.addSubview(self.subView3)
        self.scrollView.addSubview(self.content)
        
        let calcHeight = calcTextHeight(self.content.text, frame: self.content.frame.size, fontsize: 14)
        
        self.content.translatesAutoresizingMaskIntoConstraints = false
        self.content.centerXAnchor.constraintEqualToAnchor(self.scrollView.centerXAnchor).active = true
        self.content.topAnchor.constraintEqualToAnchor(self.scrollView.topAnchor).active = true
        self.content.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
        if calcHeight.height > 80 {
            let height = Int(calcHeight.height)
            self.content.heightAnchor.constraintEqualToConstant(CGFloat(height) + 20).active = true
        }else{
            if self.imgList.count != 0 {
                self.content.heightAnchor.constraintEqualToConstant(100).active = true
                self.content.frame.size = CGSizeMake(self.scrollView.frame.width, 100)
            }else{
                self.content.heightAnchor.constraintEqualToAnchor(self.scrollView.heightAnchor).active = true
            }
        }
        
        var svHeight: CGFloat = 200
        
        var count:Int = 1
        if self.imgList.count != 0 {
            for img in self.imgList {
                if count == 1 {
                    self.imgView1.image = img
                }
                if count == 2 {
                    self.imgView2.image = img
                }
                if count == 3 {
                    self.imgView3.image = img
                }
                count += 1
            }
        }
        
        
        if self.imgList.count != 0 {
            withImage = "true"
            if self.imgList.count >= 1 {
                self.subView1.translatesAutoresizingMaskIntoConstraints = false
                self.subView1.topAnchor.constraintEqualToAnchor(self.content.bottomAnchor, constant: 10).active = true
                self.subView1.centerXAnchor.constraintEqualToAnchor(self.scrollView.centerXAnchor).active = true
                self.subView1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
                self.subView1.heightAnchor.constraintEqualToConstant(250).active = true
                
                self.imgView1.contentMode = .ScaleAspectFill
                self.imgView1.clipsToBounds = true
                self.subView1.addSubview(self.imgView1)
                self.imgView1.translatesAutoresizingMaskIntoConstraints = false
                self.imgView1.topAnchor.constraintEqualToAnchor(self.subView1.topAnchor, constant: 20).active = true
                self.imgView1.bottomAnchor.constraintEqualToAnchor(self.subView1.bottomAnchor, constant: -20).active = true
                self.imgView1.leftAnchor.constraintEqualToAnchor(self.subView1.leftAnchor, constant: 20).active = true
                self.imgView1.rightAnchor.constraintEqualToAnchor(self.subView1.rightAnchor, constant: -20).active = true
                
                self.btnRemove.setImage(UIImage(named: "remove"), forState: .Normal)
                self.subView1.addSubview(self.btnRemove)
                self.btnRemove.translatesAutoresizingMaskIntoConstraints = false
                self.btnRemove.topAnchor.constraintEqualToAnchor(self.subView1.topAnchor, constant: 10).active = true
                self.btnRemove.rightAnchor.constraintEqualToAnchor(self.subView1.rightAnchor, constant: -10).active = true
                self.btnRemove.widthAnchor.constraintEqualToConstant(30).active = true
                self.btnRemove.heightAnchor.constraintEqualToConstant(30).active = true
                self.btnRemove.contentMode = .ScaleToFill
                
                self.subView1.bringSubviewToFront(self.btnRemove)
                
                svHeight += 260
            }
            if self.imgList.count >= 2 {
                
                self.subView2.translatesAutoresizingMaskIntoConstraints = false
                self.subView2.topAnchor.constraintEqualToAnchor(self.imgView1.bottomAnchor, constant: 10).active = true
                self.subView2.centerXAnchor.constraintEqualToAnchor(self.scrollView.centerXAnchor).active = true
                self.subView2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
                self.subView2.heightAnchor.constraintEqualToConstant(250).active = true
                
                self.imgView2.contentMode = .ScaleAspectFill
                self.imgView2.clipsToBounds = true
                self.subView2.addSubview(self.imgView2)
                self.imgView2.translatesAutoresizingMaskIntoConstraints = false
                self.imgView2.topAnchor.constraintEqualToAnchor(self.subView2.topAnchor, constant: 20).active = true
                self.imgView2.bottomAnchor.constraintEqualToAnchor(self.subView2.bottomAnchor, constant: -20).active = true
                self.imgView2.leftAnchor.constraintEqualToAnchor(self.subView2.leftAnchor, constant: 20).active = true
                self.imgView2.rightAnchor.constraintEqualToAnchor(self.subView2.rightAnchor, constant: -20).active = true
                
                self.btnRemove2.setImage(UIImage(named: "remove"), forState: .Normal)
                self.subView2.addSubview(self.btnRemove2)
                self.btnRemove2.translatesAutoresizingMaskIntoConstraints = false
                self.btnRemove2.topAnchor.constraintEqualToAnchor(self.subView2.topAnchor, constant: 10).active = true
                self.btnRemove2.rightAnchor.constraintEqualToAnchor(self.subView2.rightAnchor, constant: -10).active = true
                self.btnRemove2.widthAnchor.constraintEqualToConstant(30).active = true
                self.btnRemove2.heightAnchor.constraintEqualToConstant(30).active = true
                self.btnRemove2.contentMode = .ScaleToFill
                
                self.subView2.bringSubviewToFront(self.btnRemove2)
                
                svHeight += 260
                
            }
            
            if self.imgList.count >= 3 {
                self.subView3.translatesAutoresizingMaskIntoConstraints = false
                self.subView3.topAnchor.constraintEqualToAnchor(self.imgView2.bottomAnchor, constant: 10).active = true
                self.subView3.centerXAnchor.constraintEqualToAnchor(self.scrollView.centerXAnchor).active = true
                self.subView3.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
                self.subView3.heightAnchor.constraintEqualToConstant(250).active = true
                
                self.imgView3.contentMode = .ScaleAspectFill
                self.imgView3.clipsToBounds = true
                self.subView3.addSubview(self.imgView3)
                self.imgView3.translatesAutoresizingMaskIntoConstraints = false
                self.imgView3.topAnchor.constraintEqualToAnchor(self.subView3.topAnchor, constant: 20).active = true
                self.imgView3.bottomAnchor.constraintEqualToAnchor(self.subView3.bottomAnchor, constant: -20).active = true
                self.imgView3.leftAnchor.constraintEqualToAnchor(self.subView3.leftAnchor, constant: 20).active = true
                self.imgView3.rightAnchor.constraintEqualToAnchor(self.subView3.rightAnchor, constant: -20).active = true
                
                self.btnRemove3.setImage(UIImage(named: "remove"), forState: .Normal)
                self.subView3.addSubview(self.btnRemove3)
                self.btnRemove3.translatesAutoresizingMaskIntoConstraints = false
                self.btnRemove3.topAnchor.constraintEqualToAnchor(self.subView3.topAnchor, constant: 10).active = true
                self.btnRemove3.rightAnchor.constraintEqualToAnchor(self.subView3.rightAnchor, constant: -10).active = true
                self.btnRemove3.widthAnchor.constraintEqualToConstant(30).active = true
                self.btnRemove3.heightAnchor.constraintEqualToConstant(30).active = true
                self.btnRemove3.contentMode = .ScaleToFill
                
                self.subView3.bringSubviewToFront(self.btnRemove3)
                
                svHeight += 260
                
            }
            
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width,height: svHeight)
        }
    }
    
    func removeImage1(){
        self.imgView1.image = nil
        reloadImageList()
    }
    
    func removeImage2(){
        self.imgView2.image = nil
        reloadImageList()
    }
    
    func removeImage3(){
        self.imgView3.image = nil
    }
    
    func reloadImageList(){
        self.imgList.removeAll()
        if imgView1.image != nil {
            self.imgList.append(imgView1.image!)
        }
        if imgView2.image != nil {
            self.imgList.append(imgView2.image!)
        }
        if imgView3.image != nil {
            self.imgList.append(imgView3.image!)
        }
        
        imgView1.image = nil
        imgView2.image = nil
        imgView3.image = nil
        
        loadTimelineImagePost()
    }
    
}