////
////  UserSearchTableViewController.swift
////  happ
////
////  Created by TokikawaTeppei on 07/08/2017.
////  Copyright © 2017 H-FUKUOKA. All rights reserved.
////
//
//import UIKit
//
//
//class searchDetails: UITableViewCell {
//    
//    @IBOutlet var userImage: UIImageView!
//    @IBOutlet var userName: UILabel!
//    @IBOutlet var userHID: UILabel!
//    @IBOutlet var userSkills: UILabel!
//}
//
//class UserSearchTableViewController: UITableViewController, UISearchResultsUpdating {
//
//
//    var name:[String] = ["Ricky","Testing", "Roy"]
//    
//    @IBOutlet var mytableview: UITableView!
//    var searchController : UISearchController!
//    var resultController = UITableViewController()
//    
//    
//    //set of parameters for user details
//    var searchName = [String]()
//    var skills =   [String?]()
//    var h_id =     [String?]()
//    var imageUrl = [String?]()
//    var imageData = NSData!()
//    var realHID = [String]()
//    var realSkill = [String]()
//    var realImage = [String]()
//    var userSearch = [SearchUser]()
//    var filterName = [SearchUser]()
//
//    
//    //get usertimeline parameters...
//    var getAllUserData = [
//        "sercret"     : "jo8nefamehisd",
//        "action"      : "api",
//        "ac"          : "user_search",
//        "d"           : "0",
//        "lang"        : "en",
//        "name"        : "",
//        "targets"     : "name"
//    ]
//    
//    let cellIdentifier = "UserCell"
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.resultController.tableView.dataSource = self
//        self.resultController.tableView.delegate = self
//        
//        self.searchController = UISearchController(searchResultsController: self.resultController)
//        self.tableView.tableHeaderView = self.searchController.searchBar
//        self.searchController.searchResultsUpdater = self
//        self.searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        
//        self.navigationController?.navigationBar.barTintColor = hexStringToUIColor("#cccccc")
//        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        self.navigationController?.navigationBar.titleTextAttributes = titleDict
//
////        self.getAllUser(self.getAllUserData)
//    
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewDidAppear(true)
//        
//    }
//    
////    func getAllUser(parameters : [String: String] ) {
////        let request = NSMutableURLRequest(URL: globalvar.API_URL)
////        let boundary = generateBoundaryString()
////        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
////        request.HTTPMethod = "POST"
////        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
////        
////        
////        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
////            data, response, error  in
////            
////            if error != nil{
////                print("\(error)")
////                return;
////            }
////            do {
////                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
////                
////                if let resultArray = json!.valueForKey("result") as? NSArray {
////                    
////                    for item in resultArray {
////                        
////                        
//////                        if let HappID = item.objectForKey("h_id")  {
//////                             self.h_id.append(HappID as? String)
//////                             self.realHID = self.h_id.map { $0 ?? ""}
//////                        }
////
////                        let userDetails :
////                            SearchUser = SearchUser (
////                                name:    (item.objectForKey("name")) as! String)
////                        
////                        self.userSearch.append(userDetails)
////                        
////                        dispatch_async(dispatch_get_main_queue()) {
////                            print(self.userSearch)
////                            self.mytableview.reloadData()
////                       }
////                    }
////                }
////            } catch {
////                print(error)
////            }
////            
////        }
////        task.resume()
////    }
////    
////    func filterContentForSearchText(searchText: String) {
////        self.filterName = self.userSearch.filter ({(userDetails: SearchUser)-> Bool in
////            return userDetails.name.lowercaseString.containsString(searchText.lowercaseString)
////        })
////
//////        self.resultController.tableView.reloadData()
////       self.mytableview.reloadData()
////    }
////    
////    func updateSearchResultsForSearchController(searchController: UISearchController) {
////      self.filterContentForSearchText(self.searchController.searchBar.text!)
////    }
////    
////    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
////        return 1
////    }
//// 
////    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        if searchController.active && searchController.searchBar.text != "" {
////            return self.filterName.count
////        }
////        return self.userSearch.count
////    }
////    
////    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
////        return 70
////    }
////    
////     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//////        let cell = self.mytableview.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! searchDetails
////        
////        let cell: searchDetails = self.mytableview.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! searchDetails
////        
//////        let radius = min(cell.userImage!.frame.width/2 , cell.userImage!.frame.height/2)
//////        cell.userImage.layer.cornerRadius = radius
//////        cell.userImage.clipsToBounds = true
////
//////        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
//////            
//////            self.imageData = NSData(contentsOfURL: NSURL(string: "\(displayUser.image[indexPath.row])")!)
//////            
//////            dispatch_async(dispatch_get_main_queue(), {() -> Void in
//////                if self.imageData != nil {
//////                    cell.userImage.image = UIImage(data: self.imageData)
//////                } else {
//////                    cell.userImage.image = UIImage(named: "photo")
//////                }
//////            })
//////        })
////        cell.hidden = true
////
////        let displayUser : SearchUser
////        
////        if searchController.active && searchController.searchBar.text != "" {
////            displayUser = self.filterName[indexPath.row]
////            cell.hidden = false
////        
////        } else {
////            displayUser = self.userSearch[indexPath.row]
////           
////        }
////        
////        cell.userName.text = displayUser.name
//////        cell.userImage.image = UIImage(named: "photo")
////        return cell
////        
////    }
//    
//    
//    func generateBoundaryString() -> String {
//        return "Boundary-\(NSUUID().UUIDString)"
//    }
//    
//    func createBodyWithParameters(parameters: [String: String]?,  boundary: String) -> NSData {
//        let body = NSMutableData();
//        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
//        
//        body.appendString("--\(boundary)--\r\n")
//        
//        return body
//    }
//    
//    func getPostID(postuserID: Int) -> Int {
//        return postuserID
//    }
//    
//    
//    func displayMyAlertMessage(userMessage:String){
//        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
//        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
//        myAlert.addAction(okAction)
//        self.presentViewController(myAlert, animated: true, completion: nil)
//    }
//}
//
//func hexStringToUIColor (hex:String) -> UIColor {
//    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
//    
//    if (cString.hasPrefix("#")) {
//        cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
//    }
//    
//    if ((cString.characters.count) != 6) {
//        return UIColor.grayColor()
//    }
//    
//    var rgbValue:UInt32 = 0
//    NSScanner(string: cString).scanHexInt(&rgbValue)
//    
//    return UIColor(
//        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//        alpha: CGFloat(1.0)
//    )
//}
//
//
