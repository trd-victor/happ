//
//  CongestionExtension.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/15.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

extension CongestionViewController {

    func getCongestion(){
        
        viewLoading.hidden = false
        activityLoading.startAnimating()
        
        //set parameter for
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "\(globalvar.GET_CONGESTION_ACTION)",
            "d"           : "0",
            "lang"        : "jp",
            "office_id"   : "32"
        ]
        
        var retData: Int = 0
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            
            if error != nil || data == nil{
                self.getCongestion()
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            if json["result"] != nil {
                                let result = json["result"] as! NSArray
                                
                                for item in result {
                                    if let resultData = item as? NSDictionary {
                                        
                                        if let fields = resultData.valueForKey("fields") {
                                            if let percent = fields.valueForKey("persentage") {
                                                retData = Int(percent as! String)!
                                            }else{
                                                retData = 0
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            self.getFreeStatus(retData)
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
        
    }
    
    func getFreeStatus(percent: Int){
        //set parameter for
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_freetime_status_for_me",
            "d"           : "0",
            "lang"        : "jp",
            "user_id"     : "\(globalUserId.userID)",
            "office_id"   : "32",
            "status_key"  : "freetime"
        ]
        
        
        let httpRequest = HttpDataRequest(postData: param)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            
            if error != nil || data == nil{
                self.getFreeStatus(percent)
            }else{
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    dispatch_async(dispatch_get_main_queue()) {
                        if json!["result"] != nil {
                            let result = json!["result"] as! NSArray
                            
                            for item in result {
                                if let resultData = item as? NSDictionary {
                                    
                                    if let fields = resultData.valueForKey("fields") {
                                        if let id = fields.valueForKey("user_id") {
                                            let existsUser = self.userIds.contains(Int(id as! String)!)
                                            if !existsUser {
                                                self.userIds.append(Int(id as! String)!)
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        
                        self.percentage.text = "\(percent)%"
                        self.viewBlackConstraint.constant = self.calculatePercentage(percent)
                        self.collectionView.reloadData()
                        
                        self.viewLoading.hidden = true
                        self.activityLoading.stopAnimating()
                    }
                    
                } catch {
                    print(error)
                }

            }
            
        }
        task.resume()
    }
    
}