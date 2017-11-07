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
import Foundation
import AudioToolbox

struct menu_bar {
    static var timeline: UITabBarItem!
    static var reservation: UITabBarItem!
    static var situation: UITabBarItem!
    static var timelineReloadCount: Bool!
    static var reloadScreen: UIView!
}

class MenuViewController: UITabBarController, UITabBarControllerDelegate {

    @IBOutlet var menuTabBar: UITabBar!
     var reachability: Reachability!
    var connectionMessage = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.view.addSubview(connectionMessage)
        //load config
        self.configLoad()
        
        //refresh notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("refreshLang:")), name: "refreshMenu", object: nil)
        
        self.badgeObserver()
        self.newUserObserver()
        
        preferredStatusBarStyle()
        
        autoLayout()
        
        
        self.menuTabBar.items![0].tag = 1
        menu_bar.timeline = self.menuTabBar.items![0]
        menu_bar.reservation = self.menuTabBar.items![2]
        menu_bar.situation = self.menuTabBar.items![3]
        
        menu_bar.timelineReloadCount = false
       
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if tabBarController.tabBar.selectedItem?.tag == 1 {
            if menu_bar.reloadScreen == nil {
                menu_bar.reloadScreen = UIViewController.displaySpinner(self.view)
            }
            
            menu_bar.timelineReloadCount = true
            let vc = viewController as? UserTimelineViewController
            vc?.updateTimeline()
        }
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
        
        // message badge
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
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                    UIApplication.sharedApplication().applicationIconBadgeNumber = globalvar.badgeBellNumber + globalvar.badgeMessNumber
                }
            }
        })
        
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        if uid != ""{
            // update badge
            FIRDatabase.database().reference().child("user-badge").child("reservation").child(uid!).observeEventType(.Value, withBlock: {(snap) in
                if let count = snap.value as? Int{
                    if count != 0 {
                        menu_bar.reservation.badgeValue = String(count)
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }else{
                        menu_bar.reservation.badgeValue = .None
                    }
                }
            })
            
            FIRDatabase.database().reference().child("user-badge").child("freetime").child(uid!).observeEventType(.Value, withBlock: {(snap) in
                if let count = snap.value as? Int{
                    if count != 0 {
                        menu_bar.situation.badgeValue = String(count)
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }else{
                        menu_bar.situation.badgeValue = .None
                    }
                }
            })
            
            FIRDatabase.database().reference().child("user-badge").child("timeline").child(uid!).observeEventType(.Value, withBlock: {(snap) in
                if let count = snap.value as? Int{
                    if count != 0 {
                        menu_bar.timeline.badgeValue = String(count)
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }else{
                        menu_bar.timeline.badgeValue = .None
                    }
                }
            })
        }
    }
    
    func newUserObserver(){
        let config = SYSTEM_CONFIG()
        
        let userDB = FIRDatabase.database().reference().child("users")
        userDB.observeEventType(.Value, withBlock: {(snapshot) in
            let vc = LaunchScreenViewController()
            vc.getAllUserInfo()
            
            if let result = snapshot.value as? NSDictionary {
                globalvar.USER_IMG = result
                
                dispatch_async(dispatch_get_main_queue()){
                    let firID = FIRAuth.auth()?.currentUser?.uid
                    if let _ = globalvar.USER_IMG.valueForKey(firID!) {
                        
                    }else{
                        let myAlert = UIAlertController(title: "", message: config.translate("message_account_deleted"), preferredStyle: UIAlertControllerStyle.Alert)
                        myAlert.addAction(UIAlertAction(title: config.translate("label_logout"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                            
                            do {
                                try FIRAuth.auth()?.signOut()
                                
                                config.removeSYS_VAL("userID")
                                globalUserId.userID = ""
                            } catch (let error) {
                                print((error as NSError).code)
                            }
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        self.presentViewController(myAlert, animated: true, completion: nil)
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
    
}