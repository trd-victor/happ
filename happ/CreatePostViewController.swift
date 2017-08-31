//
//  CreatePostViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 31/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit



class CreatePostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var navBack: UIBarButtonItem!
    @IBOutlet var saveItem: UIBarButtonItem!
    @IBOutlet var saveContent: UITextField!
    @IBOutlet var content: UITextView!
    
    //basepath
    let baseUrl: NSURL = NSURL(string: "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php")!
    var language: String!

    var arrText = [
        "en": [
            "post": "Post",
            "contentPlacehoder" : "Enter posting content"
        ],
        
        "ja" : [
           "post": "投稿する",
           "contentPlacehoder" : "投稿内容を入力"
        ]
    
    ]
    
    //get usertimeline parameters...
    var getTimeline = [
        "sercret"     : "jo8nefamehisd",
        "action"      : "api",
        "ac"          : "get_timeline",
        "d"           : "0",
        "lang"        : "en",
        "user_id"     : "\(globalUserId.userID)",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load language set.
        language = setLanguage.appLanguage
        
         content.delegate = self
         content.textColor = UIColor.lightGrayColor()
        
        //set navback transition...
        self.navBack.action = Selector("dismissMe:")
        
        content.delegate = self
        self.loadConfigure()
    }

    func loadConfigure() {
        let config = SYSTEM_CONFIG()
        //set text
        saveItem.title = config.translate("button_post")
        content.text = config.translate("holder_post_content")
    }

    func dismissMe(sender: UIBarButtonItem) -> () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveItem(sender: UIBarButtonItem) {
        let body = content.text!
        let postTimeline = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "update_timeline",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "\(globalUserId.userID)",
            "body"            : "\(body)"
        ]
        //save post data
        self.savePost(postTimeline)
        
       
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if content.textColor == UIColor.lightGrayColor() {
            content.text = ""
            content.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if content.text == "" {
            content.text = arrText["\(language)"]!["contentPlacehoder"]
            content.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func savePost(parameters: [String: String]?) {
        var mess: Bool!
        let config = SYSTEM_CONFIG()
        
        
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
                let json3 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if json3!["success"] != nil {
                    mess = json3!["success"] as! Bool
                }
                NSNotificationCenter.defaultCenter().postNotificationName("refresh", object: nil, userInfo: nil)
                dispatch_async(dispatch_get_main_queue()) {
                    if mess == true {
                        self.displayMyAlertMessage(config.translate("saved_post"))
                        self.content.text = config.translate("holder_post_content")
                    }
                }
                
            } catch {
                print(error)
            }
            
        }
        task2.resume()
        
       
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
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    
}

//extension UIViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:"dismissKeyboard:")
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}
