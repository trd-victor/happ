//
//  ExtensionTimeline.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/10.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

extension UserTimelineViewController {

    func reloadTimeline() {
        
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
                self.reloadTimeline()
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
                                            tmpuserBody.append( body as! String )
                                        }
                                        if let body = postContent.valueForKey("from_user_id") {
                                            tmpfromID.append( body as! String )
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
                                    
                                    self.refreshControl.endRefreshing()
                                    self.mytableview.reloadData()
                                    if self.loadingData {
                                        self.loadingData = false
                                    }
                                    if self.scrollLoad {
                                        self.scrollLoad = false
                                    }
                                    
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

    func updateFreeTimeStatus(){
        let parameters = [
            "sercret"          : "jo8nefamehisd",
            "action"           : "api",
            "ac"               : "update_freetime_status",
            "d"                : "0",
            "lang"             : "en",
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
                self.updateFreeTimeStatus()
            }
        }
        task.resume()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}