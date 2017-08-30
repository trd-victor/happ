//
//  TestTimelineTableViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 07/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class userID : UITableViewCell {
    
    @IBOutlet var userpostID: UIButton!
    @IBOutlet var delete: UIButton!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var postModified: UILabel!
    @IBOutlet var userPostcontent: UITextView!
    
    
    
}

class TestTimelineTableViewController: UITableViewController {

    
    var result = [NSArray]()
    var postID = [Int]()
    var postDate = [String]()
    var userBody = [String]()
    var fromID = [String]()
    var data: NSData!
    var username: String!
    var imgURL: String!
    //basepath
    let baseUrl: NSURL = NSURL(string: "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php")!
    
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
        self.getTimelineUser(self.getTimeline)
        self.getUserinfo(self.userDataImage)
        
//        if let resultController = storyboard!.instantiateViewControllerWithIdentifier("Timeline") as? UserSearchTableViewController {
//            let navController = UINavigationController(rootViewController: resultController) // Creating a navigation controller with resultController at the root of the navigation stack.
//            navController.navigationBar.backgroundColor = UIColor.blueColor()
//            self.presentViewController(navController, animated:true, completion: nil)
//        }
        
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
                   self.tableView.reloadData()
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
                            self.tableView.reloadData()
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
        
        
        request1.HTTPBody = createBodyWithParameters(self.userDataImage, boundary: boundary1)
        let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1){
            data1, response1, error1 in
            
            if error1 != nil{
                print("\(error1)")
                return;
            }
            do {
                let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                print(json2)
                
                let results = json2!["result"] as! NSDictionary
                name = results["name"] as! String
                self.imgURL = results["icon"] as! String
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.data = NSData(contentsOfURL: NSURL(string: "\(self.imgURL)")!)
                    self.username = name
//                    print(self.imgURL)
                }
                
            } catch {
                print(error)
            }
            
        }
        task2.resume()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postID.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Rowcell", forIndexPath: indexPath) as! userID
        
        
        let radius = min(cell.userImage.frame.width/2 , cell.userImage.frame.height/2)
        cell.userImage.layer.cornerRadius = radius
        cell.userImage.clipsToBounds = true
        
        if self.data != nil {
            cell.userImage.image = UIImage(data: self.data!)
        }
        
        cell.userPostcontent.editable = false
        cell.userName.text = self.username
        cell.userpostID.setTitle("\(self.postID[indexPath.row])", forState: .Normal)
        cell.userPostcontent.text = self.userBody[indexPath.row]
        cell.delete.addTarget(self, action: "remove:", forControlEvents: .TouchUpInside)
        cell.delete.tag = indexPath.row
        cell.delete.setTitle("\(self.postID[indexPath.row])", forState: .Normal)
        cell.postModified.text = self.postDate[indexPath.row]
        
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func remove(sender: UIButton) {
        let senderTag = sender.tag
        let title = sender.titleLabel?.text!
        
        self.deleteTimeline(title!)
        
        let indexPath = NSIndexPath(forRow: senderTag, inSection: 0)
        self.tableView.beginUpdates()
        self.postID.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        self.tableView.endUpdates()
        
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height))
        
        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 1.0
        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubviewToBack(whiteRoundedView)

    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            self.postID.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
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
