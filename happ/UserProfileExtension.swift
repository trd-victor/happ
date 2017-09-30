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
                self.getBlockIds()
            }else{
                do {
                    if let _ = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                        
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
    // Unblock User Profile
    //
    
    func unblockUser() {
        
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
                self.getBlockIds()
            }else{
                do {
                    if let _ = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                        
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
                                self.userName.text = json["result"]!["name"] as? String
                                self.h_id.text = json["result"]!["h_id"] as? String
                               
                                let skill = json["result"]!["skills"] as? String
                                
                                if skill != nil && skill != "null" {
                                    self.skills.text = json["result"]!["skills"] as? String
                                }else{
                                    self.skills.text = ""
                                }
                                    
                                self.msg.text = json["result"]!["mess"] as? String
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
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    var indexArr:Int = -1
                    
                    if let resultArray = json!.valueForKey("result") as? NSArray {
                        
                        for item in resultArray {
                            
                            indexArr += 1
                            
                            if indexArr < self.postID.count {
                                if let resultDict = item as? NSDictionary {
                                    if let userPostId = resultDict.valueForKey("ID") {
                                        self.postID[indexArr] = userPostId as! Int
                                    }
                                    
                                    if let userPostModied = resultDict.valueForKey("post_modified") {
                                        self.postDate[indexArr] = userPostModied as! String
                                    }
                                    
                                    if let postContent = resultDict.valueForKey("fields")  {
                                        if postContent["images"] != nil {
                                            if let images = postContent.valueForKey("images") as? NSArray {
                                                for index in 1...images.count {
                                                    if let img = images[index - 1].valueForKey("image"){
                                                        if index == 1 {
                                                            self.img1[indexArr] = img["url"] as! String
                                                        }
                                                        if index == 2 {
                                                            self.img2[indexArr] = img["url"] as! String
                                                        }
                                                        if index == 3 {
                                                            self.img3[indexArr] = img["url"] as! String
                                                        }
                                                    }
                                                }
                                                if images.count < 2 {
                                                    self.img2[indexArr] = "null"
                                                }
                                                if images.count < 3 {
                                                    self.img3[indexArr] = "null"
                                                }
                                            }else{
                                                self.img1[indexArr] = "null"
                                                self.img2[indexArr] = "null"
                                                self.img3[indexArr] = "null"
                                            }
                                        }
                                        if let body = postContent.valueForKey("body") {
                                            self.userBody[indexArr] = body as! String
                                        }
                                        if let body = postContent.valueForKey("from_user_id") {
                                            self.fromID[indexArr] = body as! String
                                        }
                                    }
                                }
                            }
                            dispatch_async(dispatch_get_main_queue()) {
                                self.tblProfile.reloadData()
                                self.refreshControl.endRefreshing()
                                self.topConstraint.constant = -380
                                self.didScroll = false
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
                    let json3 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if json3!["message"] != nil {
                    }
                    if json3!["result"] != nil {
                        if json3!["result"]!["mess"] != nil {
                        }
                    }
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
