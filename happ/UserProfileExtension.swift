//
//  UserProfileExtension.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/19.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

extension UserProfileController {
    
    
    //
    // GET USER PROFILE INFORMATION
    //
    
    func loadUserinfo(sender: String) {
        
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_userinfo",
            "d"           : "0",
            "lang"        : "jp",
            "user_id"     : "\(sender)"
        ]
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil {
                self.loadUserinfo(sender)
            }
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers ) as? NSDictionary {
                    if json["result"] != nil {
                        dispatch_async(dispatch_get_main_queue()){
                            self.userName.text = json["result"]!["name"] as? String
                            self.h_id.text = json["result"]!["h_id"] as? String
                            self.skills.text = json["result"]!["skills"] as? String
                            self.msg.text = json["result"]!["mess"] as? String
                            if let imgUrl = json["result"]!["icon"] as? String {
                                self.ProfileImage.profileForCache(imgUrl)
                            }
                            
                        }
                    }
                }else{
                    self.loadUserinfo(sender)
                }
            } catch {
                print(error)
            }
            
        }
        task.resume()
        
        
    }
}
