//
//  SearchUserViewTableViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 13/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

struct SearchDetailsView {
    static var searchIDuser: String!
    static var stringName : String!
    static var userEmail  : String!
    static var username : String!
    static var indicator: String!
}

class SearchUserViewTableViewController: UITableViewController, UISearchResultsUpdating {

    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    
    //get usertimeline parameters...
    var getAllUserData = [
        "sercret"     : "jo8nefamehisd",
        "action"      : "api",
        "ac"          : "user_search",
        "d"           : "0",
        "lang"        : "en",
        "name"        : "",
        "targets"     : "name"
    ]
    
    //set of parameters for user details
    var searchName = [String]()
    var skills =   [String?]()
    var h_id =     [String?]()
    var imageUrl = [String?]()
    var imageData = NSData!()
    var realHID = [String]()
    var realSkill = [String]()
    var realImage = [String]()
    var userSearch = [SearchUser]()
    var filterName = [SearchUser]()
    var FIRuserName = [String]()
    var nameForUser : String!
    var FIRID = [String]()
    var searchLang = [
        
        "en": [
            "searchPlachoder" : "Search by name or membership number",
            "title" : "Search users"
        ],
        
        "jp": [
            "searchPlachoder" : "名前もしくは会員番号で検索",
            "title" : " ユーザーの検索"
        ]
    ]
    
    var language: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //load language set.
        language = setLanguage.appLanguage
        
        self.tableView.delegate = self
        
        searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //load the data...
//        self.getAllUser(self.getAllUserData)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationItem.title = "Search"
        
        
        
        
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
//        self.getFirebaseuser()
         self.getFirebaseuser()
        
        self.loadConfigure()
        
    }
    
    func loadConfigure() {
        
        let config = SYSTEM_CONFIG()
        
        self.navigationController?.navigationBar.topItem?.title = config.translate("title_search_users")
        self.searchController.searchBar.placeholder = config.translate("button_name/membership_number")
    }
    
    func getFirebaseuser() {
        
        let userDB = FIRDatabase.database().reference().child("users")
        userDB.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            if let result = snapshot.value {
//                let name = result.objectForKey("name") as? String ?? ""
                let userID = result.objectForKey("id") as! Int
                let x: Int = userID
                let idUser = String(x)
      

                if idUser != "" {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.FIRID.append(idUser)
                        self.getAllUserInfo(self.FIRID.last!)
                        self.tableView.reloadData()
                    }
                }
            }
        })
      
 
        
    
    }
    
    func getAllUserInfo(userID: String) {
        
//        for var i = 0; i < userID!.count; i++ {
        
            let request1 = NSMutableURLRequest(URL: globalvar.API_URL)
            let boundary1 = generateBoundaryString()
            request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
            request1.HTTPMethod = "POST"
            
            let parameters = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "get_userinfo",
                "d"           : "0",
                "lang"        : "en",
                "user_id"     : "\(userID)"
            ]
            
            request1.HTTPBody = createBodyWithParameters(parameters, boundary: boundary1)
            let task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1){
                data1, response1, error1 in
                
                if error1 != nil{
                    print("\(error1)")
                    return;
                }
                do {
                    let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if json2!["error"] == nil {
                        
                        let skills = json2!["result"]!["skills"] as? String ?? ""
                        let happID = json2!["result"]!["h_id"] as? String ?? ""
                        let userID = json2!["result"]!["user_id"] as! Int
                        let name = json2!["result"]!["name"] as? String ?? ""
                        let email = json2!["result"]!["email"] as? String ?? ""
                        let image = json2!["result"]!["icon"] as? String ?? ""
                        
                        let userDetails :
                        SearchUser = SearchUser (
                            name : name,
                            HappID: happID,
                            skills:  skills,
                            image:  image,
                            userID:  userID,
                            email: email
                        )
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.userSearch.append(userDetails)
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print(error)
                }
            }
            
            task2.resume()
    }

    func filterContentForSearchText(searchText: String) {
        self.filterName = self.userSearch.filter { SearchUser in
            return SearchUser.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        self.tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.filterContentForSearchText(self.searchController.searchBar.text!)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return self.filterName.count
        }
        return self.userSearch.count
    }

    let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 4.0, alpha: 4.0)
        return view
    }()
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SearchCellTableViewCell
        let radius = min(cell.imageuser!.frame.width/2 , cell.imageuser!.frame.height/2)
        cell.imageuser.layer.cornerRadius = radius
        cell.imageuser.clipsToBounds = true
        cell.hidden = true
        
        let displayUser: SearchUser
        
        if searchController.active && searchController.searchBar.text != "" {
            displayUser = self.filterName[indexPath.row]
            cell.hidden = false
        } else {
            displayUser = self.userSearch[indexPath.row]
        }
        
        cell.nameuser.text = displayUser.name
        cell.secondname.text = displayUser.HappID
        
        
        cell.skills.text = displayUser.skills
        
        cell.skills.translatesAutoresizingMaskIntoConstraints = false
        cell.skills.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor, constant: 30).active = true
        cell.skills.leftAnchor.constraintEqualToAnchor(cell.imageuser.rightAnchor, constant: 5).active = true
        cell.skills.widthAnchor.constraintEqualToConstant(cell.contentView.frame.size.width - 65).active = true
        cell.skills.lineBreakMode = .ByTruncatingTail
        cell.skills.numberOfLines = 0
        cell.skills.sizeToFit()
        
        
        cell.separator.translatesAutoresizingMaskIntoConstraints = false
        cell.separator.bottomAnchor.constraintEqualToAnchor(cell.contentView.bottomAnchor, constant: -5).active = true
        cell.separator.leftAnchor.constraintEqualToAnchor(cell.contentView.leftAnchor, constant: 55).active = true
        cell.separator.widthAnchor.constraintEqualToConstant(cell.contentView.frame.size.width - 65).active = true
        cell.separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
            
            let url = displayUser.image.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            self.imageData = NSData(contentsOfURL: NSURL(string: "\(url)")!)
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                if self.imageData != nil {
                    cell.imageuser.image = UIImage(data: self.imageData)
                } else {
                    cell.imageuser.image = UIImage(named: "photo")
                }
            })
        })
        
        cell.skills.numberOfLines = 0
        cell.skills.sizeToFit()
        return cell

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let displayUser: SearchUser
        
        if searchController.active && searchController.searchBar.text != "" {
            displayUser = self.filterName[indexPath.row]
        } else {
            displayUser = self.userSearch[indexPath.row]
        }
        let x: Int = displayUser.userID
        let idUser = String(x)
        
        SearchDetailsView.searchIDuser = idUser
        SearchDetailsView.userEmail = displayUser.email
        SearchDetailsView.username  = displayUser.name
        chatVar.Indicator = "Search"
        
        globalvar.userTitle = displayUser.name
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
    
    func getPostID(postuserID: Int) -> Int {
        return postuserID
    }
    
    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
}
