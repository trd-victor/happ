//
//  CongestionViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 14/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit


class UserCollectionView : UICollectionViewCell {

    @IBOutlet var Username: UILabel!
    @IBOutlet var userImage: UIImageView!
    
}


class CongestionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let reuseIdentifier = "cell"
    var items = ["1", "2", "3", "4"]
    var language: String!
    var getPercent: String!
    var congestionSettings = [
    
        "en" : [
            "CongestionTitle" : "Situation",
            "CongestSituation" : "Congestion situation",
            "CongestionFree" : "Now I am free"
        
        ],
        "jp" : [
            "CongestionTitle" : "状況",
            "CongestSituation" : "混雑状況",
            "CongestionFree" : "いま暇"
        ]
    ]
    
    //set of label string...
    @IBOutlet var situation: UILabel!
    @IBOutlet var percentage: UILabel!
    @IBOutlet var freestatus: UILabel!
    @IBOutlet var congestiontitle: UINavigationItem!
    
    
    var userID: String!
    var user_id = [String]()
    var username = [String]()
    var testName: String!
    var userEachImage = [String]()
    var realImage = [String]()
    var urlImage : String!
    var data: NSData!
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load language set.
        language = setLanguage.appLanguage
        
        //get user id...
        userID = globalUserId.userID
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        //set title and text accdg. to language set....
        self.congestiontitle.title = congestionSettings["\(language)"]!["CongestionTitle"]
        self.situation.text = congestionSettings["\(language)"]!["CongestSituation"]
        self.freestatus.text = congestionSettings["\(language)"]!["CongestionFree"]
        
        //set static office id 
        let office_id = 32
        
        self.getCongestionPercentage(office_id)
        
        
        
        let userFreetime = NSUserDefaults.standardUserDefaults().objectForKey("Freetime") as? String
        
        if userFreetime == "On" {
            self.getFreeTimeStatusUser(userID)
        }
        
        
        
    }
    
    func getCongestionPercentage(sender: Int) {
       
        //set parameter for
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "\(globalvar.GET_CONGESTION_ACTION)",
            "d"           : "0",
            "lang"        : "jp",
            "office_id"   : "\(sender)"
        ]
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                
                if json!["result"] != nil {
                   let result = json!["result"] as! NSArray
                    
                    for item in result {
                        if let resultData = item as? NSDictionary {
                         
                            if let fields = resultData.valueForKey("fields") {
                                if let percent = fields.valueForKey("persentage") {
                                    self.getPercent = percent as! String
                                }
                            }
                            
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    let percentString = "%"
                    self.percentage.text = self.getPercent + percentString
                }
            
            } catch {
                print(error)
            }
            
        }
        task.resume()

    }
    func getFreeTimeStatusUser(sender: String) {
    
        //set parameter for
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "\(globalvar.GET_FREETIME_STATUS_ACTION)",
            "d"           : "0",
            "lang"        : "en",
            "user_id"     : "sender",
            "office_id"   : "32",
            "status_key"   : "freetime"
        ]
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
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
                            
                            if let postContent = resultDict.valueForKey("fields")  {
                                
                                if let userId = postContent.valueForKey("user_id") {
                                    self.user_id.append(userId as! String)
//                                   print(self.user_id)
                                }
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView.reloadData()
                        }
                    }
                }
                self.getAllUserInfo(self.user_id)
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
    func getAllUserInfo(userID: [String]?) {
        
        for var i = 0; i < userID!.count; i++ {
            let parameters = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "get_userinfo",
                "d"           : "0",
                "lang"        : "en",
                "user_id"     : "\(userID![i])"
            ]
            
            let httpRequest = HttpDataRequest(postData: parameters)
            let request = httpRequest.requestGet()
            

            let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data1, response1, error1 in
                
//                var imageuser : String!
                
                if error1 != nil{
                    print("\(error1)")
                    return;
                }
                do {
                    let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
//                    print(json2!)
                    
                    self.testName = json2!["result"]!["name"] as! String
                    
                    if let imageuser = json2!["result"]!["icon"] as? NSNull {
                        self.urlImage = "" as? String
                    } else {
                        self.urlImage = json2!["result"]!["icon"] as? String
                    }
                    
                    self.userEachImage.append(self.urlImage)
                    self.realImage = self.userEachImage.map{ $0 ?? ""}
                    self.username.append(self.testName)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.collectionView.reloadData()
                    }
                    
                } catch {
                    print(error)
                }
            }
            
            task2.resume()
        }
        
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.username.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserCollectionView
        
        
        let radius = min(cell.userImage!.frame.width/2 , cell.userImage!.frame.height/2)
        cell.userImage!.layer.cornerRadius = radius
        cell.userImage!.clipsToBounds = true
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {() -> Void in
            
            self.data = NSData(contentsOfURL: NSURL(string: "\(self.realImage[indexPath.item])")!)
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                
                if self.data != nil {
                    cell.userImage.image = UIImage(data: self.data!)
                } else {
                    cell.userImage.image = nil
                }
            })
        })
        
        cell.Username.text = self.username[indexPath.item]
        
        return cell
        
    }
    
}
