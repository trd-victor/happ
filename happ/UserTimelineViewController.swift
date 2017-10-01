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
    
    
    //get user Id...
    var userId: String = ""
    
    //get anyobject
    var dataResult: AnyObject?
    
    //basepath
    let baseUrl: NSURL = NSURL(string: "https://happ.biz/wp-admin/admin-ajax.php")!
    
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
    
    @IBOutlet var searchIcon: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("refreshLang:")), name: "refreshUserTimeline", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("notifTimeline:")), name: "reloadTimeline", object: nil)
        
        self.mytableview.addSubview(self.refreshControl)
        
        self.mytableview.registerClass(NoImage.self, forCellReuseIdentifier: "NoImage")
        self.mytableview.registerClass(SingleImage.self, forCellReuseIdentifier: "SingleImage")
        self.mytableview.registerClass(DoubleImage.self, forCellReuseIdentifier: "DoubleImage")
        self.mytableview.registerClass(TripleImage.self, forCellReuseIdentifier: "TripleImage")
        
        self.mytableview.backgroundColor = UIColor.clearColor()
        self.mytableview.separatorStyle = UITableViewCellSeparatorStyle.None
        self.mytableview.contentInset = UIEdgeInsetsMake(0, 0, 90, 0)
        
        //get user data
        userId = globalUserId.userID
        
        //load language set.
        language = setLanguage.appLanguage
        
        //calll system value...
        let config = SYSTEM_CONFIG()
        
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
        self.setSwitchOnOff(self.freetimeStatus)
        
        self.getTimelineUser()
        
        autoLayout()
        
        self.mytableview.delegate = self
        self.mytableview.dataSource = self
        
        self.bellObserver()
    }
    
    func bellObserver(){
        
        let firID = FIRAuth.auth()?.currentUser?.uid
        let unreadDB = FIRDatabase.database().reference().child("notifications").child("app-notification").child("notification-user").child(firID!).child("unread")
        unreadDB.observeEventType(.Value, withBlock: {(snap) in
            if let result = snap.value as? NSDictionary {
                if let count = result["count"] as? Int {
                    if count == 0 {
                        self.btnViewNotif.removeBadge()
                    }else{
                        self.btnViewNotif.removeBadge()
                        self.btnViewNotif.addBadge(number: count)
                    }
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
        mytableview.topAnchor.constraintEqualToAnchor(topView.bottomAnchor, constant: 10).active = true
        mytableview.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mytableview.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        mytableview.heightAnchor.constraintEqualToAnchor(view.heightAnchor, constant: -120).active = true
        
        btmRefresh.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btmRefresh.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor, constant:  -50).active = true
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
            roundButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant:  -56),
            roundButton.widthAnchor.constraintEqualToConstant(80),
            roundButton.heightAnchor.constraintEqualToConstant(80)
            ])
    }
    
    func refreshTimelineTable() {
        self.mytableview.reloadData()
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.fillMode = kCAFillModeBoth
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func CreatePostButton (sender: UIButton) ->() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("CreatePostController") as! CreatePostViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromRight
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    
    func deletePost(sender: String, index: Int) {
        self.deleteAlertMessage("Delete this Post?")
        self.userpostID = sender
        self.indexInt = index
        
    }
    
    func deleteTimeline(sender: String) {
        let request1 = NSMutableURLRequest(URL: self.baseUrl)
        let boundary1 = generateBoundaryString()
        request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
        request1.HTTPMethod = "POST"
        
        let param = [
            "sercret"     : "jo8nefamehisd",
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
                    let json3 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if json3!["message"] != nil {
                    }
                    if json3!["result"] != nil {
                        if json3!["result"]!["mess"] != nil {
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        //self.displayMyAlertMessage(mess)
                        self.mytableview.reloadData()
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
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(statust, forKey: "Freetime")
        defaults.synchronize()
        
        if statust == "On" {
            let notif = NotifController()
            notif.saveNotificationMessage(0, type: "free-time")
            updateFreeTimeStatus()
        }
        
        
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
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_timeline",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(globalUserId.userID)",
            "page"        : "\(page)",
            "count"       : "5"
        ]
        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil{
                self.getTimelineUser()
            }else {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if let resultArray = json.valueForKey("result") as? NSArray {
                            
                            if resultArray.count == 0 {
                                self.noData = true
                                self.btmRefresh.stopAnimating()
                            }
                            
                            for item in resultArray {
                                if let resultDict = item as? NSDictionary {
                                    if let userPostId = resultDict.valueForKey("ID") {
                                        self.postID.append(userPostId as! Int)
                                    }
                                    
                                    if let userPostModied = resultDict.valueForKey("post_modified") {
                                        self.postDate.append(userPostModied as! String)
                                    }
                                    
                                    if let postContent = resultDict.valueForKey("fields")  {
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
                                            self.userBody.append(body as! String)
                                        }
                                        if let body = postContent.valueForKey("from_user_id") {
                                            self.fromID.append(body as! String)
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
    
    func getTimelineUser() {
        
        let parameters = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_timeline",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(globalUserId.userID)",
            "page"        : "\(page)",
            "count"       : "5"
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
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    if let resultArray = json!.valueForKey("result") as? NSArray {
                        
                        self.myResultArr = resultArray
                        
                        for item in resultArray {
                            
                            if let resultDict = item as? NSDictionary {
                                if let userPostId = resultDict.valueForKey("ID") {
                                    self.postID.append(userPostId as! Int)
                                }
                                
                                if let userPostModied = resultDict.valueForKey("post_modified") {
                                    self.postDate.append(userPostModied as! String)
                                }
                                
                                if let postContent = resultDict.valueForKey("fields")  {
                                    if postContent["images"] != nil {
                                        if let images = postContent.valueForKey("images") as? NSArray {
                                            for index in 1...images.count {
                                                if let img = images[index - 1].valueForKey("image"){
                                                    let imgView = UIImageView()
                                                    if index == 1 {
                                                        self.img1.append(img["url"] as! String)
                                                        imgView.imgForCache(img["url"] as! String)
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
                                        self.userBody.append(body as! String)
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
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
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
    
    func setSwitchOnOff(sender : UISwitch) {
        
        let userFreetime = NSUserDefaults.standardUserDefaults().objectForKey("Freetime") as? String
        if userFreetime == "On" {
            sender.on = true
        } else {
            sender.on = false
        }
    }
    
    var scrollOffset: CGFloat = 0
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollOffset = scrollView.contentOffset.y
        if scrollView == self.mytableview {
            if scrollView.contentOffset.y < -70 && self.scrollLoad == false {
                self.page = 1
                self.scrollLoad = true
                for var i = 5; i < self.fromID.count; i++ {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    self.mytableview.beginUpdates()
                    self.mytableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                    self.userBody.removeAtIndex(i)
                    self.postDate.removeAtIndex(i)
                    self.postID.removeAtIndex(i)
                    self.fromID.removeAtIndex(i)
                    self.img1.removeAtIndex(i)
                    self.img2.removeAtIndex(i)
                    self.img3.removeAtIndex(i)
                    self.mytableview.endUpdates()
                }
                self.reloadTimeline()
            }
        }
    }
    
    
    
    func notifTimeline(notification: NSNotification){
        self.page = 1
        
        if (self.postID.count != 0){
            mytableview.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
        }
        
        refreshControl.beginRefreshing()
        for var i = 5; i < self.fromID.count; i++ {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            self.mytableview.beginUpdates()
            self.mytableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            self.userBody.removeAtIndex(i)
            self.postDate.removeAtIndex(i)
            self.postID.removeAtIndex(i)
            self.fromID.removeAtIndex(i)
            self.img1.removeAtIndex(i)
            self.img2.removeAtIndex(i)
            self.img3.removeAtIndex(i)
            self.mytableview.endUpdates()
        }
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
        let username = config.getSYS_VAL("username_\(self.fromID[indexPath.row])") as! String
        let userimageURL = config.getSYS_VAL("userimage_\(self.fromID[indexPath.row])") as! String
        let cellTap = UITapGestureRecognizer(target: self, action: "tapCell:")
        let bodyTap = UITapGestureRecognizer(target: self, action: "tapBody:")
        let imgTap = UITapGestureRecognizer(target: self, action: "tapImage:")
        
        if self.img3[indexPath.row] != "null" {
            let cell = tableView.dequeueReusableCellWithIdentifier("TripleImage", forIndexPath: indexPath) as! TripleImage
            
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
                if (imgforPostCache.objectForKey(userimageURL) != nil) {
                    let imgCache = imgforPostCache.objectForKey(userimageURL) as! UIImage
                    cell.btnProfile.setImage(imgCache, forState: .Normal)
                }else{
                    cell.btnProfile.setImage(UIImage(named : "noPhoto"), forState: .Normal)
                    cell.btnProfile.backgroundColor = UIColor.lightGrayColor()
                    cell.btnProfile.contentMode = .Center
                    let url = NSURL(string: userimageURL)
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                        if let data = NSData(contentsOfURL: url!){
                            dispatch_async(dispatch_get_main_queue()){
                                cell.btnProfile.setImage(UIImage(data: data), forState: .Normal)
                                cell.btnProfile.contentMode = .ScaleAspectFill
                            }
                            let tmpImg = UIImage(data: data)
                            self.imgforPostCache.setObject(tmpImg!, forKey: userimageURL)
                        }
                        
                    })
                    task.resume()
                }
            }
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.profileImg.tag = Int(self.fromID[indexPath.row])!
            cell.postDate.text = self.postDate[indexPath.row]
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            if (imgforPostCache.objectForKey(self.img1[indexPath.row]) != nil) {
                let imgCache = imgforPostCache.objectForKey(self.img1[indexPath.row]) as! UIImage
                cell.imgView1.image = imgCache
                cell.imgView1.contentMode = .ScaleAspectFill
            }else{
                cell.imgView1.image = UIImage(named : "photo")
                cell.imgView1.backgroundColor = UIColor.lightGrayColor()
                cell.imgView1.contentMode = .Center
                cell.indicator.startAnimating()
                let url = NSURL(string: self.img1[indexPath.row])
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                    if let data = NSData(contentsOfURL: url!){
                        dispatch_async(dispatch_get_main_queue()){
                            cell.imgView1.layoutIfNeeded()
                            cell.imgView1.contentMode = .ScaleAspectFill
                            cell.imgView1.layoutIfNeeded()
                            cell.imgView1.image = UIImage(data: data)
                            cell.indicator.stopAnimating()
                        }
                        let tmpImg = UIImage(data: data)
                        self.imgforPostCache.setObject(tmpImg!, forKey: self.img1[indexPath.row])
                    }
                    
                })
                task.resume()
            }
            if (imgforPostCache.objectForKey(self.img2[indexPath.row]) != nil) {
                let imgCache = imgforPostCache.objectForKey(self.img2[indexPath.row]) as! UIImage
                cell.imgView2.image = imgCache
                cell.imgView2.contentMode = .ScaleAspectFill
            }else{
                cell.imgView2.image = UIImage(named : "photo")
                cell.imgView2.backgroundColor = UIColor.lightGrayColor()
                cell.imgView2.contentMode = .Center
                cell.indicator2.startAnimating()
                let url = NSURL(string: self.img2[indexPath.row])
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                    if let data = NSData(contentsOfURL: url!){
                        dispatch_async(dispatch_get_main_queue()){
                            cell.imgView2.layoutIfNeeded()
                            cell.imgView2.contentMode = .ScaleAspectFill
                            cell.imgView2.layoutIfNeeded()
                            cell.imgView2.image = UIImage(data: data)
                            cell.indicator2.stopAnimating()
                        }
                        let tmpImg = UIImage(data: data)
                        self.imgforPostCache.setObject(tmpImg!, forKey: self.img2[indexPath.row])
                    }
                    
                })
                task.resume()
            }
            if (imgforPostCache.objectForKey(self.img3[indexPath.row]) != nil) {
                let imgCache = imgforPostCache.objectForKey(self.img3[indexPath.row]) as! UIImage
                cell.imgView3.image = imgCache
                cell.imgView3.contentMode = .ScaleAspectFill
            }else{
                cell.imgView3.image = UIImage(named : "photo")
                cell.imgView3.backgroundColor = UIColor.lightGrayColor()
                cell.imgView3.contentMode = .Center
                cell.indicator3.startAnimating()
                let url = NSURL(string: self.img3[indexPath.row])
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                    if let data = NSData(contentsOfURL: url!){
                        dispatch_async(dispatch_get_main_queue()){
                            cell.imgView3.layoutIfNeeded()
                            cell.imgView3.contentMode = .ScaleAspectFill
                            cell.imgView3.layoutIfNeeded()
                            cell.imgView3.image = UIImage(data: data)
                            cell.indicator3.stopAnimating()
                        }
                        let tmpImg = UIImage(data: data)
                        self.imgforPostCache.setObject(tmpImg!, forKey: self.img3[indexPath.row])
                    }
                    
                })
                task.resume()
            }
            cell.imgContainer.addGestureRecognizer(imgTap)
            cell.imgView1.contentMode = .ScaleAspectFill
            cell.imgView2.contentMode = .ScaleAspectFill
            cell.imgView3.contentMode = .ScaleAspectFill
            if self.fromID[indexPath.row] == globalUserId.userID {
                cell.btnDelete.hidden = false
            } else {
                cell.btnDelete.hidden = true
                
            }
            
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
            
            if userimageURL == "null" {
                imgView.image = UIImage(named: "noPhoto")
                cell.btnProfile.setImage(imgView.image, forState: .Normal)
            }else {
                if (imgforPostCache.objectForKey(userimageURL) != nil) {
                    let imgCache = imgforPostCache.objectForKey(userimageURL) as! UIImage
                    cell.btnProfile.setImage(imgCache, forState: .Normal)
                }else{
                    cell.btnProfile.setImage(UIImage(named : "noPhoto"), forState: .Normal)
                    cell.btnProfile.backgroundColor = UIColor.lightGrayColor()
                    cell.btnProfile.contentMode = .Center
                    let url = NSURL(string: userimageURL)
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                        if let data = NSData(contentsOfURL: url!){
                            dispatch_async(dispatch_get_main_queue()){
                                cell.btnProfile.setImage(UIImage(data: data), forState: .Normal)
                                cell.btnProfile.contentMode = .ScaleAspectFill
                            }
                            let tmpImg = UIImage(data: data)
                            self.imgforPostCache.setObject(tmpImg!, forKey: userimageURL)
                        }
                        
                    })
                    task.resume()
                }
            }
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.postDate.text = self.postDate[indexPath.row]
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            if (imgforPostCache.objectForKey(self.img1[indexPath.row]) != nil) {
                let imgCache = imgforPostCache.objectForKey(self.img1[indexPath.row]) as! UIImage
                cell.imgView1.image = imgCache
                cell.imgView1.contentMode = .ScaleAspectFill
            }else{
                cell.imgView1.image = UIImage(named : "photo")
                cell.imgView1.backgroundColor = UIColor.lightGrayColor()
                cell.imgView1.contentMode = .Center
                cell.indicator.startAnimating()
                let url = NSURL(string: self.img1[indexPath.row])
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                    if let data = NSData(contentsOfURL: url!){
                        dispatch_async(dispatch_get_main_queue()){
                            cell.imgView1.layoutIfNeeded()
                            cell.imgView1.contentMode = .ScaleAspectFill
                            cell.imgView1.layoutIfNeeded()
                            cell.imgView1.image = UIImage(data: data)
                            cell.indicator.stopAnimating()
                        }
                        let tmpImg = UIImage(data: data)
                        self.imgforPostCache.setObject(tmpImg!, forKey: self.img1[indexPath.row])
                    }
                    
                })
                task.resume()
            }
            if (imgforPostCache.objectForKey(self.img2[indexPath.row]) != nil) {
                let imgCache = imgforPostCache.objectForKey(self.img2[indexPath.row]) as! UIImage
                cell.imgView2.image = imgCache
                cell.imgView2.contentMode = .ScaleAspectFill
            }else{
                cell.imgView2.image = UIImage(named : "photo")
                cell.imgView2.backgroundColor = UIColor.lightGrayColor()
                cell.imgView2.contentMode = .Center
                cell.indicator2.startAnimating()
                let url = NSURL(string: self.img2[indexPath.row])
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                    if let data = NSData(contentsOfURL: url!){
                        dispatch_async(dispatch_get_main_queue()){
                            cell.imgView2.layoutIfNeeded()
                            cell.imgView2.contentMode = .ScaleAspectFill
                            cell.imgView2.layoutIfNeeded()
                            cell.imgView2.image = UIImage(data: data)
                            cell.indicator2.stopAnimating()
                        }
                        let tmpImg = UIImage(data: data)
                        self.imgforPostCache.setObject(tmpImg!, forKey: self.img2[indexPath.row])
                    }
                    
                })
                task.resume()
            }
            cell.imgContainer.addGestureRecognizer(imgTap)
            cell.imgView1.contentMode = .ScaleAspectFill
            cell.imgView2.contentMode = .ScaleAspectFill
            
            if self.fromID[indexPath.row] == globalUserId.userID {
                cell.btnDelete.hidden = false
            } else {
                cell.btnDelete.hidden = true
                
            }
            
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
                if (imgforPostCache.objectForKey(userimageURL) != nil) {
                    let imgCache = imgforPostCache.objectForKey(userimageURL) as! UIImage
                    cell.btnProfile.setImage(imgCache, forState: .Normal)
                }else{
                    cell.btnProfile.setImage(UIImage(named : "noPhoto"), forState: .Normal)
                    cell.btnProfile.backgroundColor = UIColor.lightGrayColor()
                    cell.btnProfile.contentMode = .Center
                    let url = NSURL(string: userimageURL)
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                        if let data = NSData(contentsOfURL: url!){
                            dispatch_async(dispatch_get_main_queue()){
                                cell.btnProfile.setImage(UIImage(data: data), forState: .Normal)
                                cell.btnProfile.contentMode = .ScaleAspectFill
                            }
                            let tmpImg = UIImage(data: data)
                            self.imgforPostCache.setObject(tmpImg!, forKey: userimageURL)
                        }
                        
                    })
                    task.resume()
                }
            }
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.postDate.text = self.postDate[indexPath.row]
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            //            cell.imgView1.imgForCache(self.img1[indexPath.row])
            
            if (imgforPostCache.objectForKey(self.img1[indexPath.row]) != nil) {
                let imgCache = imgforPostCache.objectForKey(self.img1[indexPath.row]) as! UIImage
                cell.imgView1.image = imgCache
                cell.imgView1.contentMode = .ScaleAspectFill
            }else{
                cell.imgView1.image = UIImage(named : "photo")
                cell.imgView1.backgroundColor = UIColor.lightGrayColor()
                cell.imgView1.contentMode = .Center
                cell.indicator.startAnimating()
                let url = NSURL(string: self.img1[indexPath.row])
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                    if let data = NSData(contentsOfURL: url!){
                        dispatch_async(dispatch_get_main_queue()){
                            cell.imgView1.layoutIfNeeded()
                            cell.imgView1.contentMode = .ScaleAspectFill
                            cell.imgView1.layoutIfNeeded()
                            cell.imgView1.image = UIImage(data: data)
                            cell.indicator.stopAnimating()
                        }
                        let tmpImg = UIImage(data: data)
                        if self.img1.indices.contains(indexPath.row) {
                            self.imgforPostCache.setObject(tmpImg!, forKey: self.img1[indexPath.row])
                        }
                    }
                    
                })
                task.resume()
            }
            
            cell.imgContainer.addGestureRecognizer(imgTap)
            
            if self.fromID[indexPath.row] == globalUserId.userID {
                cell.btnDelete.hidden = false
            } else {
                cell.btnDelete.hidden = true
                
            }
            
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
                if (imgforPostCache.objectForKey(userimageURL) != nil) {
                    let imgCache = imgforPostCache.objectForKey(userimageURL) as! UIImage
                    cell.btnProfile.setImage(imgCache, forState: .Normal)
                }else{
                    cell.btnProfile.setImage(UIImage(named : "noPhoto"), forState: .Normal)
                    cell.btnProfile.backgroundColor = UIColor.lightGrayColor()
                    cell.btnProfile.contentMode = .Center
                    let url = NSURL(string: userimageURL)
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                        if let data = NSData(contentsOfURL: url!){
                            dispatch_async(dispatch_get_main_queue()){
                                cell.btnProfile.setImage(UIImage(data: data), forState: .Normal)
                                cell.btnProfile.contentMode = .ScaleAspectFill
                            }
                            let tmpImg = UIImage(data: data)
                            self.imgforPostCache.setObject(tmpImg!, forKey: userimageURL)
                        }
                        
                    })
                    task.resume()
                }
            }
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.postDate.text = self.postDate[indexPath.row]
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            
            if self.fromID[indexPath.row] == globalUserId.userID {
                cell.btnDelete.hidden = false
            } else {
                cell.btnDelete.hidden = true
                
            }
            
            return cell
            
        }
    }
    
    func tapImage(sender: UITapGestureRecognizer){
        viewDetail(sender)
    }
    
    func tapBody(sender: UITapGestureRecognizer){
        viewDetail(sender)
    }
    
    func tapDate(sender: UITapGestureRecognizer){
        viewDetail(sender)
    }
    
    func tapCell(sender: UITapGestureRecognizer){
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
            height += textsize.height
        }
        if self.img1[indexPath.row] != "null" {
            height += 320
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
        let size = CGSize(width: frame.width - 50, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(fontsize)], context: nil)
    }
    
    
    func clickMoreImage(sender: UIButton) {
        let senderTag = sender.tag
        let title = sender.titleLabel!.text!
        self.deletePost(title, index: senderTag)
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
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        myAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            let id = self.userpostID
            let indexRow = self.indexInt
            
            self.deleteTimeline(id)
            
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
        myAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
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