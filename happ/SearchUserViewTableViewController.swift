//
//  SearchUserViewTableViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 13/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

struct SearchDetailsView {
    static var searchIDuser: String!
    static var stringName : String!
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
        
        
        self.getAllUser(self.getAllUserData)
            
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationItem.title = "Search"
        
        self.navigationController?.navigationBar.topItem?.title = searchLang["\(language)"]!["title"]
        self.searchController.searchBar.placeholder = searchLang["\(language)"]!["searchPlachoder"]
        
        
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
//        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        
    }

    
    func getAllUser(parameters : [String: String] ) {
        let request = NSMutableURLRequest(URL: globalvar.API_URL)
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
                        
                        
                        let userDetails :
                        SearchUser = SearchUser (
                            name   :  (item.objectForKey("name")) as! String,
                            HappID :  (item.objectForKey("h_id")) as? String ?? "",
                            skills :  (item.objectForKey("skills")) as? String ?? "",
                            image  :  (item.objectForKey("icon")) as? String ?? "",
                            userID :  ((item.objectForKey("user_id")) as? Int)!
                        )
                        
                        self.userSearch.append(userDetails)
                        
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
//            SearchDetailsView.searchIDuser = self.filterName[indexPath.row]
        } else {
            displayUser = self.userSearch[indexPath.row]
        }
        
      
//        SearchDetailsView.searchIDuser = displayUser.name
        cell.nameuser.text = displayUser.name
        cell.secondname.text = displayUser.HappID
        cell.skills.text = displayUser.skills
//        cell.userID.text = idUser
     
        
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
