//
//  SearchController.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/18.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var navBarTitle: UINavigationItem!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblViewSearch: UITableView!
    
    let mainView: UIView = UIView()
    
    //basepath
    let baseUrl: NSURL = NSURL(string: "https://happ.biz/wp-admin/admin-ajax.php")!
    
    let testData = [
        "Ralph1",
        "Ralph2",
        "Ralph3",
        "Ralph4",
        "Ralph5",
        "Ralph6",
        "Ralph7",
        "Ralph8"
    ]
    
    var userData = []
    
    let config = SYSTEM_CONFIG()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mainView)
        view.sendSubviewToBack(mainView)
        view.bringSubviewToFront(tblViewSearch)
        mainView.backgroundColor = UIColor.whiteColor()
        
        tblViewSearch.delegate = self
        tblViewSearch.dataSource = self
        searchBar.delegate = self
        
        
        tblViewSearch.registerClass(SearchCustomCell.self, forCellReuseIdentifier: "Users")
        tblViewSearch.separatorStyle = .None
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor(hexString: "#C9C9CE");
        searchBar.layer.borderColor = UIColor.clearColor().CGColor
        
        tblViewSearch.hidden = true
        
        loadTranslation()
        autoLayout()
        
    }
    
    func loadTranslation(){
        navBarTitle.title = config.translate("title_search_users")
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.placeholder = "Wazzup"
                }
            }
        }
    }
    
    
    @IBAction func backButton(sender: AnyObject) {
        let transition: CATransition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        if self.navBar.hidden {
            return UIStatusBarStyle.Default
        }else{
            return UIStatusBarStyle.LightContent
        }
    }
    
    var searchBarTopConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBarTopConstraint = searchBar.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor)
        searchBarTopConstraint.active = true
        searchBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        searchBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        searchBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        tblViewSearch.translatesAutoresizingMaskIntoConstraints = false
        tblViewSearch.topAnchor.constraintEqualToAnchor(searchBar.bottomAnchor).active = true
        tblViewSearch.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        tblViewSearch.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        tblViewSearch.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraintEqualToAnchor(searchBar.bottomAnchor).active = true
        mainView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mainView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        mainView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.blueColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], forState: UIControlState.Normal)
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Users", forIndexPath: indexPath) as! SearchCustomCell
        
        if let name = self.userData[indexPath.row]["name"] as? String {
            cell.textLabel?.text = name
        }else{
            cell.textLabel?.text = ""
        }
        if let skills = self.userData[indexPath.row]["skills"] as? String {
            cell.detailTextLabel?.text = skills
        }else{
            cell.detailTextLabel?.text = ""
        }
        if let imgString = self.userData[indexPath.row]["icon"] as? String {
            cell.profileImg.profileForCache(imgString)
        }else{
            cell.profileImg.image = UIImage(named: "noPhoto")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(self.userData[indexPath.row]["user_id"])
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            self.userData = []
            tblViewSearch.reloadData()
        }else{
            getSearchUser(searchText)
        }
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.navBar.hidden = true
        self.tblViewSearch.hidden = false
        searchBar.showsCancelButton = true
        
        
        let uiButton = searchBar.valueForKey("cancelButton") as! UIButton
        uiButton.setTitle("CANCEL", forState: UIControlState.Normal)
        
        
        view.backgroundColor = UIColor(hexString: "#C9C9CE")
        setNeedsStatusBarAppearanceUpdate()
        
        self.searchBar.layoutIfNeeded()
        searchBarTopConstraint.constant = -44
        self.searchBar.layoutIfNeeded()
        
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.navBar.hidden = false
        self.tblViewSearch.hidden = true
        searchBar.showsCancelButton = false
        view.backgroundColor = UIColor(hexString: "#272727")
        setNeedsStatusBarAppearanceUpdate()
        
        self.searchBar.layoutIfNeeded()
        searchBarTopConstraint.constant = 0
        self.searchBar.layoutIfNeeded()
        
        
        return true
    }
    
}