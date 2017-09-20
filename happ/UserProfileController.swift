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
    
    let baseUrl: NSURL = NSURL(string: "https://happ.biz/wp-admin/admin-ajax.php")!
    
    
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
        return btn
    }()
    
    @IBOutlet var happLogo: UIImageView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var navBack: UIBarButtonItem!
    @IBOutlet var tblProfile: UITableView!
    @IBOutlet var tabBar: UITabBar!
    
    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblProfile.registerClass(NoImage.self, forCellReuseIdentifier: "NoImage")
        tblProfile.registerClass(SingleImage.self, forCellReuseIdentifier: "SingleImage")
        tblProfile.registerClass(DoubleImage.self, forCellReuseIdentifier: "DoubleImage")
        tblProfile.registerClass(TripleImage.self, forCellReuseIdentifier: "TripleImage")
        
        userName.text = ""
        h_id.text = ""
        skills.text = ""
        msg.text = ""
        ProfileImage.image = UIImage(named: "noPhoto")
        
        loadUserinfo(UserProfile.id)
        
        tblProfile.addSubview(ProfileView)
        ProfileView.addSubview(ProfileImage)
        ProfileView.addSubview(userName)
        ProfileView.addSubview(h_id)
        ProfileView.addSubview(skills)
        ProfileView.addSubview(msg)
        ProfileView.addSubview(btnMessage)
        ProfileView.addSubview(btnBlock)
        
        tblProfile.addSubview(self.refreshControl)
        
        tblProfile.separatorStyle = .None
        tblProfile.backgroundColor = UIColor(hexString: "#E4D4B9")
        
        tblProfile.delegate = self
        tblProfile.dataSource = self
        
        translate()
        
        tblProfile.contentInset = UIEdgeInsetsMake(380, 0, 0, 0)
        
        autoLayout()
    }
    
    func translate(){
        btnMessage.setTitle("Message", forState: .Normal)
        btnBlock.setTitle("Block", forState: .Normal)
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
        
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        tabBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        tabBar.heightAnchor.constraintEqualToConstant(50).active = true
        tabBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        
        tblProfile.translatesAutoresizingMaskIntoConstraints = false
        tblProfile.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        tblProfile.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        tblProfile.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        tblProfile.bottomAnchor.constraintEqualToAnchor(tabBar.topAnchor).active = true
        
        ProfileView.topAnchor.constraintEqualToAnchor(tblProfile.topAnchor, constant: -380).active = true
        ProfileView.centerXAnchor.constraintEqualToAnchor(tblProfile.centerXAnchor).active = true
        ProfileView.widthAnchor.constraintEqualToAnchor(tblProfile.widthAnchor).active = true
        ProfileView.heightAnchor.constraintEqualToConstant(380).active = true
        ProfileView.backgroundColor = UIColor(hexString: "#E4D4B9")
        
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
        let transition: CATransition = CATransition()
        transition.duration = 0.25
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
    
}
