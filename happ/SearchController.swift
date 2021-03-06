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
    let baseUrl: NSURL = globalvar.API_URL
    
    var user_id = [Int]()
    var userData = []
    var task2: NSURLSessionDataTask!
    
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

        tblViewSearch.contentInset = UIEdgeInsetsMake(0, 0, 280, 0)
        
        tblViewSearch.registerClass(SearchCustomCell.self, forCellReuseIdentifier: "Users")
        tblViewSearch.separatorStyle = .None
        
        searchBar.backgroundImage = UIImage()
        searchBar.backgroundColor = UIColor(hexString: "#C9C9CE");
        searchBar.layer.borderColor = UIColor.clearColor().CGColor
        
        tblViewSearch.hidden = true
        
        loadTranslation()
        autoLayout()
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeBackTimeline:");
        swipeRight.direction = .Right
        
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func swipeBackTimeline(sender: UISwipeGestureRecognizer){
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], forState: UIControlState.Normal)
        
        let transition: CATransition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func loadTranslation(){
        
        navBarTitle.title = config.translate("title_search_users")
        for subView in searchBar.subviews  {
            for subsubView in subView.subviews  {
                if let textField = subsubView as? UITextField {
                    textField.placeholder = config.translate("search_placeholder")
                }
            }
        }
    }
    
    
    @IBAction func backButton(sender: AnyObject) {
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], forState: UIControlState.Normal)
        
        let transition: CATransition = CATransition()
        transition.duration = 0.40
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
        
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor(hexString: "#0076FF")]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], forState: UIControlState.Normal)
        
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.navBar.hidden = false
        self.tblViewSearch.hidden = true
        searchBar.showsCancelButton = false
        view.backgroundColor = UIColor(hexString: "#272727")
        setNeedsStatusBarAppearanceUpdate()
        
        self.searchBar.layoutIfNeeded()
        searchBarTopConstraint.constant = 0
        self.searchBar.layoutIfNeeded()
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

    let imgforProfileCache = NSCache()

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Users", forIndexPath: indexPath) as! SearchCustomCell
        
        if let name = self.userData[indexPath.row]["name"] as? String {
            cell.textLabel?.text = name
        }else{
            cell.textLabel?.text = ""
        }
        
        if let h_id = self.userData[indexPath.row]["h_id"] as? String {
            cell.happId.text = h_id
        }
        
        cell.detailTextLabel?.text = ""
        if let skills = self.userData[indexPath.row]["skills"] as? String {
            var skill = ""
            var count = 0
            if skills != "null" {
                let all_skills = skills.characters.split(",")
                for (value) in all_skills {
                    count++
                    skill = skill + config.getSkillByID(String(value))
                    if count == all_skills.count {
                        cell.detailTextLabel?.text = skill
                    }else{
                        skill = skill + ", "
                    }
                }
            }else{
                cell.detailTextLabel?.text = ""
            }
        }else{
            cell.detailTextLabel?.text = ""
        }

        if let imgString = self.userData[indexPath.row]["icon"] as? String {
            if imgString == "" || imgString == "null" {
                cell.profileImg.image = UIImage(named: "noPhoto")
            }else{
                cell.profileImg.loadProfileImageUsingString(imgString){
                    (result: Bool) in
                }
            }
        }else{
            cell.profileImg.image = UIImage(named: "noPhoto")
        }
        
        if let id = self.userData[indexPath.row]["user_id"] as? Int {
            user_id.append(id)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if menu_bar.sessionDeleted {
            let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], forState: UIControlState.Normal)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("UserProfile") as! UserProfileController
        let transition = CATransition()
        
        UserProfile.id = String(user_id[indexPath.row])
        
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        presentViewController(vc, animated: false, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        user_id.removeAll()
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
        uiButton.setTitle(config.translate("btn_cancel"), forState: UIControlState.Normal)
         uiButton.setTitleColor(UIColor(hexString: "#0076FF"), forState: .Normal)
        
        view.backgroundColor = UIColor(hexString: "#C9C9CE")
        setNeedsStatusBarAppearanceUpdate()
        
        self.searchBar.layoutIfNeeded()
        searchBarTopConstraint.constant = -44
        self.searchBar.layoutIfNeeded()
        
        return true
    }
    
}
