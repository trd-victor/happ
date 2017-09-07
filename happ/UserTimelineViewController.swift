//
//  UserTimelineViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 21/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

struct statusButton {
    static var status : String = ""
}


class UserTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var topView: UIView!
    
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
    
    
    //get usertimeline parameters...
    var getTimeline = [
        "sercret"     : "jo8nefamehisd",
        "action"      : "api",
        "ac"          : "get_timeline",
        "d"           : "0",
        "lang"        : "en",
        "user_id"     : "\(globalUserId.userID)",
    ]
    
    //get user data
    var userDataImage = [
        "sercret"     : "jo8nefamehisd",
        "action"      : "api",
        "ac"          : "get_userinfo",
        "d"           : "0",
        "lang"        : "en",
        "user_id"     : "\(globalUserId.userID)"
    ]
    
    //basepath
    let baseUrl: NSURL = NSURL(string: "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php")!
    
    
    //variable for Timeline
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
    
    var arrText = [
    
        "en" : [
            "IamFree" : "Now I am free",
            "Timeline" : "Timeline",
            "Message" : "Message",
            "Reservation": "Room Reservation",
            "Situation": "Situation",
            "Configuration": "Configuration"
        ],
        "ja" : [
            "IamFree" : "いま暇",
            "Timeline" : "タイムライン",
            "Message" : "メッセージ",
            "Reservation": "ルーム予約",
            "Situation": "状況",
            "Configuration": "設定"
        ]
    
    ]
    
    var roundButton = UIButton()
    var refreshControl: UIRefreshControl!
    var myTimer: NSTimer!
    
    
    @IBOutlet var searchIcon: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //refresh every 60 seconds..
        self.myTimer = NSTimer(timeInterval: 60.0, target: self, selector: "refreshTimelineTable", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.myTimer, forMode: NSDefaultRunLoopMode)
        
        
        self.mytableview.backgroundColor = UIColor.clearColor()
        self.mytableview.separatorStyle = UITableViewCellSeparatorStyle.None
        
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
    
        
        self.scrollview = UIScrollView()
        self.scrollview.delegate = self
        self.scrollview.contentSize = CGSizeMake(1000, 1000)
        view.addSubview(scrollview)
        
        //set switch on 
        self.setSwitchOnOff(self.freetimeStatus)
        

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshTable:", name: "refresh", object: nil)
        
        self.getTimelineUser(self.getTimeline)

        autoLayout()
    }
  
    
    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
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
        mytableview.topAnchor.constraintEqualToAnchor(topView.bottomAnchor, constant: 5).active = true
        mytableview.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mytableview.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        mytableview.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.mytableview.delegate = self
        self.mytableview.dataSource = self
        
    }
    
    
    func refreshTimelineTable() {
       self.mytableview.reloadData()
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
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
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    
//    func refresh(sender: AnyObject) {
//        self.getTimelineUser(self.getTimeline)
//        self.mytableview.reloadData()
//        refreshControl.endRefreshing()
//    }
    
    func deletePost(sender: String, index: Int) {
        self.deleteAlertMessage("Delete this Post?")
        self.userpostID = sender
        self.indexInt = index

    }
    
    func deleteTimeline(sender: String) {
        var mess: String!
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
            
            if error1 != nil{
                print("\(error1)")
                return;
            }
            do {
                let json3 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if json3!["message"] != nil {
                    mess = json3!["message"] as! String
                }
                if json3!["result"] != nil {
                    if json3!["result"]!["mess"] != nil {
                        mess = json3!["result"]!["mess"] as! String
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
        task2.resume()
        
    }
    

    @IBAction func freetimeStatus(sender: UISwitch) {
        let statust = switchButtonCheck(freetimeStatus)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(statust, forKey: "Freetime")
        defaults.synchronize()
    }
    
    func getTimelineUser(parameters: [String: String]?) {
        
        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil{
                print("\(error)")
                return;
            }
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
                                
                                if let body = postContent.valueForKey("body") {
                                    self.userBody.append(body as! String)
                                }
                                if let body = postContent.valueForKey("from_user_id") {
                                    self.fromID.append(body as! String)
                                }
                                
                            }
                        }
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self.mytableview.reloadData()
                            }
                        }

                    }
                }
                self.getAllUserInfo(self.fromID)
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func getAllUserInfo(userID: [String]?) {
       
        for var i = 0; i < userID!.count; i++ {
            
            let request1 = NSMutableURLRequest(URL: self.baseUrl)
            let boundary1 = generateBoundaryString()
            request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
            request1.HTTPMethod = "POST"
            
            let parameters = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "get_userinfo",
                "d"           : "0",
                "lang"        : "en",
                "user_id"     : "\(userID![i])"
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

                    if json2!["error"] == nil {
                        self.testName = json2!["result"]!["name"] as! String
                        let imageUser = json2!["result"]!["icon"] as? String
                        if imageUser == nil {
                            self.urlImage = ""
                        } else {
                            self.urlImage = json2!["result"]!["icon"] as? String
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.userEachImage.append(self.urlImage)
                            self.realImage = self.userEachImage.map{ $0 ?? ""}
                            if self.testName != nil {
                                self.username.append(self.testName)
                            }
                            self.mytableview.reloadData()
                        }

                    }
                    
                } catch {
                    print(error)
                }
            }
            
            task2.resume()
        }
        
    }
    
    func refreshTable(notification: NSNotification) {
        self.userBody.removeAll()
        self.postDate.removeAll()
        self.postID.removeAll()
        self.fromID.removeAll()
        self.username.removeAll()
        self.realImage.removeAll()
        self.getTimelineUser(self.getTimeline)
    }
    
    func setSwitchOnOff(sender : UISwitch) {
        
        let userFreetime = NSUserDefaults.standardUserDefaults().objectForKey("Freetime") as? String
        if userFreetime == "On" {
            sender.on = true
        } else {
            sender.on = false
        }
    }

     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.username.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //referre to custom cell created
        
        let cell = self.mytableview.dequeueReusableCellWithIdentifier("RowCell", forIndexPath: indexPath) as! CustomCell
        
        cell.contentView.addSubview(cell.userContentLabel)
        
        //Test Layout
        cell.uesrImage.translatesAutoresizingMaskIntoConstraints = false
        cell.uesrImage.leftAnchor.constraintEqualToAnchor(cell.contentView.leftAnchor, constant: 5).active = true
        cell.uesrImage.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor, constant: 20).active = true
        cell.uesrImage.widthAnchor.constraintEqualToConstant(58).active = true
        cell.uesrImage.heightAnchor.constraintEqualToConstant(58).active = true
        
        
        let radius = min(cell.uesrImage!.frame.width/2 , cell.uesrImage!.frame.height/2)
        cell.uesrImage.layer.cornerRadius = radius
        cell.uesrImage.clipsToBounds = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {() -> Void in
            
            let url = self.realImage[indexPath.row].stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            self.data = NSData(contentsOfURL: NSURL(string: "\(url)")!)
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
                if self.data == nil {
                    cell.uesrImage.image = UIImage(named: "photo")
                } else {
                    cell.uesrImage.image = UIImage(data: self.data!)
                }
                
            })
        })
        
        cell.delet.translatesAutoresizingMaskIntoConstraints = false
        cell.postDate.translatesAutoresizingMaskIntoConstraints = false
        
        if self.fromID[indexPath.row] == globalUserId.userID {
            cell.delet.rightAnchor.constraintEqualToAnchor(cell.contentView.rightAnchor).active = true
            cell.delet.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor, constant: 15).active = true
            cell.delet.widthAnchor.constraintEqualToConstant(29).active = true
            cell.delet.heightAnchor.constraintEqualToConstant(34).active = true
            
            cell.postDate.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor, constant: 20).active = true
            cell.postDate.rightAnchor.constraintEqualToAnchor(cell.contentView.rightAnchor, constant: -36).active = true
            cell.postDate.widthAnchor.constraintEqualToConstant(120).active = true
            cell.postDate.heightAnchor.constraintEqualToConstant(34).active = true
            
            cell.delet.setImage(UIImage(named: "more"), forState: UIControlState())
            cell.delet.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.delet.tag = indexPath.row
            
            cell.delet.hidden = false
        } else {
            cell.postDate.rightAnchor.constraintEqualToAnchor(cell.contentView.rightAnchor, constant: -5).active = true
            cell.postDate.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor, constant: 20).active = true
            cell.postDate.widthAnchor.constraintEqualToConstant(120).active = true
            cell.postDate.heightAnchor.constraintEqualToConstant(34).active = true
            
            cell.delet.hidden = true
        }
        
        
        cell.username.text = self.username[indexPath.row]
        cell.postDate.text = self.postDate[indexPath.row]
        cell.delet.setTitle("\(self.postID[indexPath.row])", forState: .Normal)
        
        cell.userContentLabel.text =  String(self.userBody[indexPath.row])
        cell.userContentLabel.translatesAutoresizingMaskIntoConstraints = false
        cell.userContentLabel.leftAnchor.constraintEqualToAnchor(cell.contentView.leftAnchor, constant: 5).active = true
        cell.userContentLabel.topAnchor.constraintEqualToAnchor(cell.uesrImage.bottomAnchor, constant: 5).active = true
        cell.userContentLabel.widthAnchor.constraintEqualToAnchor(cell.contentView.widthAnchor, constant: -10).active = true
        cell.userContentLabel.numberOfLines = 0
        cell.userContentLabel.lineBreakMode = .ByTruncatingTail
        cell.userContentLabel.sizeToFit()
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }


    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 1.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)

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
            self.username.removeAtIndex(indexPath.row)
            self.mytableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.mytableview.endUpdates()
            
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