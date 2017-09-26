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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func badgeObserver(){
        let firID = FIRAuth.auth()?.currentUser?.uid
        var count = 0
        let lastMessageDB = FIRDatabase.database().reference().child("chat").child("last-message").child(firID!)
        
        lastMessageDB.observeEventType(.Value, withBlock: {(snapshot) in
            
            if let result = snapshot.value as? NSDictionary {
                for (_, value) in result {
                    let data = value as? NSDictionary
                    let read = data!["read"] as? Int
                    
                    if read! == 0 {
                        count++;
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