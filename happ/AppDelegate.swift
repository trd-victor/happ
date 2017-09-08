//
//  AppDelegate.swift
//  happ
//
//  Created by TokikawaTeppei on 03/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FIRMessagingDelegate {
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
//        if #available(iOS 10, *){
//            //for IOS version 10+
//        }else{
//            UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil))
//            
//            // This is an asynchronous method to retrieve a Device Token
//            // Callbacks are in AppDelegate.swift
//            // Success = didRegisterForRemoteNotificationsWithDeviceToken
//            // Fail = didFailToRegisterForRemoteNotificationsWithError
//            
//            UIApplication.sharedApplication().registerForRemoteNotifications()
//        }
        
        FIRApp.configure()
        
        return true
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let deviceTokenStr = convertDeviceTokenToString(deviceToken)
        
        let alertCtrl = UIAlertController(title: "SuccessToken", message: deviceTokenStr , preferredStyle: .Alert)
        alertCtrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        var presentedVC = self.window?.rootViewController
        while (presentedVC!.presentedViewController != nil){
            presentedVC = presentedVC!.presentedViewController
        }
        
        presentedVC?.presentViewController(alertCtrl, animated: true, completion: nil)
        
        //getting device token
        print("Device Token", deviceTokenStr)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        let alertCtrl = UIAlertController(title: "Error Failed: ", message: "APN registration failed: \(error.description)", preferredStyle: .Alert)
        alertCtrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        var presentedVC = self.window?.rootViewController
        while (presentedVC!.presentedViewController != nil){
            presentedVC = presentedVC!.presentedViewController
        }
        
        presentedVC?.presentViewController(alertCtrl, animated: true, completion: nil)
        
        print("APN registration failed: \(error.description)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if let notification = userInfo["aps"] as? NSDictionary,
            let alert = notification["alert"] as? String{
                print("notification", notification)
                print("alert", alert)
                let alertCtrl = UIAlertController(title: "Success", message: "Success", preferredStyle: .Alert)
                alertCtrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                
                var presentedVC = self.window?.rootViewController
                while (presentedVC!.presentedViewController != nil){
                    presentedVC = presentedVC!.presentedViewController
                }
                
                presentedVC?.presentViewController(alertCtrl, animated: true, completion: nil)
        }
    }
    
    func applicationReceivedRemoteMessage(remoteMessage: FIRMessagingRemoteMessage) {
        // Receive message
        
        let alertCtrl = UIAlertController(title: "PUSH NOTIFICATION", message: "PUSH NOTIFICATION", preferredStyle: .Alert)
        alertCtrl.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        var presentedVC = self.window?.rootViewController
        while (presentedVC!.presentedViewController != nil){
            presentedVC = presentedVC!.presentedViewController
        }
        
        print("PUSH NOTIFICATION",remoteMessage.appData)
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    private func convertDeviceTokenToString(deviceToken:NSData) -> String {
        //  Convert binary Device Token to a String (and remove the <,> and white space charaters).
        var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "", options: [], range: nil)
        
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "", options: [], range: nil)
        deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
        
        // Our API returns token in all uppercase, regardless how it was originally sent.
        // To make the two consistent, I am uppercasing the token string here.
        deviceTokenStr = deviceTokenStr.uppercaseString
        return deviceTokenStr
    }
}

