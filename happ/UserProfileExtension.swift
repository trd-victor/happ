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
    
    func blockUser() {
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        let param = [
            "sercret"     : "jo8nefamehisd",
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
                self.blockUser()
            }else{
                do {
                    if let _ = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                        self.getChatRoomID(){ (result: String) in
                            FIRDatabase.database().reference().child("chat").child("members").child(result).child("blocked").setValue(true){
                                (error, snapshot) in
                                if error != nil {
                                    FIRDatabase.database().reference().child("chat").child("members").child(result).child("blocked").setValue(false)
                                    if self.loadingScreen != nil {
                                        UIViewController.removeSpinner(self.loadingScreen)
                                        self.loadingScreen = nil
                                    }
                                }else{
                                    if self.loadingScreen != nil {
                                        UIViewController.removeSpinner(self.loadingScreen)
                                        self.loadingScreen = nil
                                    }
                                }
                            }
                        }
                    }else{
                        if self.loadingScreen != nil {
                            UIViewController.removeSpinner(self.loadingScreen)
                            self.loadingScreen = nil
                        }
                    }
                } catch {
                    self.blockUser()
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //
    // Unblock User Profile
    //
    
    func unblockUser() {
        if self.loadingScreen == nil {
            self.loadingScreen = UIViewController.displaySpinner(self.view)
        }
        
        let param = [
            "sercret"     : "jo8nefamehisd",
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
                self.unblockUser()
            }else{
                do {
                    if let _ = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                        self.getChatRoomID(){ (result: String) in
                            FIRDatabase.database().reference().child("chat").child("members").child(result).child("blocked").setValue(false){
                                (error, snapshot) in
                                if error != nil {
                                    FIRDatabase.database().reference().child("chat").child("members").child(result).child("blocked").setValue(false)
                                    if self.loadingScreen != nil {
                                        UIViewController.removeSpinner(self.loadingScreen)
                                        self.loadingScreen = nil
                                    }
                                }else{
                                    if self.loadingScreen != nil {
                                        UIViewController.removeSpinner(self.loadingScreen)
                                        self.loadingScreen = nil
                                    }
                                }
                            }
                        }
                    }else{
                        if self.loadingScreen != nil {
                            UIViewController.removeSpinner(self.loadingScreen)
                            self.loadingScreen = nil
                        }
                    }
                } catch {
                    self.unblockUser()
                    print(error)
                }
            }
        }
        task.resume()
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
        
        let param = [
            "sercret"     : "jo8nefamehisd",
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
        
        let config = SYSTEM_CONFIG()
        
        let param = [
            "sercret"     : "jo8nefamehisd",
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
                        if json["result"] != nil {
                            dispatch_async(dispatch_get_main_queue()){
                                let user_id = json["result"]!["user_id"]!
                                do {
                                    if let txtStr = json["result"]!["name"] as? String {
                                        self.userName.text = txtStr.stringByDecodingHTMLEntities
                                    }
                                }catch{
                                    self.userName.text = json["result"]!["name"] as? String
                                }
                                
                                do {
                                    if let txtStr = json["result"]!["mess"] as? String {
                                        self.msg.text = txtStr.stringByDecodingHTMLEntities
                                    }
                                }catch{
                                    self.msg.text = json["result"]!["mess"] as? String
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
                                                    self.skills.sizeToFit()
                                                }else{
                                                    skillstr += ", "
                                                }
                                            }
                                        }
                                    }else{
                                        self.skills.text = ""
                                    }
                                }
                                
                                if let imgUrl = json["result"]!["icon"] as? String {
                                    self.ProfileImage.profileForCache(imgUrl)
                                }
                                self.getTimelineUser()
                                
                                let userdb = FIRDatabase.database().reference().child("users").queryOrderedByChild("id").queryEqualToValue(user_id)
                                
                                userdb.observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                                    let userData = snapshot.value as? NSDictionary
                                    
                                    if(userData != nil) {
                                        for (key, value) in userData! {
                                            let dataVal = value as? NSDictionary
                                            
                                            if dataVal != nil {
                                                let dataID =  dataVal!["id"] as? Int
                                                let wpID = user_id as? Int
                                                if dataID != nil && wpID != nil{
                                                    if dataID! == wpID! {
                                                        chatVar.chatmateId = key as! String
                                                        chatVar.Indicator = "Search"
                                                        chatVar.name = self.userName.text!
                                                    }
                                                }
                                            }
                                        }
                                    }
                                })
                            }
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
        
        var tmppostDate = [String]()
        var tmpimg1 = [String]()
        var tmpimg2 = [String]()
        var tmpimg3 = [String]()
        var tmpuserBody = [String]()
        var tmpfromID = [String]()
        var tmppostID = [Int]()
        
        let parameters = [
            "sercret"     : "jo8nefamehisd",
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
    
    // Delete Own Timeline
    
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
