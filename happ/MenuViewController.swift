//
//  MenuViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 06/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase


class MenuViewController: UITabBarController {

    @IBOutlet var menuTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load config
        self.configLoad()
        
        //refresh notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("refreshLang:")), name: "refreshMenu", object: nil)
        
        self.badgeObserver()
        preferredStatusBarStyle()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
                    }else{
                        self.menuTabBar.items![1].badgeValue = String(count)
                    }
                }
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