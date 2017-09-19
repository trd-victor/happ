//
//  TimelineViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 19/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    @IBOutlet var loadData: UIButton!
    @IBOutlet var userID: UITextField!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userSkills: UILabel!
    @IBOutlet var userMesage: UILabel!

    @IBOutlet var userImageView: UIImageView!
    //user_id
    var userId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.loadUserData()
         self.setRounded(userImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func loadUserData() {
        //get userId from the login controller
        userId = globalUserId.userID
        
        //let URL
        let viewDataURL = "https://happ.biz/wp-admin/admin-ajax.php"
        
        //created NSURL
        let requestURL = NSURL(string: viewDataURL)
        
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(URL: requestURL!)
        
        //set boundary string..
        let boundary = generateBoundaryString()
        
        //set value for image upload
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //setting the method to post
        request.HTTPMethod = "POST"
        
//        if language == "ja" {
//            language = "jp"
//        }
//        set parameters...
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_userinfo",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(userId)"
        ]
        
        
//        adding the parameters to request body
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            //user Data...
            var name: String!
            var image: String!
            var skills: String!
            var message: String!
            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if json!["result"] != nil {
                    name    = json!["result"]!["name"] as! String
                    image   = json!["result"]!["icon"] as! String
                    skills  = json!["result"]!["skills"] as! String
                    message = json!["result"]!["mess"] as! String
                }
                dispatch_async(dispatch_get_main_queue()) {
                    let data = NSData(contentsOfURL: NSURL(string: "\(image)")!)
                    self.userName.text = name
                    self.userImageView.image = UIImage(data: data!)
                    self.userSkills.text = skills
                    self.userMesage.text = message
                }
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
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
    
    func setRounded(sender: UIImageView) {
        let radius = min(sender.frame.width/2 , sender.frame.height/2)
        sender.layer.cornerRadius = radius
        sender.clipsToBounds = true
    }

}


