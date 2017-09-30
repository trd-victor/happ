//
//  TableViewExtension.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/20.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import Foundation

extension UserProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func getTimelineUser() {
        
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
            
            if error != nil || data == nil{
                self.getTimelineUser()
            }else{
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if let resultArray = json!.valueForKey("result") as? NSArray {
                        
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
                                    if let id = postContent.valueForKey("from_user_id") {
                                        self.fromID.append(id as! String)
                                    }
                                    
                                   
                                }
                            }
                            
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        self.tblProfile.reloadData()
                        self.refreshControl.endRefreshing()
                        self.topConstraint.constant = -380
                        self.didScroll = false
                    }
                } catch {
                    print(error)
                }

            }
        }
        task.resume()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fromID.count
    }
    
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
//            cell.btnUsername.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            cell.btnUsername.tag = Int(self.fromID[indexPath.row])!
            cell.detailTextLabel?.addGestureRecognizer(bodyTap)
            cell.detailTextLabel?.text = String(self.userBody[indexPath.row])
            
            if userimageURL == "null" {
                imgView.image = UIImage(named: "noPhoto")
            }else {
                imgView.profileForCache(userimageURL)
            }
            cell.btnProfile.setImage(imgView.image, forState: .Normal)
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
//            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.profileImg.tag = Int(self.fromID[indexPath.row])!
            cell.postDate.text = self.postDate[indexPath.row]
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            cell.imgView1.imgForCache(self.img1[indexPath.row])
            cell.imgView2.imgForCache(self.img2[indexPath.row])
            cell.imgView3.imgForCache(self.img3[indexPath.row])
            cell.imgContainer.addGestureRecognizer(imgTap)
            
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
//            cell.btnUsername.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            cell.btnUsername.tag = Int(self.fromID[indexPath.row])!
            cell.detailTextLabel?.addGestureRecognizer(bodyTap)
            cell.detailTextLabel?.text = String(self.userBody[indexPath.row])
            
            if userimageURL == "null" {
                imgView.image = UIImage(named: "noPhoto")
            }else {
                imgView.profileForCache(userimageURL)
            }
            cell.btnProfile.setImage(imgView.image, forState: .Normal)
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
//            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.postDate.text = self.postDate[indexPath.row]
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            cell.imgView1.imgForCache(self.img1[indexPath.row])
            cell.imgView2.imgForCache(self.img2[indexPath.row])
            cell.imgContainer.addGestureRecognizer(imgTap)
            
            
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
//            cell.btnUsername.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            cell.btnUsername.tag = Int(self.fromID[indexPath.row])!
            cell.detailTextLabel?.addGestureRecognizer(bodyTap)
            cell.detailTextLabel?.text = String(self.userBody[indexPath.row])
            
            if userimageURL == "null" {
                imgView.image = UIImage(named: "noPhoto")
            }else {
                imgView.profileForCache(userimageURL)
            }
            cell.btnProfile.setImage(imgView.image, forState: .Normal)
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
//            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
            cell.postDate.text = self.postDate[indexPath.row]
            cell.btnDelete.setTitle(String(self.postID[indexPath.row]), forState: .Normal)
            cell.btnDelete.setImage(UIImage(named: "blackMore"), forState: .Normal)
            cell.btnDelete.addTarget(self, action: "clickMoreImage:", forControlEvents: .TouchUpInside)
            cell.btnDelete.tag = indexPath.row
            cell.imgView1.imgForCache(self.img1[indexPath.row])
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
//            cell.btnUsername.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            cell.btnUsername.tag = Int(self.fromID[indexPath.row])!
            cell.detailTextLabel?.addGestureRecognizer(bodyTap)
            cell.detailTextLabel?.text = String(self.userBody[indexPath.row])
            
            if userimageURL == "null" {
                imgView.image = UIImage(named: "noPhoto")
            }else {
                imgView.profileForCache(userimageURL)
            }
            cell.btnProfile.setImage(imgView.image, forState: .Normal)
            cell.btnProfile.tag = Int(self.fromID[indexPath.row])!
//            cell.btnProfile.addTarget(self, action: "viewProfile:", forControlEvents: .TouchUpInside)
            
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
            let tapLocation = sender.locationInView(self.tblProfile)
            if let indexPath = self.tblProfile.indexPathForRowAtPoint(tapLocation) {
                
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

    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height: CGFloat = 90
        let textsize = calcTextHeight(self.userBody[indexPath.row], frame: tableView.frame.size, fontsize: 16)
        height += textsize.height
        if self.img1[indexPath.row] != "null" {
            height += 320
        }
        
        return height
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