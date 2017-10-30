//
//  MenuViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 06/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase
import ReachabilitySwift

class MenuViewController: UITabBarController {

    @IBOutlet var menuTabBar: UITabBar!
     var reachability: Reachability!
    var connectionMessage = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(connectionMessage)
        //load config
        self.configLoad()
        
        //refresh notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("refreshLang:")), name: "refreshMenu", object: nil)
        
        self.badgeObserver()
        self.newUserObserver()
        
        preferredStatusBarStyle()
        
        autoLayout()
        
        
    }
    
    func autoLayout() {
        let config = SYSTEM_CONFIG()
        
        self.connectionMessage.translatesAutoresizingMaskIntoConstraints = false
        self.connectionMessage.bottomAnchor.constraintEqualToAnchor(self.menuTabBar.topAnchor).active = true
        self.connectionMessage.leftAnchor.constraintEqualToAnchor(self.menuTabBar.leftAnchor).active = true
        self.connectionMessage.widthAnchor.constraintEqualToAnchor(self.menuTabBar.widthAnchor).active = true
        self.connectionMessage.heightAnchor.constraintEqualToConstant(30).active = true
        self.connectionMessage.backgroundColor = UIColor.redColor()
        self.connectionMessage.hidden = true
        self.connectionMessage.textAlignment = .Center
        self.connectionMessage.textColor = UIColor.whiteColor()
        self.connectionMessage.text = config.translate("mess_no_net_connection")
    }
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reachabilityChanged:",
            name: ReachabilityChangedNotification,
            object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("This is not working.")
            return
        }
        
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                self.connectionMessage.hidden = true
            } else {
                self.connectionMessage.hidden = true
            }
        } else {
            self.connectionMessage.hidden = false
        }
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func badgeObserver(){
        let firID = FIRAuth.auth()?.currentUser?.uid
        
        let lastMessageDB = FIRDatabase.database().reference().child("chat").child("last-message").child(firID!)
        
        lastMessageDB.observeEventType(.Value, withBlock: {(snapshot) in
            var count = 0
            if let result = snapshot.value as? NSDictionary {
                for (_, value) in result {
                    let data = value as? NSDictionary
                    let read = data!["read"] as? Int

                    if read! == 0 {
                        count++;
                    }
                    if count == 0 {
                        self.menuTabBar.items![1].badgeValue = .None
                        globalvar.badgeMessNumber = 0
                    }else{
                        self.menuTabBar.items![1].badgeValue = String(count)
                        globalvar.badgeMessNumber = count
                    }
                    UIApplication.sharedApplication().applicationIconBadgeNumber = globalvar.badgeBellNumber + globalvar.badgeMessNumber
                }
            }
        })
    }
    
    
    func newUserObserver(){
        let userDB = FIRDatabase.database().reference().child("users")
        userDB.observeEventType(.Value, withBlock: {(snapshot) in
            let vc = LaunchScreenViewController()
            vc.getAllUserInfo()
            
            if let result = snapshot.value as? NSDictionary {
                globalvar.USER_IMG = result
                print("new Data")
            }
        })
    }
    
    func configLoad(){
        let config = SYSTEM_CONFIG()
        self.menuTabBar.items![0].title = config.translate("menu_timeline")
        self.menuTabBar.items![1].title = config.translate("menu_message")
        self.menuTabBar.items![2].title = config.translate("menu_reservation")
        self.menuTabBar.items![3].title = config.translate("menu_situation")
        self.menuTabBar.items![4].title = config.translate("menu_configuration")
    }
    
    func refreshLang(notification: NSNotification){
        let config = SYSTEM_CONFIG()
        self.menuTabBar.items![0].title = config.translate("menu_timeline")
        self.menuTabBar.items![1].title = config.translate("menu_message")
        self.menuTabBar.items![2].title = config.translate("menu_reservation")
        self.menuTabBar.items![3].title = config.translate("menu_situation")
        self.menuTabBar.items![4].title = config.translate("menu_configuration")
    }
    
}