//
//  UserProfileExtension.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/19.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

extension UserProfileController {
    
    //
    // Block User Profile
    //
    
    func blockUser(completion: (done: Bool) -> Void) {
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        let param = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "add_block",
            "d"           : "0",
            "lang"        : "jp",
            "user_id"     : "\(globalUserId.userID)",
            "block_user_id" : "\(UserProfile.id)"
        ]
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil {
                self.blockUser(completion)
            }else{
                do {
                    if let _ = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                        self.getChatRoomID(){ (result: String) in
                            self.updateFirebaseBlock(result){
                                (success: Bool) in
                                completion(done: success)
                            }
                        }
                    }else{
                        if self.loadingScreen != nil {
                            UIViewController.removeSpinner(self.loadingScreen)
                            self.loadingScreen = nil
                        }
                    }
                } catch {
                    self.blockUser(completion)
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func updateFirebaseBlock(result: String, completion: (success: Bool) -> Void){
        FIRDatabase.database().reference().child("chat").child("members").child(result).child("blocked").setValue(true){
            (error, snapshot) in
            if error != nil {
                self.updateFirebaseBlock(result, completion: completion)
            }else{
                completion(success: true)
                if self.loadingScreen != nil {
                    UIViewController.removeSpinner(self.loadingScreen)
                    self.loadingScreen = nil
                }
            }
        }
    }
    
    //
    // Unblock User Profile
    //
    
    func unblockUser(completion: (complete: Bool)-> Void) {
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        let param = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "unlock_block",
            "d"           : "0",
            "lang"        : "jp",
            "user_id"     : "\(globalUserId.userID)",
            "block_user_id" : "\(UserProfile.id)"
        ]
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil {
                self.unblockUser(completion)
            }else{
                do {
                    if let _ = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                        self.getChatRoomID(){ (result: String) in
                            self.updateFirebaseUnblock(result){
                                (success: Bool) in
                                completion(complete: success)
                            }
                        }
                    }else{
                        if self.loadingScreen != nil {
                            UIViewController.removeSpinner(self.loadingScreen)
                            self.loadingScreen = nil
                        }
                    }
                } catch {
                    self.unblockUser(completion)
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func updateFirebaseUnblock(result: String, completion: (success: Bool)-> Void){
        
        FIRDatabase.database().reference().child("chat").child("members").child(result).child("blocked").setValue(false){
            (error, snapshot) in
            if error != nil {
                self.updateFirebaseUnblock(result, completion: completion)
            }else{
                completion(success: true)
                if self.loadingScreen != nil {
                    UIViewController.removeSpinner(self.loadingScreen)
                    self.loadingScreen = nil
                }
            }
        }
    }
   
    func getChatRoomID(completion: (result: String)-> Void){
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
                            completion(result: chatVar.RoomID)
                        }else{
                            let roomDB = FIRDatabase.database().reference().child("chat").child("members").childByAutoId()
                            dispatch_async(dispatch_get_main_queue()){
                                var roomDetail: NSDictionary
                                roomDetail = [
                                    String(chatmateID) : true,
                                    String(userid!) : true,
                                    "blocked" : false
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
                        "blocked" : false
                    ]
                    roomDB.setValue(roomDetail)
                    chatVar.RoomID = roomDB.key
                    completion(result: chatVar.RoomID)
                }
            }
        })
    }
    
    
    //
    // GET BLOCK ID's
    //
    
    func getBlockIds(){
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        let param = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "get_block_list",
            "d"           : "0",
            "lang"        : "jp",
            "user_id"     : "\(globalUserId.userID)"
        ]
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil {
                self.getBlockIds()
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                        if json["result"] != nil {
                            for data in (json["result"] as? NSArray)! {
                                if let id = data["fields"]!!["block_user_id"]! as? String {
                                    if id == UserProfile.id {
                                        dispatch_async(dispatch_get_main_queue()){
                                            self.btnBlock.backgroundColor = UIColor(hexString: "#E2041B")
                                            self.btnBlock.setTitle("Unblock", forState: .Normal)
                                            self.btnBlock.tag = 1
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        self.getBlockIds()
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //
    // GET USER PROFILE INFORMATION
    //
    
    func loadUserinfo(sender: String) {
        
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        let config = SYSTEM_CONFIG()
        
        let param = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "get_userinfo",
            "d"           : "0",
            "lang"        : "jp",
            "user_id"     : "\(sender)"
        ]
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error -> Void in
            
            if (error != nil) {
                self.loadUserinfo(sender)
            }
            else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                        if let _ = json["success"] as? Bool {
                            if json["result"] != nil {
                                dispatch_async(dispatch_get_main_queue()){
                                    //                                let user_id = json["result"]!["user_id"]!
                                    
                                    if let txtStr = json["result"]!["name"] as? String {
                                        self.userName.text = txtStr.stringByDecodingHTMLEntities
                                    }
                                    
                                    if let txtStr = json["result"]!["mess"] as? String {
                                        self.msg.text = txtStr.stringByDecodingHTMLEntities
                                        self.msgContraint.constant = self.estimateFrameForText(self.msg.text!).height + 10
                                        self.profileViewContraint.constant = self.msgContraint.constant + self.skillContraint.constant + 240
                                    }else{
                                        self.msgContraint.constant = 0
                                        self.profileViewContraint.constant = self.msgContraint.constant + self.skillContraint.constant + 240
                                    }
                                    
                                    self.h_id.text = json["result"]!["h_id"] as? String
                                    
                                    if let skill = json["result"]!["skills"] as? String {
                                        if skill != "" && skill != "null" {
                                            let all_skills = skill.characters.split(",")
                                            var skillstr = ""
                                            var count = 0
                                            if all_skills.count == 0 {
                                                self.skills.text = skill
                                            }else{
                                                for (value) in all_skills {
                                                    count++
                                                    skillstr += config.getSkillByID(String(value))
                                                    if count == all_skills.count {
                                                        self.skills.text = skillstr
                                                        self.skillContraint.constant = self.estimateFrameForText(skillstr).height + 10
                                                        self.profileViewContraint.constant = self.msgContraint.constant + self.skillContraint.constant + 240
                                                    }else{
                                                        skillstr += ", "
                                                    }
                                                }
                                            }
                                        }else{
                                            self.skills.text = ""
                                            self.skillContraint.constant = 0
                                            self.profileViewContraint.constant = self.msgContraint.constant + self.skillContraint.constant + 240
                                        }
                                    }else{
                                        self.skills.text = ""
                                        self.skillContraint.constant = 0
                                        self.profileViewContraint.constant = self.msgContraint.constant + self.skillContraint.constant + 240
                                    }
                                    
                                    if let imgUrl = json["result"]!["icon"] as? String {
                                        self.ProfileImage.profileForCache(imgUrl)
                                    }
                                    self.getTimelineUser()
                                    
                                    if let fid = json["result"]!["firebase_id"] as? String {
                                        chatVar.chatmateId = fid
                                        chatVar.Indicator = "Search"
                                        chatVar.name = self.userName.text!
                                    }
                                    
                                    if UserProfile.id == globalUserId.userID {
                                        self.profileViewContraint.constant = self.profileViewContraint.constant - 67
                                    }
                                    
                                    self.tblProfile.contentInset = UIEdgeInsetsMake(self.profileViewContraint.constant, 0, 0, 0)
                                    self.topConstraint.constant = self.profileViewContraint.constant * -1
                                }
                            }
                        }else{
                            self.displayMessage(config.translate("not_allowed_to_view"));
                        }
                    }else{
                        self.loadUserinfo(sender)
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
        
    }
    
    // Reload User Profile Timeline
    
    func reloadData() {
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        var tmppostDate = [String]()
        var tmpimg1 = [String]()
        var tmpimg2 = [String]()
        var tmpimg3 = [String]()
        var tmpuserBody = [String]()
        var tmpfromID = [String]()
        var tmppostID = [Int]()
        
        let parameters = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "get_timeline",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(globalUserId.userID)",
            "from_id"     : "\(UserProfile.id)",
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
            
            if error != nil || data == nil {
                self.reloadData()
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        
                        if let resultArray = json.valueForKey("result") as? NSArray {
                            
                            for item in resultArray {
                                
                                if let resultDict = item as? NSDictionary {
                                    if let userPostId = resultDict.valueForKey("ID") {
                                        tmppostID.append(userPostId as! Int)
                                    }
                                    
                                    if let userPostModied = resultDict.valueForKey("post_modified") {
                                        tmppostDate.append(userPostModied as! String)
                                    }
                                    
                                    if let postContent = resultDict.valueForKey("fields")  {
                                        if postContent["images"] != nil {
                                            if let images = postContent.valueForKey("images") as? NSArray {
                                                for index in 1...images.count {
                                                    if let img = images[index - 1].valueForKey("image"){
                                                        if index == 1 {
                                                            tmpimg1.append(img["url"] as! String)
                                                        }
                                                        if index == 2 {
                                                            tmpimg2.append(img["url"] as! String)
                                                        }
                                                        if index == 3 {
                                                            tmpimg3.append(img["url"] as! String)
                                                        }
                                                    }
                                                }
                                                if images.count < 2 {
                                                    tmpimg2.append("null")
                                                }
                                                if images.count < 3 {
                                                    tmpimg3.append("null")
                                                }
                                            }else{
                                                tmpimg1.append("null")
                                                tmpimg2.append("null")
                                                tmpimg3.append("null")
                                            }
                                        }
                                        if let body = postContent.valueForKey("body") {
                                            if let textStr = body as? String {
                                                let text = textStr.stringByDecodingHTMLEntities
                                                tmpuserBody.append(text)
                                            }
                                        }
                                        if let body = postContent.valueForKey("from_user_id") {
                                            tmpfromID.append( body as! String )
                                        }
                                    }
                                }
                            }
                            dispatch_async(dispatch_get_main_queue()){
                                self.img1 = tmpimg1
                                self.img2 = tmpimg2
                                self.img3 = tmpimg3
                                self.userBody = tmpuserBody
                                self.fromID = tmpfromID
                                self.postID = tmppostID
                                self.postDate = tmppostDate
                                
                                if self.loadingData {
                                    self.loadingData = false
                                }
                                
                                if self.noData {
                                    self.noData = false
                                }
                                
                                self.tblProfile.reloadData()
                                self.topReload.stopAnimating()
                                
                            }
                        }
                    }else{
                        self.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
        
    }
    
    func getOlderTimeline(){
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        self.page += 1
        
        let parameters = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "get_timeline",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(globalUserId.userID)",
            "from_id"     : "\(UserProfile.id)",
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
                self.getOlderTimeline()
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
                        
                        self.tblProfile.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    // Delete Own Timeline
    
    func deleteTimeline(sender: String) {
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
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
            
            if error1 != nil || data1 == nil{
                self.deleteTimeline(sender)
            }else{
                do {
                    let _ = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        //self.displayMyAlertMessage(mess)
                        self.tblProfile.reloadData()
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
        task2.resume()
        
    }
    
}
