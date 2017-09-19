//
//  CustomViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 07/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var mytableview: UITableView!
    
    var result = [NSArray]()
    var postID = [Int]()
    var postDate = [String]()
    var userBody = [String]()
    var fromID = [String]()
    var data: NSData!
    var username: String!
    var imgURL: String!
    
    //basepath
    let baseUrl: NSURL = NSURL(string: "https://happ.biz/wp-admin/admin-ajax.php")!
    
    var animals : [String] = ["Dogs", "cat", "lion", "Zebra", "cow","mouse", "tiger", "carabao", "goat", "mice"]
    
    //get usertimeline parameters...
    var getTimeline = [
        "sercret"     : "jo8nefamehisd",
        "action"      : "api",
        "ac"          : "get_timeline",
        "d"           : "0",
        "lang"        : "en",
        "user_id"     : "2",
        "page"        : "",
        "count"       : "",
        "skills"      : ""
    ]
    
    //get user data
    var userDataImage = [
        "sercret"     : "jo8nefamehisd",
        "action"      : "api",
        "ac"          : "get_userinfo",
        "d"           : "0",
        "lang"        : "en",
        "user_id"     : "2"
    ]
    
    let cellSpacingHeight: CGFloat = 5

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.mytableview.delegate = self
        self.mytableview.dataSource = self
        
        self.getTimelineUser(self.getTimeline)
        self.getUserinfo(self.userDataImage)
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
                    print(mess)
                    //                    self.getTimelineUser(self.getTimeline)
                    self.mytableview.reloadData()
                }
                
            } catch {
                print(error)
            }
            
        }
        task2.resume()
        
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
                        dispatch_async(dispatch_get_main_queue()) {
                            self.mytableview.reloadData()
                        }
                        
                    }
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func getUserinfo(parameters: [String: String]?) {
        var name: String!
        
        let request1 = NSMutableURLRequest(URL: self.baseUrl)
        let boundary1 = generateBoundaryString()
        request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
        request1.HTTPMethod = "POST"
        
        
        request1.HTTPBody = createBodyWithParameters(parameters, boundary: boundary1)
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1){
            data1, response1, error1 in
            
            if error1 != nil{
                print("\(error1)")
                return;
            }
            do {
                let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                let results = json2!["result"] as! NSDictionary
                name = results["name"] as! String
                self.imgURL = results["icon"] as! String
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.data = NSData(contentsOfURL: NSURL(string: "\(self.imgURL)")!)
                    self.username = name
                }
                
            } catch {
                print(error)
            }
            
        }
        task2.resume()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postID.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.mytableview.dequeueReusableCellWithIdentifier("RowCell", forIndexPath: indexPath) as! MyCustomTableViewCell
        
        cell.id.setTitle("\(self.postID[indexPath.row])", forState: .Normal)
        cell.delte.tag = indexPath.row
        cell.delte.setTitle("\(self.postID[indexPath.row])", forState: .Normal)
        cell.delte.addTarget(self, action: "removeID:", forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func removeID(sender: UIButton) {
        let senderID = sender.tag
        let userPostID = sender.titleLabel!.text!
        
        self.deleteTimeline(userPostID)
        
        let indexPath = NSIndexPath(forRow: senderID, inSection: 0)
        self.mytableview.beginUpdates()
        self.postID.removeAtIndex(indexPath.row)
        self.mytableview.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        self.mytableview.endUpdates()
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
