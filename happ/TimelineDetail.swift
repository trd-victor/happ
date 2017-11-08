//
//  TimelineDetail.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/13.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

struct UserDetails {
    static var user_id: String!
    static var username : String!
    static var userimageURL : String!
    static var postDate: String!
    static var fromID: String!
    static var body: String!
    static var img1: String!
    static var img2: String!
    static var img3: String!
    static var postID: String!
}

class TimelineDetail: UIViewController {

    let scrollView: UIScrollView = UIScrollView()
    var loadingScreen: UIView!
    
    let btnProfile: UIButton = {
        let btn = UIButton()
        btn.contentMode = .ScaleAspectFill
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        return btn
    }()
    
    let btnMessage: UIButton = {
        let btn = UIButton()
        btn.contentMode = .ScaleAspectFill
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        return btn
    }()
    
    let btnUsername: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel!.textColor = UIColor.blackColor()
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Selected)
        btn.setTitleColor(UIColor.blackColor(), forState: .Focused)
        btn.titleLabel!.font = UIFont.boldSystemFontOfSize(14)
        btn.contentHorizontalAlignment = .Left
        return btn
    }()
    
    let btnBack: UIButton = {
        let btn = UIButton()
        btn.contentMode = .ScaleAspectFill
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "Image"), forState: .Normal)
        return btn
    }()
    
    let postDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label
    }()
    
    let body: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(16)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let view1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    let imgView1: UIImageView = {
        let imgview = UIImageView()
        imgview.translatesAutoresizingMaskIntoConstraints = false
        imgview.contentMode = .ScaleAspectFill
        return imgview
    }()
   
    let view2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    let imgView2: UIImageView = {
        let imgview = UIImageView()
        imgview.translatesAutoresizingMaskIntoConstraints = false
        imgview.contentMode = .ScaleAspectFill
        return imgview
    }()
    
    let view3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        view.layer.shadowOpacity = 0.5
        return view
    }()
    
    let imgView3: UIImageView = {
        let imgview = UIImageView()
        imgview.translatesAutoresizingMaskIntoConstraints = false
        imgview.contentMode = .ScaleAspectFill
        return imgview
    }()
    
    let topView: UIView = UIView()
    
    var imgHeight1: CGFloat = 0
    var imgHeight2: CGFloat = 0
    var imgHeight3: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(topView)
        view.addSubview(btnBack)
        view.addSubview(btnProfile)
        view.addSubview(btnUsername)
        view.addSubview(postDate)
        view.addSubview(scrollView)
        view.addSubview(btnMessage)
        scrollView.addSubview(body)
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        scrollView.addSubview(view3)
        view1.addSubview(imgView1)
        view2.addSubview(imgView2)
        view3.addSubview(imgView3)
        
         self.startLayout()
        
        btnBack.addTarget(self, action: "backTimeline:", forControlEvents: .TouchUpInside)
        
        btnUsername.setTitle(UserDetails.username, forState: .Normal)
        btnUsername.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
        btnUsername.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        
        let imgView = UIImageView()
        
        
        if UserDetails.userimageURL == "null" {
            imgView.image = UIImage(named: "noPhoto")
            self.btnProfile.setImage(imgView.image, forState: .Normal)
        }else {
            if (globalvar.imgforProfileCache.objectForKey(UserDetails.userimageURL) != nil) {
                let imgCache = globalvar.imgforProfileCache.objectForKey(UserDetails.userimageURL) as! UIImage
                btnProfile.setImage(imgCache, forState: .Normal)
            }else{
                self.btnProfile.setImage(UIImage(named : "noPhoto"), forState: .Normal)
                self.btnProfile.backgroundColor = UIColor.lightGrayColor()
                self.btnProfile.contentMode = .Center
                let url = NSURL(string: UserDetails.userimageURL.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                    if let data = NSData(contentsOfURL: url!){
                        dispatch_async(dispatch_get_main_queue()){
                            self.btnProfile.setImage(UIImage(data: data), forState: .Normal)
                            self.btnProfile.contentMode = .ScaleAspectFill
                        }
                        let tmpImg = UIImage(data: data)
                        globalvar.imgforProfileCache.setObject(tmpImg!, forKey: UserDetails.userimageURL)
                    }
                })
                task.resume()
            }
        }
        
        if UserDetails.userimageURL == "null" {
            imgView.image = UIImage(named: "noPhoto")
             btnProfile.setImage(imgView.image, forState: .Normal)
        }else {
            imgView.profileForCache(UserDetails.userimageURL)
             btnProfile.setImage(imgView.image, forState: .Normal)
        }
        
        if UserDetails.fromID == globalUserId.userID {
            self.btnMessage.hidden = true
        }else{
            self.btnMessage.hidden = false
        }
        
        btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
        
        if UserDetails.postID == nil || UserDetails.postID == ""{
            btnUsername.tag = Int(UserDetails.fromID)!
            btnProfile.tag = Int(UserDetails.fromID)!
            postDate.text = self.dateTransform(UserDetails.postDate)
            
            self.body.text = UserDetails.body.stringByDecodingHTMLEntities
            self.postDetail()
        }else{
            self.getDetail()
        }
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeBackTimeline:");
        swipeRight.direction = .Right
        
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    
    func postDetail(){
        var contentHeight: CGFloat = 0
        
        
        if UserDetails.img1 != "null" {
            self.imgView1.imgForCache(UserDetails.img1)
            dispatch_async(dispatch_get_main_queue()){
                self.imgViewHeight(self.imgView1,swtchCase: 1)
            }
        }else{
            self.view1.hidden = true
        }
        if UserDetails.img2 != "null" {
            imgView2.imgForCache(UserDetails.img2)
            dispatch_async(dispatch_get_main_queue()){
                self.imgViewHeight(self.imgView2,swtchCase: 2)
            }
        }else{
            self.view2.hidden = true
        }
        
        if UserDetails.img3 != "null" {
            imgView3.imgForCache(UserDetails.img3)
            dispatch_async(dispatch_get_main_queue()){
                self.imgViewHeight(self.imgView3,swtchCase: 3)
            }
        }else{
            self.view3.hidden = true
        }
        dispatch_async(dispatch_get_main_queue()){
            contentHeight += self.body.frame.size.height
            contentHeight += self.imgHeight1
            contentHeight += self.imgHeight2
            contentHeight += self.imgHeight3
//            self.scrollView.contentSize = CGSizeMake(self.view.frame.width,contentHeight + 400)
            self.autoLayout()
        }
    }
    
    func getDetail(){
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        let baseUrl: NSURL = globalvar.API_URL
        let parameters = [
                    "sercret"     : "jo8nefamehisd",
                    "action"      : "api",
                    "ac"          : "get_timeline",
                    "d"           : "0",
                    "lang"        : "en",
                    "user_id"     : "\(globalUserId.userID)",
                    "post_id"     : "\(UserDetails.postID)",
                    "count"       : "1"
                ]
                let request = NSMutableURLRequest(URL: baseUrl)
                let boundary = generateBoundaryString()
                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.HTTPMethod = "POST"
                request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                    data, response, error  in
                    
                    if error != nil || data == nil{
                        self.getDetail()
                    }else {
                        do {
                            if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                                let config = SYSTEM_CONFIG()
                                dispatch_async(dispatch_get_main_queue()){
                                    if json["success"] != nil {
                                        if let resultArray = json.valueForKey("result") as? NSArray {
                                            if resultArray.count != 0 {
                                                
                                                UserDetails.postDate = resultArray[0]["post_modified"] as! String
                                                UserDetails.fromID = resultArray[0]["fields"]!!["from_user_id"]!! as! String
                                                UserDetails.body = resultArray[0]["fields"]!!["body"]!! as! String
                                                
                                                self.btnUsername.tag = Int(UserDetails.fromID)!
                                                self.btnProfile.tag = Int(UserDetails.fromID)!
                                                self.postDate.text = self.dateTransform(UserDetails.postDate)
                                                
                                                self.body.text = UserDetails.body.stringByDecodingHTMLEntities
                                                
                                                dispatch_async(dispatch_get_main_queue()){
                                                    if resultArray[0]["fields"]!!["images"] as? NSArray  != nil {
                                                        let images = resultArray[0]["fields"]!!["images"] as! NSArray
                                                        
                                                        if images.count == 3 {
                                                            UserDetails.img1 = images[0]["image"]!!["url"] as! String
                                                            UserDetails.img2 = images[1]["image"]!!["url"] as! String
                                                            UserDetails.img3 = images[2]["image"]!!["url"] as! String
                                                        }else if images.count == 2 {
                                                            UserDetails.img1 = images[0]["image"]!!["url"] as! String
                                                            UserDetails.img2 = images[1]["image"]!!["url"] as! String
                                                            UserDetails.img3 = "null"
                                                        }else if images.count == 1 {
                                                            UserDetails.img1 = images[0]["image"]!!["url"] as! String
                                                            UserDetails.img2 = "null"
                                                            UserDetails.img3 = "null"
                                                        }
                                                    }else{
                                                        UserDetails.img1 = "null"
                                                        UserDetails.img2 = "null"
                                                        UserDetails.img3 = "null"
                                                    }
                                                    
                                                    UserDetails.postID = ""
                                                    self.postDetail()
                                                }
                                                
                                                if self.loadingScreen != nil {
                                                    UIViewController.removeSpinner(self.loadingScreen)
                                                    self.loadingScreen = nil
                                                }
                                            }else{
                                                self.displayMyAlertMessage(config.translate("already_deleted_post_mess"))
                                            }
                                            
                                        }else{
                                            self.displayMyAlertMessage(config.translate("already_deleted_post_mess"))
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
    
    func displayMyAlertMessage(userMessage:String){
        if self.loadingScreen != nil {
            UIViewController.removeSpinner(self.loadingScreen)
            self.loadingScreen = nil
        }
       let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            let transition = CATransition()
            transition.duration = 0.40
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
            self.dismissViewControllerAnimated(false, completion: nil)
        }))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func dateTransform(date: String) -> String {
        var dateArr = date.characters.split{$0 == " "}.map(String.init)
        var timeArr = dateArr[1].characters.split{$0 == ":"}.map(String.init)
        let config = SYSTEM_CONFIG()
        let lang = config.getSYS_VAL("AppLanguage") as! String
        
        var date:String = ""
        if dateArr.count >= 0 {
            if lang != "en" {
                dateArr = dateArr[0].characters.split{$0 == "-"}.map(String.init)
                date = "\(dateArr[0])年\(dateArr[1])月\(dateArr[2])日 \(timeArr[0]):\(timeArr[1])"
            }else{
                date = "\(dateArr[0]) \(timeArr[0]):\(timeArr[1])"
            }
        }
        return date
    }
    
    
    func imgViewHeight(imgview: UIImageView, swtchCase: Int) {
        let width: CGFloat = view.bounds.width
        let imgWidth: CGFloat = (imgview.image?.size.width)!
        let widthRatio: CGFloat = width / imgWidth
        let newHeight: CGFloat = ((imgview.image?.size.height)! * widthRatio) - 4
        
        switch(swtchCase){
        case 1:
            imgHeight1 = newHeight
            break
        case 2:
            imgHeight2 = newHeight
            break
        default:
            imgHeight3 = newHeight
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startLayout(){
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 28).active = true
        topView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        topView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        topView.heightAnchor.constraintEqualToConstant(50).active = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraintEqualToAnchor(topView.bottomAnchor).active = true
        scrollView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        scrollView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        scrollView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        btnBack.leftAnchor.constraintEqualToAnchor(topView.leftAnchor, constant: 8).active = true
        btnBack.centerYAnchor.constraintEqualToAnchor(topView.centerYAnchor).active = true
        btnBack.widthAnchor.constraintEqualToConstant(30).active = true
        btnBack.heightAnchor.constraintEqualToConstant(30).active = true
        
        btnProfile.leftAnchor.constraintEqualToAnchor(btnBack.rightAnchor, constant: 8).active = true
        btnProfile.centerYAnchor.constraintEqualToAnchor(topView.centerYAnchor).active = true
        btnProfile.widthAnchor.constraintEqualToConstant(40).active = true
        btnProfile.heightAnchor.constraintEqualToConstant(40).active = true
        
        btnUsername.topAnchor.constraintEqualToAnchor(topView.topAnchor, constant: 5).active = true
        btnUsername.leftAnchor.constraintEqualToAnchor(btnProfile.rightAnchor, constant: 7).active = true
        btnUsername.widthAnchor.constraintEqualToConstant(150).active = true
        btnUsername.heightAnchor.constraintEqualToConstant(20).active = true
        
        postDate.topAnchor.constraintEqualToAnchor(btnUsername.bottomAnchor,constant: 2).active = true
        postDate.leftAnchor.constraintEqualToAnchor(btnProfile.rightAnchor, constant: 7).active = true
        postDate.widthAnchor.constraintEqualToConstant(150).active =  true
        
        body.topAnchor.constraintEqualToAnchor(scrollView.topAnchor, constant: 15).active = true
        body.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        body.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
    }
    
    func autoLayout(){
        let config = SYSTEM_CONFIG()
        
        view1.topAnchor.constraintEqualToAnchor(body.bottomAnchor,constant: 25).active = true
        view1.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        view1.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        view1.heightAnchor.constraintEqualToConstant(imgHeight1 + 2).active = true
        
        imgView1.topAnchor.constraintEqualToAnchor(view1.topAnchor).active = true
        imgView1.centerXAnchor.constraintEqualToAnchor(view1.centerXAnchor).active = true
        imgView1.widthAnchor.constraintEqualToAnchor(view1.widthAnchor).active = true
        imgView1.heightAnchor.constraintEqualToAnchor(view1.heightAnchor, constant: -2).active = true
        
        view2.topAnchor.constraintEqualToAnchor(view1.bottomAnchor,constant: 15).active = true
        view2.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        view2.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        view2.heightAnchor.constraintEqualToConstant(imgHeight2).active = true
        
        imgView2.topAnchor.constraintEqualToAnchor(view2.topAnchor).active = true
        imgView2.centerXAnchor.constraintEqualToAnchor(view2.centerXAnchor).active = true
        imgView2.widthAnchor.constraintEqualToAnchor(view2.widthAnchor).active = true
        imgView2.heightAnchor.constraintEqualToAnchor(view2.heightAnchor).active = true
        
        view3.topAnchor.constraintEqualToAnchor(view2.bottomAnchor,constant: 15).active = true
        view3.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        view3.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        view3.heightAnchor.constraintEqualToConstant(imgHeight3).active = true
        
        imgView3.topAnchor.constraintEqualToAnchor(view3.topAnchor).active = true
        imgView3.centerXAnchor.constraintEqualToAnchor(view3.centerXAnchor).active = true
        imgView3.widthAnchor.constraintEqualToAnchor(view3.widthAnchor).active = true
        imgView3.heightAnchor.constraintEqualToAnchor(view3.heightAnchor).active = true
        
        btnMessage.topAnchor.constraintEqualToAnchor(view3.bottomAnchor, constant: 20).active = true
        btnMessage.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnMessage.heightAnchor.constraintEqualToConstant(44).active = true
        btnMessage.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, multiplier: 1/2, constant: -30).active = true
        btnMessage.setImage(UIImage(named: "msg"), forState: .Normal)
        btnMessage.backgroundColor = UIColor(hexString: "#272727")
        btnMessage.setTitle(config.translate("menu_message"), forState: .Normal)
        btnMessage.addTarget(self, action: Selector("goToMessage"), forControlEvents: .TouchUpInside)
        
        self.view.layoutIfNeeded()
        
        let last_origin_y: CGFloat = btnMessage.frame.origin.y
        let last_height: CGFloat = btnMessage.frame.size.height
        
        let contentSize = last_origin_y + last_height
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentSize + 100)
    }
    
    func goToMessage(){
        let user_id = Int(UserDetails.fromID)
        let userdb = FIRDatabase.database().reference().child("users").queryOrderedByChild("id").queryEqualToValue(user_id)
        
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        userdb.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let userData = snapshot.value as? NSDictionary
            
            if(userData != nil) {
                for (key, value) in userData! {
                    if let dataVal = value as? NSDictionary {
                        if let dataID =  dataVal["id"] as? Int {
                           
                            if dataID == user_id {
                                chatVar.chatmateId = key as! String
                                chatVar.Indicator = "Search"
                                
                                if let name = globalvar.USER_IMG.valueForKey(chatVar.chatmateId)?.valueForKey("name") as? String{
                                    chatVar.name = name
                                }
                                
                                if self.loadingScreen != nil {
                                    UIViewController.removeSpinner(self.loadingScreen)
                                    self.loadingScreen = nil
                                }
                                
                                dispatch_async(dispatch_get_main_queue()){
                                    let vc = ViewLibViewController()
                                    
                                    let transition = CATransition()
                                    transition.duration = 0.40
                                    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                                    transition.type = kCATransitionPush
                                    transition.subtype = kCATransitionFromRight
                                    self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
                                    self.presentViewController(vc, animated: false, completion: nil)
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func viewProfile(sender: UIButton!){
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("UserProfile") as! UserProfileController
        let transition = CATransition()
        
        UserProfile.id = String(sender.tag)
        
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        presentViewController(vc, animated: false, completion: nil)
    }
    
    func backTimeline(sender: UIButton!){
        let transition: CATransition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
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
    
    private func calcTextHeight(text: String, frame: CGSize, fontsize: CGFloat) -> CGRect{
        let size = CGSize(width: frame.width - 50, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(fontsize)], context: nil)
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
    
}


class TimelineImage: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingString(urlString: String, completion: (result: Bool) -> Void){
                self.imageUrlString = urlString
        
        let urlStr = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlData = NSURL(string: urlStr)
        
        self.image = nil
        self.backgroundColor = UIColor.lightGrayColor()
        
        if let imgFromCache = imgCache.objectForKey(urlString) as? UIImage{
            self.image = imgFromCache
            completion(result: true)
            return
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(urlData!, completionHandler: {(data, responses, error) in
            
            if error != nil {
                print(error?.localizedDescription)
                completion(result: false)
            }
            
            if data != nil {
                let imageToCache = UIImage(data: data!)
                if imageToCache != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        () -> Void in
                        imgCache.setObject(imageToCache!, forKey: urlString)
                        dispatch_async(dispatch_get_main_queue()){
                            if self.imageUrlString! == urlString {
                                self.image = imageToCache
                                completion(result: true)
                            }
                        }
                    })
                }
                
            }
        }).resume()
    }

}


class TimelineProfileImage: UIButton {
    
    var imageUrlString: String?
    
    func loadImageUsingString(urlString: String, completion: (result: Bool) -> Void){
        
        if (globalvar.imgforProfileCache.objectForKey(urlString) != nil) {
            let imgCache = globalvar.imgforProfileCache.objectForKey(urlString) as! UIImage
            self.setImage(imgCache, forState: .Normal)
            completion(result: true)
        }else{
            self.setImage(UIImage(named : "noPhoto"), forState: .Normal)
            self.backgroundColor = UIColor.lightGrayColor()
            self.contentMode = .Center
            let url = NSURL(string: urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                if let data = NSData(contentsOfURL: url!){
                    dispatch_async(dispatch_get_main_queue()){
                        self.setImage(UIImage(data: data), forState: .Normal)
                        self.contentMode = .ScaleAspectFill
                        self.backgroundColor = UIColor.clearColor()
                    }
                    let tmpImg = UIImage(data: data)
                    globalvar.imgforProfileCache.setObject(tmpImg!, forKey: urlString)
                    completion(result: true)
                }
            })
            task.resume()
        }
    
    
    }
    
}

