//
//  CurrentSettingsViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 26/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class CurrentSettingsViewController: UIViewController {
    
    @IBOutlet var currentSettingslang: UILabel!
    @IBOutlet var btnCurrentSettings: UIButton!
    
    @IBOutlet var navBackLang:
    UIBarButtonItem!
    
    @IBOutlet var navTitle: UINavigationItem!
    
    @IBOutlet var savelang:
    UIBarButtonItem!
    var userId: String!
    var language: String!
    
    var arrText = [
        
        "en" : [
            "btnCurrentSettings": "Current settings",
            "save": "Save",
            "title" : "Language settings"
            
        ],
        "ja" : [
             "btnCurrentSettings": "現在の設定",
            "save": "保存する",
            "title" : "言語の設定"
        ]
        
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
       
        userId = globalUserId.userID
    
        //load language set.
        language = setLanguage.appLanguage
        
        //set button text..
        btnCurrentSettings.setTitle(arrText["\(language)"]!["btnCurrentSettings"], forState: .Normal)
        navTitle.title = arrText["\(language)"]!["title"]
        savelang.title = arrText["\(language)"]!["save"]
        
        self.loadCurrentUserLang()
//        self.navBackLang.action = Selector("backToConfiguration:")
        
        self.savelang.action = Selector("saveLang:")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
       self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func backToConfiguration(sender: UIBarButtonItem) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("UserTimeline") as! UserTimelineViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }

    
    func saveLang(sender: UIBarButtonItem) ->() {
        //let URL
        let viewDataURL = "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php"
        
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
        let targets = "change_lang"
        
        if language == "ja" {
            language = "jp"
        }
        
        let lang = self.currentSettingslang.text as String!
        var change_lang: String!
        if lang == "English" || lang == "英語" {
             change_lang = "en"
        } else if lang == "Japanese" || lang == "日本語"{
            change_lang = "jp"
        }
        
        //set parameters...
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "user_update",
            "d"           : "0",
            "lang"        : "\(language)",
            "user_id"     : "\(userId)",
            "change_lang" : "\(change_lang)",
            "targets"     : "\(targets)"
        ]
        
        //adding the parameters to request body
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            //user Data...
            var mess: String!
            
            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if json!["result"] != nil {
                    mess   = json!["result"]!["mess"] as! String
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                   self.displayMyAlertMessage(mess)
                }
                
            } catch {
                print(error)
            }
            
        }
        task.resume()

    }
    
    
    func loadCurrentUserLang() {
        //let URL
        let viewDataURL = "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php"
        
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
        
        if language == "ja" {
            language = "jp"
        }
        
        //set parameters...
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_userinfo",
            "d"           : "0",
            "lang"        : "\(language)",
            "user_id"     : "\(userId)"
        ]
        
        //adding the parameters to request body
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            //user Data...
            var lang: String!

            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if json!["result"] != nil {
                    lang    = json!["result"]!["lang"] as! String
                }
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if changeLang.lang == "" {
                        
                        if lang == "en" {
                            self.currentSettingslang.text = "English"
                        } else {
                            self.currentSettingslang.text = "日本語"
                        }
                        
                    } else {
                        self.currentSettingslang.text = changeLang.lang
                    }
                    
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
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
}
