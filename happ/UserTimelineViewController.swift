//
//  UserTimelineViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 21/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

struct statusButton {
    static var status : String = ""
    static var freetimeStatus: UISwitch!
}

class UserTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var topView: UIView!
    @IBOutlet var btnViewNotif: UIBarButtonItem!
    
    @IBOutlet var labelFree: UILabel!
    @IBOutlet var mytableview: UITableView!
    let cellSpacingHeight: CGFloat = 5
    
    @IBOutlet var timeline: UILabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var reservation: UILabel!
    @IBOutlet var situation: UILabel!
    @IBOutlet var configuration: UILabel!
    @IBOutlet var btndelete: UIButton!
    
    @IBOutlet var freetimeStatus: UISwitch!
    
    var pageCount : String!
    
    var userData: NSDictionary!
    var countData: NSArray = []
    var loadingScreen: UIView!
    
    //get user Id...
    var userId: String = ""
    
    //get anyobject
    var dataResult: AnyObject?
    
    //basepath
    let baseUrl: NSURL = globalvar.API_URL
    
    var image1 = [UIImageView]()
    
    //variable for Timeline
    var img1 = [String]()
    var img2 = [String]()
    var img3 = [String]()
    var userBody = [String]()
    var fromID = [String]()
    var postID = [Int]()
    var IDuser = [String]()
    var nameArr = [String]()
    var userSkills: [String] = []
    var postDate = [String]()
    var username = [String]()
    var userImage: String!
    var imgURL: String!
    var data: NSData!
    var language: String!
    var userpostID: String!
    var msgDelete: String!
    var varResult: Int = 0
    var indexInt: Int!
    var myResultArr: NSArray?
    var heightPath =  NSMutableDictionary()
    var userInfoID = [String]()
    var groups = [[String]]()
    var realId: String = ""
    var realUsername = [String]()
    var testName : String!
    var userEachImage = [String]()
    var realImage = [String]()
    var urlImage : String!
    
    var scrollview : UIScrollView!
    
    var roundButton = UIButton()
    var myTimer: NSTimer!
    
    var scrollLoad:Bool = false
    var firstLoad: Bool = false
    var toReloadTimeline: NSURLSessionDataTask!
    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    let btmRefresh: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.color = UIColor.grayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var noData: Bool = false
    
    var page:Int = 1
    var userProfile = NSCache()
    
    var skills = String()
    
    @IBOutlet var searchIcon: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("refreshLang:")), name: "refreshUserTimeline", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("notifTimeline:")), name: "reloadTimeline", object: nil)
        
        self.mytableview.addSubview(self.refreshControl)
        
        statusButton.freetimeStatus = freetimeStatus
        
        self.mytableview.registerClass(NoImage.self, forCellReuseIdentifier: "NoImage")
        self.mytableview.registerClass(SingleImage.self, forCellReuseIdentifier: "SingleImage")
        self.mytableview.registerClass(DoubleImage.self, forCellReuseIdentifier: "DoubleImage")
        self.mytableview.registerClass(TripleImage.self, forCellReuseIdentifier: "TripleImage")
        
        self.mytableview.backgroundColor = UIColor(hexString: "#E4D4B9")
        self.mytableview.separatorStyle = UITableViewCellSeparatorStyle.None
        self.mytableview.contentInset = UIEdgeInsetsMake(10, 0, 30, 0)
        
        language = setLanguage.appLanguage
        
        let config = SYSTEM_CONFIG()
        
        userId = globalUserId.userID
        globalUserId.skills = String(config.getSYS_VAL("user_skills_\(globalUserId.userID)")!)
        self.getTimelineUser()
        
        //set text i am free
        labelFree.text = config.translate("subtitle_now_free")
        
        // self.searchIcon.action = Selector("gotoSearchbar:")
        
        self.roundButton = UIButton(type: UIButtonType.Custom)
        self.roundButton.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        self.roundButton.addTarget(self, action: "CreatePostButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(roundButton)
        
        mytableview.addSubview(btmRefresh)
        
        self.scrollview = UIScrollView()
        self.scrollview.delegate = self
        self.scrollview.contentSize = CGSizeMake(1000, 1000)
        view.addSubview(scrollview)
        
        //set switch on
        autoLayout()
        
        self.mytableview.delegate = self
        self.mytableview.dataSource = self
        
        self.bellObserver()
        
        self.getFreeTimeStatus()
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: Selector("updateFunction"), userInfo: nil, repeats: true)
    }
    
    func updateFunction(){
        self.getFreeTimeStatus()
    }
    
    func bellObserver(){
        let firID = FIRAuth.auth()?.currentUser?.uid
        let unreadDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(firID!).child("unread")
        unreadDB.observeEventType(.Value, withBlock: {(snap) in
            if let result = snap.value as? NSDictionary {
                if let count = result["count"] as? Int {
                    if count == 0 {
                        self.btnViewNotif.removeBadge()
                        globalvar.badgeBellNumber = 0
                    }else{
                        self.btnViewNotif.removeBadge()
                        self.btnViewNotif.addBadge(number: count)
                        globalvar.badgeBellNumber = count
                    }
                    UIApplication.sharedApplication().applicationIconBadgeNumber = globalvar.badgeBellNumber + globalvar.badgeMessNumber
                }
            }
        })
    }
    
    @IBAction func searchIcon(sender: AnyObject) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("SearchUserController") as! SearchController
        self.presentDetail(vc)
    }
    
    func refreshLang(notification: NSNotification) {
        let config = SYSTEM_CONFIG()
        self.labelFree.text = config.translate("subtitle_now_free")
        mytableview.reloadData()
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        navBar.tintColor = UIColor.blackColor()
        
        topImage.translatesAutoresizingMaskIntoConstraints = false
        topImage.centerXAnchor.constraintEqualToAnchor(navBar.centerXAnchor).active = true
        topImage.topAnchor.constraintEqualToAnchor(navBar.topAnchor, constant: 4).active = true
        topImage.widthAnchor.constraintEqualToConstant(84).active = true
        topImage.heightAnchor.constraintEqualToConstant(33).active = true
        
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        topView.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        topView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        topView.heightAnchor.constraintEqualToConstant(43).active = true
        
        labelFree.translatesAutoresizingMaskIntoConstraints = false
        labelFree.centerXAnchor.constraintEqualToAnchor(topView.centerXAnchor).active = true
        labelFree.topAnchor.constraintEqualToAnchor(topView.topAnchor, constant: 6).active = true
        labelFree.widthAnchor.constraintEqualToAnchor(topView.widthAnchor, constant: -20).active = true
        labelFree.heightAnchor.constraintEqualToConstant(31).active = true
        
        freetimeStatus.translatesAutoresizingMaskIntoConstraints = false
        freetimeStatus.frame.size = CGSizeMake(51, 31)
        freetimeStatus.topAnchor.constraintEqualToAnchor(topView.topAnchor, constant: 6).active = true
        freetimeStatus.rightAnchor.constraintEqualToAnchor(topView.rightAnchor, constant: -10).active = true
        
        mytableview.translatesAutoresizingMaskIntoConstraints = false
        mytableview.topAnchor.constraintEqualToAnchor(topView.bottomAnchor).active = true
        mytableview.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mytableview.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        mytableview.heightAnchor.constraintEqualToAnchor(view.heightAnchor, constant: -110).active = true
        
        btmRefresh.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btmRefresh.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        btmRefresh.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        btmRefresh.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    override func viewWillLayoutSubviews() {
        
        roundButton.layer.cornerRadius = roundButton.layer.frame.size.width/2
        roundButton.layer.shadowColor = UIColor.blackColor().CGColor
        roundButton.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        roundButton.layer.shadowOpacity = 0.5;
        roundButton.clipsToBounds = true
        roundButton.setImage(UIImage(named:"newpost"), forState: .Normal)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activateConstraints([
            roundButton.trailingAnchor.constraintEqualToAnchor(self.view.trailingAnchor, constant: -3),
            roundButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant:  -10),
            roundButton.widthAnchor.constraintEqualToConstant(80),
            roundButton.heightAnchor.constraintEqualToConstant(80)
            ])
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if menu_bar.reloadScreen != nil {
            UIViewController.removeSpinner(menu_bar.reloadScreen)
            menu_bar.reloadScreen = nil
        }
        
        if self.loadingScreen != nil {
            UIViewController.removeSpinner(self.loadingScreen)
            self.loadingScreen = nil
        }
    }
    
    func refreshTimelineTable() {
        self.mytableview.reloadData()
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func CreatePostButton (sender: UIButton) ->() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("CreatePostController") as! CreatePostViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func deletePost(sender: String, index: Int) {
        let config = SYSTEM_CONFIG()
        self.deleteAlertMessage(config.translate("mess_discard_post"))
        self.userpostID = sender
        self.indexInt = index
        
    }
    
    func deleteTimeline(sender: String) {
        let request1 = NSMutableURLRequest(URL: self.baseUrl)
        let boundary1 = generateBoundaryString()
        request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
        request1.HTTPMethod = "POST"
        
        let param = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "delete_timeline",
            "d"           : "0",
            "lang"        : "en",
            "pid"         : "\(sender)"
        ]
        
        request1.HTTPBody = createBodyWithParameters(param, boundary: boundary1)
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1){
            data1, response1, error1 in
            
            if error1 != nil || data1 == nil {
                self.deleteTimeline(sender)
            }else {
                do {
                    if let json3 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if json3["message"] != nil {
                        
                        }
                        
                        if let result = json3["result"] as? NSDictionary {
                            if result["mess"] != nil {
                                
                            }
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            //self.displayMyAlertMessage(mess)
                            self.mytableview.reloadData()
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task2.resume()
        
    }
    
    
    
    @IBAction func freetimeStatus(sender: UISwitch) {
        let statust = switchButtonCheck(freetimeStatus)
        
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        if loadingScreen == nil {
            loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        if statust == "On" {
            updateFreeTimeStatus()
        }else{
            freeTimeStatusOff()
        }
    }
    
    
    func getFreeTimeStatus(){
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        let parameters = [
            "sercret"          : globalvar.secretKey,
            "action"           : "api",
            "ac"               : "get_freetime_status_for_me",
            "d"                : "0",
            "lang"             : "jp",
            "user_id"          : "\(globalUserId.userID)",
            "office_id"        : "32",
            "status_key"       : "freetime"
        ]
        
        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil{
                self.getFreeTimeStatus()
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        dispatch_async(dispatch_get_main_queue()){
                            if let _ = json["success"] as? Bool {
                                if let result = json["result"] as? NSArray {
                                    var check = false
                                    var count = 0
                                    if result.count > 0 {
                                        for(value) in result {
                                            count++
                                            if let field = value["fields"] as? NSDictionary {
                                                if let userid = field["user_id"] as? String {
                                                    if userid == globalUserId.userID {
                                                        check = true
                                                    }
                                                }
                                            }
                                            
                                            if count == result.count{
                                                if check {
                                                    self.freetimeStatus.setOn(true, animated: true)
                                                }else{
                                                    self.freetimeStatus.setOn(false, animated: true)
                                                }
                                            }
                                        }
                                    }else{
                                        self.freetimeStatus.setOn(false, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }catch{
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func btnViewNotif(sender: UIBarButtonItem) {
        let firID = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(firID!).child("unread").child("count").setValue(0)
        
        self.btnViewNotif.removeBadge()
        
        let notfif = NotifController()
        self.presentDetail(notfif)
    }
    
    func getOlderPostTimeline() {
        
        self.page += 1
        
        let parameters = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "get_timeline",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(globalUserId.userID)",
            "from_id"     : "\(globalUserId.userID)",
            "page"        : "\(page)",
            "count"       : "5",
            "skills"     : "\(globalUserId.skills)",
            "origin"     : "timeline"
        ]
        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil{
                self.getOlderPostTimeline()
            }else {
                
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if let resultArray = json.valueForKey("result") as? NSArray {
                            let config = SYSTEM_CONFIG()
                            if resultArray.count == 0 {
                                self.noData = true
                                self.btmRefresh.stopAnimating()
                            }
                            
                            for item in resultArray {
                                if let resultDict = item as? NSDictionary {
                                    if let postContent = resultDict.valueForKey("fields")  {
                                        
                                        if let from_user_id = postContent.valueForKey("from_user_id") as? String{
                                            if let _ = config.getSYS_VAL("username_\(from_user_id)") as? String {
                                                
                                                if let userPostId = resultDict.valueForKey("ID") {
                                                    self.postID.append(userPostId as! Int)
                                                }
                                                
                                                if let userPostModied = resultDict.valueForKey("post_modified") {
                                                    self.postDate.append(userPostModied as! String)
                                                }
                                                
                                                if postContent["images"] != nil {
                                                    if let images = postContent.valueForKey("images") as? NSArray {
                                                        for index in 1...images.count {
                                                            if let img = images[index - 1].valueForKey("image"){
                                                                if index == 1 {
                                                                    self.img1.append(img["url"] as! String)
                                                                }
                                                                if index == 2 {
                                                                    self.img2.append(img["url"] as! String)
                                                                }
                                                                if index == 3 {
                                                                    self.img3.append(img["url"] as! String)
                                                                }
                                                            }
                                                        }
                                                        if images.count < 2 {
                                                            self.img2.append("null")
                                                        }
                                                        if images.count < 3 {
                                                            self.img3.append("null")
                                                        }
                                                    }else{
                                                        self.img1.append("null")
                                                        self.img2.append("null")
                                                        self.img3.append("null")
                                                    }
                                                }
                                                if let body = postContent.valueForKey("body") {
                                                    if let textStr = body as? String {
                                                        self.userBody.append(textStr.stringByDecodingHTMLEntities)
                                                    }
                                                }
                                                if let body = postContent.valueForKey("from_user_id") {
                                                    self.fromID.append(body as! String)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        if self.loadingData {
                            self.loadingData = false
                        }
                        self.btmRefresh.stopAnimating()
                        self.mytableview.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnViewNotif.tintColor = UIColor.whiteColor()
        
        if !self.firstLoad {
            self.mytableview.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height)
            
            self.refreshControl.beginRefreshing()
            self.firstLoad = true
        }
    }
    
    func updateTimeline(){
        
        if let willReload = menu_bar.timelineReloadCount {
            if willReload {
                if self.fromID.count > 0 {
                    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
                    
                    if(self.mytableview.numberOfSections > 0){
                        self.mytableview.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
                    }
                }
                
                if self.loadingScreen == nil {
                    self.loadingScreen = UIViewController.displaySpinner(self.view)
                }
                
                self.reloadTimelineByMenuClick()
                menu_bar.timelineReloadCount = false
            }
        }
    }
    
    func getTimelineUser() {
        
        let parameters = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "get_timeline",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(globalUserId.userID)",
            "from_id"     : "\(globalUserId.userID)",
            "page"        : "\(page)",
            "count"       : "5",
            "skills"     : "\(globalUserId.skills)",
            "origin"      : "timeline"
        ]
        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil && data == nil {
                self.getTimelineUser()
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if let resultArray = json.valueForKey("result") as? NSArray {
                            
                            self.myResultArr = resultArray
                            for item in resultArray {
                                if let resultDict = item as? NSDictionary {
                                    if let postContent = resultDict.valueForKey("fields")  {
                                        if let userPostId = resultDict.valueForKey("ID") {
                                            self.postID.append(userPostId as! Int)
                                        }
                                        
                                        if let userPostModied = resultDict.valueForKey("post_modified") {
                                            self.postDate.append(userPostModied as! String)
                                        }
                                        
                                        if postContent["images"] != nil {
                                            if let images = postContent.valueForKey("images") as? NSArray {
                                                for index in 1...images.count {
                                                    if let img = images[index - 1].valueForKey("image"){
                                                        let imgView = UIImageView()
                                                        if index == 1 {
                                                            self.img1.append(img["url"] as! String)
//                                                            imgView.imgForCache(img["url"] as! String)
                                                            self.image1.append(imgView)
                                                        }
                                                        if index == 2 {
                                                            self.img2.append(img["url"] as! String)
                                                        }
                                                        if index == 3 {
                                                            self.img3.append(img["url"] as! String)
                                                        }
                                                    }
                                                }
                                                if images.count < 2 {
                                                    self.img2.append("null")
                                                }
                                                if images.count < 3 {
                                                    self.img3.append("null")
                                                }
                                            }else{
                                                self.img1.append("null")
                                                self.img2.append("null")
                                                self.img3.append("null")
                                            }
                                        }
                                        if let body = postContent.valueForKey("body") {
                                            if let textStr = body as? String {
                                                self.userBody.append(textStr.stringByDecodingHTMLEntities)
                                            }
                                        }
                                        if let id = postContent.valueForKey("from_user_id") {
                                            self.fromID.append(id as! String)
                                        }
                                    }
                                }
                                
                            }
                        }
                        dispatch_async(dispatch_get_main_queue()){
                            if self.refreshControl.refreshing {
                                self.refreshControl.endRefreshing()
                                self.mytableview.contentOffset = CGPoint(x: 0,y: 0)
                            }
                            self.mytableview.reloadData()
                            
                            let uid = FIRAuth.auth()?.currentUser?.uid
                            FIRDatabase.database().reference().child("user-badge").child("timeline").child(uid!).setValue(0)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func convertSpecialCharacters(string: String) -> String {
        var newString = string
        let char_dictionary = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'"
        ];
        for (escaped_char, unescaped_char) in char_dictionary {
            newString = newString.stringByReplacingOccurrencesOfString(escaped_char, withString: unescaped_char, options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        }
        return newString
    }
    
    func refreshTable() {
        self.userBody.removeAll()
        self.postDate.removeAll()
        self.postID.removeAll()
        self.fromID.removeAll()
        self.username.removeAll()
        self.realImage.removeAll()
        self.getTimelineUser()
    }
    
    var scrollOffset: CGFloat = 0
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollOffset = scrollView.contentOffset.y
        if scrollView == self.mytableview {
            if scrollView.contentOffset.y < -80 && self.scrollLoad == false {
                reloadTableData()
            }
        }
    }
    
    func reloadTableData(){
        refreshControl.beginRefreshing()
        self.page = 1
        self.scrollLoad = true
        self.reloadTimeline()
    }
    
    func notifTimeline(notification: NSNotification){
        self.page = 1
        
        if (self.postID.count != 0){
            mytableview.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
        }
        
        refreshControl.beginRefreshing()
        self.reloadTimeline()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fromID.count
    }
    
    let imgforPostCache = NSCache()
    let imgforProfileCache = NSCache()
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let config = SYSTEM_CONFIG()
        var username = ""
        var userimageURL = ""
        
        if let name = config.getSYS_VAL("username_\(self.fromID[indexPath.row])") as? String {
            username = name
        }
        
        if let imageURL = config.getSYS_VAL("userimage_\(self.fromID[indexPath.row])") as? String {
            userimageURL = imageURL
        }
        
        let cellTap = UITapGestureRecognizer(target: self, action: "tapCell:")
        let bodyTap = UITapGestureRecognizer(target: self, action: "tapBody:")
        let imgTap = UITapGestureRecognizer(target: self, action: "tapImage:")
        if self.img3[indexPath.row] != "null" {
            let cell = tableView.dequeueReusableCellWithIdentifier("TripleImage", forIndexPath: indexPath) as! TripleImage
            
            cell.contentView.addGestureRecognizer(cellTap)
            
            let imgView = UIImageView()
            
            cell.btnUsername.setTitle(username, forState: .Normal)
            cell.btnUsername.titleLabel?.lineBreakMode = .ByTruncatingTail
            cell.btnUsername.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            cell.btnUsername.tag = Int(self.fromID[indexPath.row])!
            cell.detailTextLabel?.addGestureRecognizer(bodyTap)
            cell.detailTextLabel?.text = String(self.userBody[indexPath.row])
            
            if userimageURL == "null" || userimageURL == ""{
                imgView.image = UIImage(named: "noPhoto")
                cell.btnProfile.setImage(imgView.image, forState: .Normal)
            }else {
                cell.btnProfile.loadImageUsingString(userimageURL, completion: {(result: Bool) in
                    
                })
            }
            
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.profileImg.tag = Int(self.fromID[indexPath.row])!
            cell.postDate.text =  dateTransform(self.postDate[indexPath.row])
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            
            cell.indicator.startAnimating()
            cell.imgView1.loadImageUsingString(self.img1[indexPath.row]){
                (result: Bool) in
                cell.indicator.stopAnimating()
            }
            
            cell.indicator2.startAnimating()
            cell.imgView2.loadImageUsingString(self.img2[indexPath.row]){
                (result: Bool) in
                cell.indicator2.stopAnimating()
            }
            
            cell.indicator3.startAnimating()
            cell.imgView3.loadImageUsingString(self.img3[indexPath.row]){
                (result: Bool) in
                cell.indicator3.stopAnimating()
            }
            
            cell.imgContainer.addGestureRecognizer(imgTap)
            
            return cell
        }else if self.img2[indexPath.row] != "null" {
            let cell = tableView.dequeueReusableCellWithIdentifier("DoubleImage", forIndexPath: indexPath) as! DoubleImage
            
            cell.contentView.addGestureRecognizer(cellTap)
            
            let imgView = UIImageView()
            
            cell.btnUsername.setTitle(username, forState: .Normal)
            cell.btnUsername.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            cell.btnUsername.tag = Int(self.fromID[indexPath.row])!
            cell.detailTextLabel?.addGestureRecognizer(bodyTap)
            cell.detailTextLabel?.text = String(self.userBody[indexPath.row])
            
            if userimageURL == "null" || userimageURL == ""{
                imgView.image = UIImage(named: "noPhoto")
                cell.btnProfile.setImage(imgView.image, forState: .Normal)
            }else {
                cell.btnProfile.loadImageUsingString(userimageURL, completion: {(result: Bool) in
                    
                })
            }
            
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.postDate.text =  dateTransform(self.postDate[indexPath.row])
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            
            cell.indicator.startAnimating()
            cell.imgView1.loadImageUsingString(self.img1[indexPath.row]){
                (result: Bool) in
                
                cell.indicator.stopAnimating()
            }
            
            cell.indicator2.startAnimating()
            cell.imgView2.loadImageUsingString(self.img2[indexPath.row]){
                (result: Bool) in
                
                cell.indicator2.stopAnimating()
            }
            
            cell.imgContainer.addGestureRecognizer(imgTap)
            
            return cell
        }else if self.img1[indexPath.row] != "null" {
            let cell = tableView.dequeueReusableCellWithIdentifier("SingleImage", forIndexPath: indexPath) as! SingleImage
            
            cell.contentView.addGestureRecognizer(cellTap)
            
            let imgView = UIImageView()
            
            cell.btnUsername.setTitle(username, forState: .Normal)
            cell.btnUsername.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            cell.btnUsername.tag = Int(self.fromID[indexPath.row])!
            cell.detailTextLabel?.addGestureRecognizer(bodyTap)
            cell.detailTextLabel?.text = String(self.userBody[indexPath.row])
            
            if userimageURL == "null" {
                imgView.image = UIImage(named: "noPhoto")
                cell.btnProfile.setImage(imgView.image, forState: .Normal)
            }else {
                cell.btnProfile.loadImageUsingString(userimageURL, completion: {(result: Bool) in
                    
                })
            }
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.postDate.text = dateTransform(self.postDate[indexPath.row])
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            //            //            cell.imgView1.imgForCache(self.img1[indexPath.row])
            cell.indicator.startAnimating()
            cell.imgView1.loadImageUsingString(self.img1[indexPath.row]){
                (result: Bool) in
                cell.indicator.stopAnimating()
            }
            
            cell.imgContainer.addGestureRecognizer(imgTap)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("NoImage", forIndexPath: indexPath) as! NoImage
            
            cell.contentView.addGestureRecognizer(cellTap)
            
            let imgView = UIImageView()
            
            cell.btnUsername.setTitle(username, forState: .Normal)
            cell.btnUsername.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            cell.btnUsername.tag = Int(self.fromID[indexPath.row])!
            cell.detailTextLabel?.addGestureRecognizer(bodyTap)
            cell.detailTextLabel?.text = String(self.userBody[indexPath.row])
            
            if userimageURL == "null" {
                imgView.image = UIImage(named: "noPhoto")
                cell.btnProfile.setImage(imgView.image, forState: .Normal)
            }else {
                cell.btnProfile.loadImageUsingString(userimageURL, completion: {(result: Bool) in
                    
                })
            }
            
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.postDate.text = dateTransform(self.postDate[indexPath.row])
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            
            return cell
            
        }
    }
    
    func dateTransform(date: String) -> String {
        var dateArr = date.characters.split{$0 == " "}.map(String.init)
        var timeArr = dateArr[1].characters.split{$0 == ":"}.map(String.init)
        let config = SYSTEM_CONFIG()
        let lang = config.getSYS_VAL("AppLanguage") as! String
        var date:String = "\(dateArr[0]) \(timeArr[0]):\(timeArr[1])"
        if lang != "en" {
            dateArr = dateArr[0].characters.split{$0 == "-"}.map(String.init)
            date = "\(dateArr[0])年\(dateArr[1])月\(dateArr[2])日 \(timeArr[0]):\(timeArr[1])"
        }
        return date
    }
    
    func tapImage(sender: UITapGestureRecognizer){
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        viewDetail(sender)
    }
    
    func tapBody(sender: UITapGestureRecognizer){
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        viewDetail(sender)
    }
    
    func tapDate(sender: UITapGestureRecognizer){
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        viewDetail(sender)
    }
    
    func tapCell(sender: UITapGestureRecognizer){
        
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        viewDetail(sender)
    }
    
    func viewDetail(sender: AnyObject){
        let config = SYSTEM_CONFIG()
        if sender.state == UIGestureRecognizerState.Ended {
            let tapLocation = sender.locationInView(self.mytableview)
            if let indexPath = self.mytableview.indexPathForRowAtPoint(tapLocation) {
                
                UserDetails.username = config.getSYS_VAL("username_\(self.fromID[indexPath.row])") as! String
                UserDetails.userimageURL = config.getSYS_VAL("userimage_\(self.fromID[indexPath.row])") as! String
                UserDetails.postDate = self.postDate[indexPath.row]
                UserDetails.fromID = self.fromID[indexPath.row]
                UserDetails.body = String(self.userBody[indexPath.row])
                UserDetails.img1 = self.img1[indexPath.row]
                UserDetails.img2 = self.img2[indexPath.row]
                UserDetails.img3 = self.img3[indexPath.row]
                UserDetails.postID = ""
                
                if self.loadingScreen != nil {
                    UIViewController.removeSpinner(self.loadingScreen)
                }
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewControllerWithIdentifier("TimelineDetail") as! TimelineDetail
                
                self.presentDetail(vc)
                
            }
        }
    }
    
    func viewProfile(sender: UIButton!){
        let config = SYSTEM_CONFIG()
        UserProfile.id = config.getSYS_VAL("userid_\(sender.tag)") as! String
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("UserProfile") as! UserProfileController
        self.presentDetail(vc)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 90
        
        if self.userBody.indices.contains(indexPath.row) {
            let textsize = calcTextHeight(self.userBody[indexPath.row], frame: tableView.frame.size, fontsize: 16)
            
            if textsize.height <= 133.65625 {
                height += textsize.height
            }else{
                height += 133.65625
            }
        }
        if self.img1.count > 0 {
            if let image = self.img1[indexPath.row] as? String {
                if image != "null" {
                    height += 320
                }
            }
        }
        
        return height
    }
    
    var loadingData = false
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !loadingData && indexPath.row == self.fromID.count - 1 && noData == false {
            self.getOlderPostTimeline()
            self.loadingData = true
            btmRefresh.startAnimating()
        }
    }
    
    private func calcTextHeight(text: String, frame: CGSize, fontsize: CGFloat) -> CGRect{
        let size = CGSize(width: frame.width - 30, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(fontsize)], context: nil)
    }
    
    
    func clickMoreImage(sender: UIButton) {
        if fromID[sender.tag] != globalUserId.userID {
            alertMore(sender.tag)
        }else{
            let senderTag = sender.tag
            let title = sender.titleLabel!.text!
            self.deletePost(title, index: senderTag)
        }
    }
    
    func alertMore(index: Int){
        let config = SYSTEM_CONFIG()
        
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        let myAlert = UIAlertController(title: config.translate("more_title"), message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        myAlert.addAction(UIAlertAction(title: config.translate("block_user"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.block_user(index)
        }))
        myAlert.addAction(UIAlertAction(title: config.translate("report_post"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.report_post(index)
        }))
        myAlert.addAction(UIAlertAction(title: config.translate("btn_cancel"), style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            if menu_bar.sessionDeleted {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
                menuController.logoutMessage(self)
                return
            }
        }))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func block_user(index: Int){
        let config = SYSTEM_CONFIG()
        
        let myAlert = UIAlertController(title: config.translate("block_user_title"), message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.blockUser(index)
        }))
        myAlert.addAction(UIAlertAction(title: config.translate("btn_cancel"), style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            self.alertMore(index)
        }))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func report_post(index: Int){
        let config = SYSTEM_CONFIG()
        
        let myAlert = UIAlertController(title: config.translate("report_post_title"), message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.reportPost(index)
        }))
        myAlert.addAction(UIAlertAction(title: config.translate("btn_cancel"), style: UIAlertActionStyle.Cancel, handler: { (action: UIAlertAction!) in
            self.alertMore(index)
        }))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func blockUser(index: Int) {
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        let config = SYSTEM_CONFIG()
        let lang = config.getSYS_VAL("AppLanguage") as! String
        
        var param_lang = lang
        
        if lang != "en" {
            param_lang = "jp"
        }
        
        if globalUserId.userID != fromID[index] {
            if self.loadingScreen == nil {
                self.loadingScreen = UIViewController.displaySpinner(self.view)
            }
            
            let param = [
                "sercret"     : globalvar.secretKey,
                "action"      : "api",
                "ac"          : "add_block",
                "d"           : "0",
                "lang"        : "\(param_lang)",
                "user_id"     : "\(globalUserId.userID)",
                "block_user_id" : "\(fromID[index])"
            ]
            
            let httpRequest = HttpDataRequest(postData: param)
            let request = httpRequest.requestGet()
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                
                if error != nil || data == nil {
                    self.blockUser(index)
                }else{
                    do {
                        if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                            if let data = json["result"] as? NSDictionary {
                                if let mess = data["mess"] as? String {
                                    dispatch_async(dispatch_get_main_queue()){
                                        self.getChatmateID(self.fromID[index]){ (key: String) in
                                            self.getChatRoomID(key){
                                                (result: String) in
                                                
                                                self.updateBlockFirebase(result){
                                                    (complete: Bool) in
                                                    
                                                    if complete {
                                                        if self.loadingScreen != nil {
                                                            UIViewController.removeSpinner(self.loadingScreen)
                                                            self.loadingScreen = nil
                                                        }
                                                        self.displayMyAlertMessage(String(mess))
                                                        self.reloadTableData()
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            self.blockUser(index)
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func updateBlockFirebase(result: String, completion: (complete: Bool) -> Void){
        FIRDatabase.database().reference().child("chat").child("members").child(result).child("blocked").setValue(true){
            (error, snapshot) in
        
            if error != nil {
                self.updateBlockFirebase(result, completion: completion)
            }else{
                completion(complete: true)
            }
        }
    }
    
    func getChatmateID(id: String, completion: (key: String) -> Void){
        let user_id = Int(id)
        let userdb = FIRDatabase.database().reference().child("users").queryOrderedByChild("id").queryEqualToValue(user_id)
        
        userdb.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            let userData = snapshot.value as? NSDictionary
            
            if(userData != nil) {
                for (key, value) in userData! {
                    if let dataVal = value as? NSDictionary {
                        if let dataID =  dataVal["id"] as? Int {
                            
                            if dataID == user_id {
                                completion(key: key as! String)
                            }
                        }
                    }
                }
            }
        })
    }
    
    func getChatRoomID(userID: String, completion: (result: String) -> Void){
        
        let userid = FIRAuth.auth()?.currentUser?.uid
        
        let chatmateID = userID
        let membersDb = FIRDatabase.database().reference().child("chat").child("members").queryOrderedByChild(String(userid!)).queryEqualToValue(true)
        
        membersDb.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            var count = 0
            
            if let result =  snapshot.value as? [String: AnyObject] {
                for (key, value) in result {
                    count++
                    let dataVal = value as? NSDictionary
                    
                    let firstUser = dataVal![String(chatmateID)] as? Int
                    let secondUser = dataVal![String(userid!)] as? Int
                    
                    if firstUser != nil && secondUser != nil {
                        chatVar.RoomID = key
                    }
                    
                    if(count == snapshot.value?.count!){
                        if chatVar.RoomID != "" {
                            completion(result: chatVar.RoomID)
                        }else{
                            let roomDB = FIRDatabase.database().reference().child("chat").child("members").childByAutoId()
                            dispatch_async(dispatch_get_main_queue()){
                                var roomDetail: NSDictionary
                                roomDetail = [
                                    String(chatmateID) : true,
                                    String(userid!) : true,
                                    "blocked" : true
                                ]
                                
                                roomDB.setValue(roomDetail)
                                chatVar.RoomID = roomDB.key
                                completion(result: chatVar.RoomID)
                            }
                        }
                    }
                }
            }else{
                let roomDB = FIRDatabase.database().reference().child("chat").child("members").childByAutoId()
                dispatch_async(dispatch_get_main_queue()){
                    var roomDetail: NSDictionary
                    
                    roomDetail = [
                        String(chatmateID) : true,
                        String(userid!) : true,
                        "blocked" : true
                    ]
                    roomDB.setValue(roomDetail)
                    chatVar.RoomID = roomDB.key
                    completion(result: chatVar.RoomID)
                }
            }
        })
        
        
    }
    
    func reportPost(index: Int) {
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        let config = SYSTEM_CONFIG()
        let lang = config.getSYS_VAL("AppLanguage") as! String
        
        var param_lang = lang
        
        if lang != "en" {
            param_lang = "jp"
        }
        
        let param = [
            "sercret"           : globalvar.secretKey,
            "action"            : "api",
            "ac"                : "add_report",
            "d"                 : "0",
            "lang"              : "\(param_lang)",
            "user_id"           : "\(globalUserId.userID)",
            "from_id"           : "\(fromID[index])",
            "report_post_id"    : "\(postID[index])"
        ]
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil {
                self.reportPost(index)
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                        if json["result"] != nil {
                            if json["result"]!["mess"] != nil {
                                dispatch_async(dispatch_get_main_queue()){
                                    self.displayMyAlertMessage(String(json["result"]!["mess"]!!))
                                }
                            }
                        }
                    }else{
                        self.reportPost(index)
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
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
    
    func switchButtonCheck(switchButton : UISwitch) -> String {
        var State: String = ""
        if switchButton.on {
            State = "On"
        } else {
            State = "Off"
        }
        return State
    }
    
    func getPostID(postuserID: Int) -> Int {
        return postuserID
    }
    
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func deleteAlertMessage(userMessage:String){
        
        let config = SYSTEM_CONFIG()
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        myAlert.addAction(UIAlertAction(title: config.translate("button_delete"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            let id = self.userpostID
            let indexRow = self.indexInt
            
            self.deleteTimeline(id)
//
            let indexPath = NSIndexPath(forRow: indexRow, inSection: 0)
            self.mytableview.beginUpdates()
            self.userBody.removeAtIndex(indexPath.row)
            self.postDate.removeAtIndex(indexPath.row)
            self.postID.removeAtIndex(indexPath.row)
            self.fromID.removeAtIndex(indexPath.row)
            self.img1.removeAtIndex(indexPath.row)
            self.img2.removeAtIndex(indexPath.row)
            self.img3.removeAtIndex(indexPath.row)
            self.mytableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.mytableview.endUpdates()
            
            self.mytableview.reloadData()
            
        }))
        myAlert.addAction(UIAlertAction(title: config.translate("btn_cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
}

extension String {
    init(htmlEncodedString: String) {
        if let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding){
            let attributedOptions : [String: AnyObject] = [
                NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
            ]
            
            do{
                if let attributedString:NSAttributedString = try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil){
                    self.init(attributedString.string)
                }else{
                    print("error")
                    self.init(htmlEncodedString)     //Returning actual string if there is an error
                }
            }catch{
                print("error: \(error)")
                self.init(htmlEncodedString)     //Returning actual string if there is an error
            }
            
        }else{
            self.init(htmlEncodedString)     //Returning actual string if there is an error
        }
    }
}