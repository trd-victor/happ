//
//  ViewLibView
//  happ
//
//  Created by TokikawaTeppei on 13/09/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

class ViewLibViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let navBar: UINavigationBar = UINavigationBar()
    let sendBtn: UIButton = UIButton(type: .System)
    let containerView: UIView = UIView()
    let txtField: UITextView = UITextView()
    let separatorLineView: UIView = UIView()
    let blockTextView: UILabel = UILabel()
    var myCollectionView:UICollectionView?
    var layout: UICollectionViewFlowLayout?
    
    var containerViewBottomAncher: NSLayoutConstraint?
    var collectioView: NSLayoutConstraint?
    
    var messagesData: [FIRDataSnapshot] = []
    var chatMatePhoto: String = ""
    var userPhoto: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "#272727")
        self.navBar.barTintColor = UIColor(hexString: "#272727")
        self.navBar.translucent = false
        
        self.layout = UICollectionViewFlowLayout()
        self.myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.layout!)
        
        self.myCollectionView!.registerClass(MessageCell.self, forCellWithReuseIdentifier: "Messagecell")
        self.myCollectionView!.backgroundColor = UIColor.whiteColor()
        self.myCollectionView!.contentInset = UIEdgeInsetsMake(10, 0, 10, 0)
        self.myCollectionView!.dataSource = self
        self.myCollectionView!.delegate = self
        containerView.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.containerView)
        self.view.addSubview(self.navBar)
        self.view.addSubview(self.myCollectionView!)
        
        
        self.containerView.addSubview(self.separatorLineView)
        self.containerView.addSubview(self.sendBtn)
        self.containerView.addSubview(self.txtField)
        self.containerView.addSubview(self.blockTextView)
        self.blockTextView.hidden = true
        self.txtField.tintColor = UIColor.blackColor()
        autoLayout()
        loadConfig()
        setupKeyboard()
        if(chatVar.Indicator == "MessageTable"){
            self.deleteMessage()
            self.loadMessages()
            self.addBlockObserver()
        }else if(chatVar.Indicator == "Search"){
            self.deleteMessage()
            self.getChatRoomID()
        }
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeBackTimeline:");
        swipeRight.direction = .Right
        
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func swipeBackTimeline(sender: UISwipeGestureRecognizer){
        if chatVar.RoomID != "" {
            FIRDatabase.database().reference().child("chat").child("members").child(chatVar.RoomID).removeAllObservers()
            chatVar.RoomID = ""
        }
        
        let transition: CATransition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func addBlockObserver(){
        if chatVar.RoomID != "" {
            let memberDB = FIRDatabase.database().reference().child("chat").child("members").child(chatVar.RoomID)
            
            memberDB.observeEventType(.Value, withBlock: {(snapshot) in
                
                if let result = snapshot.value as? NSDictionary {
                    if let block = result["blocked"] as? Bool {
                        if block {
                            self.blockTextView.hidden = false
                            self.txtField.hidden = true
                            self.sendBtn.hidden = true
                        }else{
                            self.blockTextView.hidden = true
                            self.txtField.hidden = false
                            self.sendBtn.hidden = false
                        }
                    }
                }
                
                
                if !snapshot.exists() {
                    self.blockTextView.hidden = true
                }
            })
        }
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    func setupKeyboard(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleKeyboardShow:"), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleKeyboardHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardShow(notification: NSNotification){
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        
        containerViewBottomAncher?.constant = -keyboardFrame!.height
        collectioView?.constant = -112 + -keyboardFrame!.height
        
        if keyboardDuration != nil {
            UIView.animateWithDuration(keyboardDuration!){
                self.view.layer.removeAllAnimations()
                self.view.layoutIfNeeded()
                
                if self.messagesData.count > 0 {
                    let lastItemIndex = NSIndexPath(forItem: self.messagesData.count - 1, inSection: 0)
                    self.myCollectionView!.scrollToItemAtIndexPath(lastItemIndex, atScrollPosition: .Bottom, animated: false)
                }
            }
        }
    }
    
    func handleKeyboardHide(notification: NSNotification){
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        
        containerViewBottomAncher?.constant = 0
        collectioView?.constant = -112
        
        if keyboardDuration != nil {
            UIView.animateWithDuration(keyboardDuration!){
                self.containerViewBottomAncher?.constant = 0
                self.collectioView?.constant = -112
            }
        }
    }
    
    func autoLayout(){
        self.navBar.translatesAutoresizingMaskIntoConstraints = false
        self.navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        self.navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        self.navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        self.navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        containerViewBottomAncher = containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
        containerViewBottomAncher?.active = true
        
        self.containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        self.containerView.heightAnchor.constraintEqualToConstant(45).active = true
        
        self.sendBtn.translatesAutoresizingMaskIntoConstraints = false
        self.sendBtn.rightAnchor.constraintEqualToAnchor(self.containerView.rightAnchor).active = true
        self.sendBtn.centerYAnchor.constraintEqualToAnchor(self.containerView.centerYAnchor).active = true
        self.sendBtn.widthAnchor.constraintEqualToConstant(80).active = true
        self.sendBtn.heightAnchor.constraintEqualToAnchor(self.containerView.heightAnchor).active = true
        
        self.txtField.translatesAutoresizingMaskIntoConstraints = false
        self.txtField.topAnchor.constraintEqualToAnchor(self.containerView.topAnchor, constant: 5).active = true
        self.txtField.leftAnchor.constraintEqualToAnchor(self.containerView.leftAnchor, constant: 5).active = true
        self.txtField.widthAnchor.constraintEqualToAnchor(self.containerView.widthAnchor, constant: -85).active = true
        self.txtField.heightAnchor.constraintEqualToAnchor(self.containerView.heightAnchor, constant: -6).active = true
        self.txtField.font = UIFont.systemFontOfSize(16)
     
        self.blockTextView.translatesAutoresizingMaskIntoConstraints = false
        self.blockTextView.topAnchor.constraintEqualToAnchor(self.containerView.topAnchor).active = true
        self.blockTextView.leftAnchor.constraintEqualToAnchor(self.containerView.leftAnchor, constant: 5).active = true
        self.blockTextView.centerYAnchor.constraintEqualToAnchor(self.containerView.centerYAnchor).active = true
        self.blockTextView.widthAnchor.constraintEqualToAnchor(self.containerView.widthAnchor).active = true
        self.blockTextView.heightAnchor.constraintEqualToAnchor(self.containerView.heightAnchor).active = true
        self.blockTextView.backgroundColor = UIColor.whiteColor()
        self.blockTextView.textColor = UIColor.blueColor()
        
        self.separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        self.separatorLineView.leftAnchor.constraintEqualToAnchor(self.containerView.leftAnchor).active = true
        self.separatorLineView.topAnchor.constraintEqualToAnchor(self.containerView.topAnchor).active = true
        self.separatorLineView.widthAnchor.constraintEqualToAnchor(self.containerView.widthAnchor).active = true
        self.separatorLineView.heightAnchor.constraintEqualToConstant(1).active = true
        
        self.myCollectionView!.translatesAutoresizingMaskIntoConstraints = false
        self.myCollectionView!.topAnchor.constraintEqualToAnchor(self.navBar.bottomAnchor).active = true
        self.myCollectionView!.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        self.myCollectionView!.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        
        collectioView =  self.myCollectionView!.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, constant: -112)
        collectioView?.active = true
        
        self.myCollectionView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("hideKeyboard")))
    }
    
    func hideKeyboard(){
        self.txtField.resignFirstResponder()
    }
    
    func loadConfig(){
        let config = SYSTEM_CONFIG()
        let navtitle = chatVar.name
        let sendStr = config.translate("label_send")
        
        self.txtField.addPlaceholder(config.translate("label_enter_message"))
        
        let navItem = UINavigationItem(title: navtitle)
        let btnBack = UIBarButtonItem(image: UIImage(named: "Image"), style: .Plain, target: self, action: Selector("backToMenu:"))
        btnBack.tintColor = UIColor.whiteColor()
        
        //closer to left anchor nav
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -15
        
        navItem.setLeftBarButtonItems([negativeSpacer, btnBack], animated: false)
        
        self.navBar.setItems([navItem], animated: false)
        self.navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        // set button title
        self.sendBtn.setTitle(sendStr, forState: .Normal)
        self.sendBtn.addTarget(self, action: Selector("handleSend"), forControlEvents: .TouchUpInside)
        
        self.blockTextView.text = config.translate("mess_block_convo")
    }
    
    func backToMenu(sender: UIBarButtonItem) -> () {
        
        NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil, userInfo: nil)
      
        if chatVar.RoomID != "" {
            FIRDatabase.database().reference().child("chat").child("members").child(chatVar.RoomID).removeAllObservers()
            chatVar.RoomID = ""
        }
        
        self.presentBackDetail(MessageTableViewController())
    }
    
    func presentBackDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func handleSend(){
        
        let mess = self.txtField.text!
        self.txtField.text = ""
        self.txtField.textViewDidChange(txtField)
        var checkMessage: String = ""
        
        // check if no text on textfield
        checkMessage = mess.componentsSeparatedByString(" ").joinWithSeparator("")
        
        if chatVar.RoomID == "" {
            return
        }
        
        if(checkMessage.characters.count <= 0){
            return
        }else{
            let config = SYSTEM_CONFIG()
            let username = config.getSYS_VAL("username_\(globalUserId.userID)")!
            
            let timestamp = FIRServerValue.timestamp()
            
            let roomID = chatVar.RoomID
            let chatmateID = chatVar.chatmateId
            let userID = FIRAuth.auth()?.currentUser?.uid
            
            if let photo = globalvar.USER_IMG.valueForKey(chatmateID)?.valueForKey("photoUrl") as? String {
                self.chatMatePhoto = photo
            }
            
            if let photo = globalvar.USER_IMG.valueForKey(userID!)?.valueForKey("photoUrl") as? String {
                self.userPhoto = photo
            }
            
            // save to message table on firebase using the roomID as child
            let messageDB = FIRDatabase.database().reference().child("chat").child("messages").child(roomID).childByAutoId()
            let message = [
                "message": mess,
                "name": username,
                "userId": userID!,
                "photoUrl" : self.userPhoto,
                "timestamp" : timestamp
            ]
            
            messageDB.setValue(message)
            
            // save to last-message table on firebase using chatmate key as child
            let chatMateLastMessDB = FIRDatabase.database().reference().child("chat").child("last-message").child(chatmateID).child(roomID)
            
            let chatMateDetailMess = [
                "chatmateId"   : userID!,
                "chatroomId"   : roomID,
                "lastMessage"  : mess,
                "name"         : username,
                "photoUrl"     : self.userPhoto,
                "read"         : false,
                "timestamp"    : timestamp
            ]
            chatMateLastMessDB.setValue(chatMateDetailMess)
            
            // save to last-message table on firebase using user key as child
            let userLastMessDB = FIRDatabase.database().reference().child("chat").child("last-message").child(userID!).child(roomID)
            
            let userDetailMess = [
                "chatmateId"   : chatmateID,
                "chatroomId"   : roomID,
                "lastMessage"  : mess,
                "name"         : chatVar.name,
                "photoUrl"     : self.chatMatePhoto,
                "read"         : true,
                "timestamp"    : timestamp
            ]
            
            userLastMessDB.setValue(userDetailMess)
            
            // save to message-notif table on firebase
            let messNotifDB = FIRDatabase.database().reference().child("chat").child("message-notif").child(chatmateID)
            
            let notifDetail = [
                "chatmateId": userID!,
                "chatroomId" : roomID,
                "message": mess,
                "name": username,
                "photoUrl": self.userPhoto
            ]
            
            messNotifDB.setValue(notifDetail)
            
            // Note after saving on message-notif, the firebase function will detect that there is a changes  on that table and will send a notification to a specific account
        }
    }
    
    func loadMessages(){
        let roomID = chatVar.RoomID
        let messagesDb = FIRDatabase.database().reference().child("chat").child("messages").child(String(roomID)).queryOrderedByChild("timestamp")
        
        messagesDb.observeEventType(.Value, withBlock: {(snapshot)  in
            self.messagesData.removeAll()
            
            dispatch_async(dispatch_get_main_queue()){
                if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    self.messagesData = result
                    dispatch_async(dispatch_get_main_queue()){
                        self.myCollectionView!.reloadData()
                        
                        if(self.messagesData.count > 1){
                            if Int(self.messagesData.count) != nil && self.messagesData.count != 0 {
                                let lastItemIndex =  NSIndexPath(forItem: self.messagesData.count - 1, inSection: 0)
                                if let _ = self.myCollectionView?.dataSource?.collectionView(self.myCollectionView!, cellForItemAtIndexPath: lastItemIndex){
                                    self.myCollectionView!.scrollToItemAtIndexPath(lastItemIndex, atScrollPosition: .Bottom, animated: false)
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func deleteMessage(){
        self.messagesData = []
        self.myCollectionView?.reloadData()
    }
    
    func getChatRoomID(){
        chatVar.RoomID = ""
        
        let chatmateID = chatVar.chatmateId
        let userid = FIRAuth.auth()?.currentUser?.uid
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
                            self.loadMessages()
                            self.addBlockObserver()
                        }else{
                            let roomDB = FIRDatabase.database().reference().child("chat").child("members").childByAutoId()
                            dispatch_async(dispatch_get_main_queue()){
                                let roomDetail = [
                                    String(chatmateID) : true,
                                    String(userid!) : true,
                                    "blocked" : false
                                ]
                                roomDB.setValue(roomDetail)
                                chatVar.RoomID = roomDB.key
                                self.loadMessages()
                                self.addBlockObserver()
                            }
                        }
                    }
                }
            }else{
                let roomDB = FIRDatabase.database().reference().child("chat").child("members").childByAutoId()
                dispatch_async(dispatch_get_main_queue()){
                    let roomDetail = [
                        String(chatmateID) : true,
                        String(userid!) : true,
                        "blocked" : false
                    ]
                    roomDB.setValue(roomDetail)
                    chatVar.RoomID = roomDB.key
                    self.loadMessages()
                    self.addBlockObserver()
                }
            }
        })
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.messagesData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Messagecell", forIndexPath: indexPath) as! MessageCell
        let data = self.messagesData[indexPath.row]
        
        if let messData = data.value as? NSDictionary {
            self.setupCell(cell, mess_data: messData)
            
            if let message = messData["message"] as? String {
                cell.txtLbl.text = message
            }
        }
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(cell.txtLbl.text!).width + 18
        cell.bubbleHeightAnchor?.constant = estimateFrameForText(cell.txtLbl.text!).height + 10

        
        return cell
    }
    
    func setupCell(cell: MessageCell, mess_data: NSDictionary){
        if FIRAuth.auth()?.currentUser?.uid == (mess_data["userId"] as! String){
            
            cell.bubbleView.backgroundColor = UIColor(hexString: "#E0E0E0")
            cell.txtLbl.textColor = UIColor.blackColor()
            
            cell.bubbleViewLeftAnchor?.active = false
            cell.bubbleViewRightAnchor?.active = true
            var imageUrl: String = ""
            if let photoUrl = mess_data["photoUrl"] as? String{
                imageUrl = photoUrl
            }
            
            if imageUrl != "" {
                if (globalvar.imgforProfileCache.objectForKey(imageUrl) != nil) {
                    let imgCache = globalvar.imgforProfileCache.objectForKey(imageUrl) as! UIImage
                    cell.userPhoto.image = imgCache
                }else{
                    cell.userPhoto.image = UIImage(named : "noPhoto")
                    let url = NSURL(string: imageUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
                    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                        if let data = NSData(contentsOfURL: url!){
                            dispatch_async(dispatch_get_main_queue()){
                                cell.userPhoto.image = UIImage(data: data)
                            }
                            let tmpImg = UIImage(data: data)
                            globalvar.imgforProfileCache.setObject(tmpImg!, forKey: imageUrl)
                        }
                    })
                    task.resume()
                }
            }
            
            cell.dateLblLeft.text = dateFormatter((mess_data["timestamp"] as? NSNumber)!)
            cell.dateLblRight.text = dateFormatter((mess_data["timestamp"] as? NSNumber)!)
            
            cell.dateLblRight.hidden = false
            cell.dateLblLeft.hidden = true
            cell.userPhoto.hidden = false
            cell.chatmatePhoto.hidden = true
        }else {
            cell.bubbleView.backgroundColor =  UIColor(hexString: "#E4D4B9")
            cell.txtLbl.textColor = UIColor.blackColor()
            
            var imageUrl: String = ""
            if let photoUrl = mess_data["photoUrl"] as? String{
                imageUrl = photoUrl
            }
            
            if (globalvar.imgforProfileCache.objectForKey(imageUrl) != nil) {
                let imgCache = globalvar.imgforProfileCache.objectForKey(imageUrl) as! UIImage
                cell.chatmatePhoto.image = imgCache
            }else{
                cell.chatmatePhoto.image = UIImage(named : "noPhoto")
                let url = NSURL(string: imageUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
                let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                    if let data = NSData(contentsOfURL: url!){
                        dispatch_async(dispatch_get_main_queue()){
                            cell.chatmatePhoto.image = UIImage(data: data)
                        }
                        let tmpImg = UIImage(data: data)
                        globalvar.imgforProfileCache.setObject(tmpImg!, forKey: imageUrl)
                    }
                    
                })
                task.resume()
            }
            
            cell.bubbleViewRightAnchor?.active = false
            cell.bubbleViewLeftAnchor?.active = true
            
            cell.dateLblLeft.text = dateFormatter((mess_data["timestamp"] as? NSNumber)!)
            cell.dateLblRight.text = dateFormatter((mess_data["timestamp"] as? NSNumber)!)
            
            cell.dateLblLeft.hidden = false
            cell.dateLblRight.hidden = true
            cell.chatmatePhoto.hidden = false
            cell.userPhoto.hidden = true
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var height: CGFloat = 80
        let data = self.messagesData[indexPath.row] 
        
        if let value = data.value as? NSDictionary {
            if let message = value["message"] {
                height = estimateFrameForText(message as! String).height + 30
            }
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dateFormatter(timestamp: NSNumber) -> String{
        let seconds = timestamp.doubleValue / 1000
        let dateTimestamp = NSDate(timeIntervalSince1970: seconds)
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone(name: "Asia/Tokyo")
        formatter.dateFormat = "HH:mm"
        let time = formatter.stringFromDate(dateTimestamp)
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.stringFromDate(dateTimestamp)
        return self.dateTransform("\(date) \(time)")
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
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

