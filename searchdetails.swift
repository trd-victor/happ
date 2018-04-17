//
//  searchdetails.swift
//  happ
//
//  Created by TokikawaTeppei on 14/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import Foundation

class UserDetailsSearch {
    var name: String!
    var image: String!
    var skills: String!
    var description: String!
    var user_id: String
    var jsonData: NSDictionary!
    
    init(userID: String) {
        self.user_id = userID
        self.getUserData(self.user_id)
    }
    
    func getUserData(sender: String) {
        
        let param = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "\(globalvar.GET_USER_INFO_ACTION)",
            "d"           : "0",
            "lang"        : "jp",
            "user_id"       : "\(sender)"
        ]
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                self.jsonData = json!
                
            } catch {
                print(error)
            }
            
        }
        task.resume()
    }
    
//    func getSearchData() -> NSDictionary {
//        return self.jsonData!
//    }
    
}