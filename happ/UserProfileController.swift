//
//  UserProfileController.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/19.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

struct UserProfile {
    static var id:String = ""
    static var h_id: String = ""
    static var name: String = ""
    static var profileImg: String = ""
    static var skills: String = ""
    static var msg: String = ""
}

class UserProfileController: UIViewController {
    
    var img1 = [String]()
    var img2 = [String]()
    var img3 = [String]()
    var userBody = [String]()
    var fromID = [String]()
    var postDate = [String]()
    var postID = [Int]()
    var page: Int = 1
    var firstLoad: Bool = false
    var loadingScreen: UIView!
    let baseUrl: NSURL = globalvar.API_URL
    var noData: Bool = false
    var loadingData: Bool = false
    
    let btmRefresh: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.color = UIColor.grayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ProfileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let ProfileImage: UIImageView = {
        let imgview = UIImageView()
        imgview.translatesAutoresizingMaskIntoConstraints = false
        imgview.image = UIImage(named: "noPhoto")
        imgview.layer.cornerRadius = 50
        imgview.clipsToBounds = true
        imgview.contentMode = .ScaleAspectFill
        return imgview
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(16)
        label.textAlignment = .Center
        return label
    }()
    
    let h_id: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        return label
    }()
    
    let skills: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        label.sizeToFit()
        return label
    }()
    
    let msg: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.blackColor()
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let btnMessage: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(hexString: "#272727")
        btn.setImage(UIImage(named: "msg"), forState: .Normal)
        return btn
    }()
    
    let btnBlock: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor(hexString: "#272727")
        btn.setImage(UIImage(named: "block"), forState: .Normal)
        btn.tag = 0
        return btn
    }()
    
    @IBOutlet var happLogo: UIImageView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var navBack: UIBarButtonItem!
    @IBOutlet var tblProfile: UITableView!
    
    let topReload: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        view.color = UIColor.grayColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var topConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        btnMessage.addTarget(self, action: Selector("openMessage"), forControlEvents: .TouchUpInside)
        
        tblProfile.registerClass(NoImage.self, forCellReuseIdentifier: "NoImage")
        tblProfile.registerClass(SingleImage.self, forCellReuseIdentifier: "SingleImage")
        tblProfile.registerClass(DoubleImage.self, forCellReuseIdentifier: "DoubleImage")
        tblProfile.registerClass(TripleImage.self, forCellReuseIdentifier: "TripleImage")
        
        userName.text = ""
        h_id.text = ""
        skills.text = ""
        msg.text = ""
        ProfileImage.image = UIImage(named: "noPhoto")
        
        dispatch_async(dispatch_get_main_queue()){
            self.loadUserinfo(UserProfile.id)
        }
        
        tblProfile.addSubview(btmRefresh)
        tblProfile.addSubview(ProfileView)
        tblProfile.addSubview(topReload)
        tblProfile.bringSubviewToFront(topReload)
        ProfileView.addSubview(ProfileImage)
        ProfileView.addSubview(userName)
        ProfileView.addSubview(h_id)
        ProfileView.addSubview(skills)
        ProfileView.addSubview(msg)
        ProfileView.addSubview(btnMessage)
        ProfileView.addSubview(btnBlock)
        
        topReload.startAnimating()
        
        tblProfile.separatorStyle = .None
        tblProfile.backgroundColor = UIColor(hexString: "#E4D4B9")
        
        tblProfile.delegate = self
        tblProfile.dataSource = self
        
        translate()
        
        getBlockIds()
        
        tblProfile.contentInset = UIEdgeInsetsMake(380, 0, 0, 0)
        
        btnBlock.addTarget(self, action: "profileBlock:", forControlEvents: .TouchUpInside)
        
        if UserProfile.id == globalUserId.userID {
            btnMessage.hidden = true
            btnBlock.hidden = true
        }
        
        autoLayout()
        self.tblProfile.allowsSelection = false;
        
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
    
    func openMessage(){
        let vc = ViewLibViewController()
        self.presentViewController(vc, animated: false, completion: nil)
    }
    
    func profileBlock(sender: UIButton!){
        let config = SYSTEM_CONFIG()
        
        if sender.tag == 0 {
            self.blockUser(){
                (done: Bool) in
                if done {
                    self.btnBlock.backgroundColor = UIColor(hexString: "#E2041B")
                    self.btnBlock.setTitle(config.translate("button_unblock"), forState: .Normal)
                    self.btnBlock.tag = 1
                }
            }
        }else{
            unblockUser(){
                (complete: Bool) in
                if complete {
                    self.btnBlock.backgroundColor = UIColor(hexString: "#272727")
                    self.btnBlock.setTitle(config.translate("to_block"), forState: .Normal)
                    self.btnBlock.tag = 0
                }
            }
        }
    }
    
    var didScroll:Bool = false
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == tblProfile {
            if scrollView.contentOffset.y < -440 {
                self.page = 1
                didScroll = true
                if self.loadingData {
                    self.loadingData = false
                }
                
                topReload.startAnimating()
                for var i = 5; i < self.fromID.count; i++ {
                    let indexPath = NSIndexPath(forRow: i, inSection: 0)
                    self.tblProfile.beginUpdates()
                    self.tblProfile.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                    self.userBody.removeAtIndex(i)
                    self.postDate.removeAtIndex(i)
                    self.postID.removeAtIndex(i)
                    self.fromID.removeAtIndex(i)
                    self.img1.removeAtIndex(i)
                    self.img2.removeAtIndex(i)
                    self.img3.removeAtIndex(i)
                    self.tblProfile.endUpdates()
                }
                reloadData()
            }
        }
    }
    
    func translate(){
        let config = SYSTEM_CONFIG()
        btnMessage.setTitle(config.translate("menu_message"), forState: .Normal)
        btnBlock.setTitle(config.translate("to_block"), forState: .Normal)
    }
    
    func autoLayout() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        happLogo.translatesAutoresizingMaskIntoConstraints = false
        happLogo.centerXAnchor.constraintEqualToAnchor(navBar.centerXAnchor).active = true
        happLogo.centerYAnchor.constraintEqualToAnchor(navBar.centerYAnchor).active = true
        happLogo.widthAnchor.constraintEqualToConstant(84).active = true
        happLogo.heightAnchor.constraintEqualToConstant(33).active = true
        
        tblProfile.translatesAutoresizingMaskIntoConstraints = false
        tblProfile.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        tblProfile.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        tblProfile.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        tblProfile.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        
        topConstraint = ProfileView.topAnchor.constraintEqualToAnchor(tblProfile.topAnchor, constant: -380)
        topConstraint.active = true
        ProfileView.centerXAnchor.constraintEqualToAnchor(tblProfile.centerXAnchor).active = true
        ProfileView.widthAnchor.constraintEqualToAnchor(tblProfile.widthAnchor).active = true
        ProfileView.heightAnchor.constraintEqualToConstant(380).active = true
        ProfileView.backgroundColor = UIColor(hexString: "#E4D4B9")
        
        topReload.topAnchor.constraintEqualToAnchor(ProfileView.bottomAnchor, constant: -50).active = true
        topReload.centerXAnchor.constraintEqualToAnchor(tblProfile.centerXAnchor).active = true
        topReload.widthAnchor.constraintEqualToAnchor(tblProfile.widthAnchor).active = true
        topReload.heightAnchor.constraintEqualToConstant(50).active = true
        
        ProfileImage.topAnchor.constraintEqualToAnchor(ProfileView.topAnchor, constant: 10).active = true
        ProfileImage.centerXAnchor.constraintEqualToAnchor(ProfileView.centerXAnchor).active = true
        ProfileImage.widthAnchor.constraintEqualToConstant(100).active = true
        ProfileImage.heightAnchor.constraintEqualToConstant(100).active = true
        
        userName.topAnchor.constraintEqualToAnchor(ProfileImage.bottomAnchor, constant: 5).active = true
        userName.centerXAnchor.constraintEqualToAnchor(ProfileView.centerXAnchor).active = true
        userName.widthAnchor.constraintEqualToAnchor(ProfileView.widthAnchor).active = true
        userName.heightAnchor.constraintEqualToConstant(15).active = true
        
        h_id.topAnchor.constraintEqualToAnchor(userName.bottomAnchor, constant: 5).active = true
        h_id.centerXAnchor.constraintEqualToAnchor(ProfileView.centerXAnchor).active = true
        h_id.widthAnchor.constraintEqualToAnchor(ProfileView.widthAnchor).active = true
        h_id.heightAnchor.constraintEqualToConstant(15).active = true
        
        skills.topAnchor.constraintEqualToAnchor(h_id.bottomAnchor, constant: 5).active = true
        skills.centerXAnchor.constraintEqualToAnchor(ProfileView.centerXAnchor).active = true
        skills.widthAnchor.constraintEqualToAnchor(ProfileView.widthAnchor, constant: -40).active = true
        skills.heightAnchor.constraintEqualToConstant(45).active = true
        skills.textAlignment = .Justified
        
        msg.topAnchor.constraintEqualToAnchor(skills.bottomAnchor, constant: 5).active = true
        msg.centerXAnchor.constraintEqualToAnchor(ProfileView.centerXAnchor).active = true
        msg.widthAnchor.constraintEqualToAnchor(ProfileView.widthAnchor, constant: -40).active = true
        
        btnMessage.bottomAnchor.constraintEqualToAnchor(ProfileView.bottomAnchor, constant: -20).active = true
        btnMessage.leftAnchor.constraintEqualToAnchor(ProfileView.leftAnchor, constant: 20).active = true
        btnMessage.widthAnchor.constraintEqualToAnchor(ProfileView.widthAnchor, multiplier: 1/2, constant: -30).active = true
        btnMessage.heightAnchor.constraintEqualToConstant(44).active = true
        
        btnBlock.bottomAnchor.constraintEqualToAnchor(ProfileView.bottomAnchor, constant: -20).active = true
        btnBlock.rightAnchor.constraintEqualToAnchor(ProfileView.rightAnchor, constant: -20).active = true
        btnBlock.widthAnchor.constraintEqualToAnchor(ProfileView.widthAnchor, multiplier: 1/2, constant: -30).active = true
        btnBlock.heightAnchor.constraintEqualToConstant(44).active = true
    }
    
    @IBAction func navBar(sender: AnyObject) {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func clickMoreImage(sender: UIButton) {
        let senderTag = sender.tag
        let title = sender.titleLabel!.text!
        self.deletePost(title, index: senderTag)
    }
    
    var pid = ""
    var index: Int = 0
    
    func deletePost(sender: String, index: Int) {
        let config = SYSTEM_CONFIG()
        self.deleteAlertMessage(config.translate("delete_post_mess"))
        self.pid = sender
        self.index = index
    }
    
    func deleteAlertMessage(userMessage:String){
        let config = SYSTEM_CONFIG()
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        myAlert.addAction(UIAlertAction(title: config.translate("button_delete"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            let id = self.pid
            let indexRow = self.index
            
            self.deleteTimeline(id)
            
            let indexPath = NSIndexPath(forRow: indexRow, inSection: 0)
            self.tblProfile.beginUpdates()
            self.userBody.removeAtIndex(indexPath.row)
            self.postDate.removeAtIndex(indexPath.row)
            self.postID.removeAtIndex(indexPath.row)
            self.fromID.removeAtIndex(indexPath.row)
            self.img1.removeAtIndex(indexPath.row)
            self.img2.removeAtIndex(indexPath.row)
            self.img3.removeAtIndex(indexPath.row)
            self.tblProfile.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tblProfile.endUpdates()
            
            self.tblProfile.reloadData()
        }))
        myAlert.addAction(UIAlertAction(title: config.translate("btn_cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
}
