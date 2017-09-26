//
//  ExtensionTimeline.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/10.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

extension UserTimelineViewController {

    func reloadTimeline() {
        
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
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    var indexArr:Int = -1
                    
                    if let resultArray = json!.valueForKey("result") as? NSArray {
                        
                        for item in resultArray {
                            
                            indexArr += 1
                            
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
                            
                            
                            dispatch_async(dispatch_get_main_queue()) {
                                self.mytableview.reloadData()
                                if self.loadingData {
                                    self.loadingData = false
                                }
                                self.refreshControl.endRefreshing()
                                if self.scrollLoad {
                                    self.scrollLoad = false
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
            
            if error != nil{
                print("\(error)")
                return;
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