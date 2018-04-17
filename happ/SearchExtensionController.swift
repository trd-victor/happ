//
//  SearchExtensionController.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/19.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

extension SearchController {

    func getSearchUser(value: String) {
        if menu_bar.sessionDeleted {
            let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], forState: UIControlState.Normal)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        self.userData = []
        self.user_id.removeAll()
        self.tblViewSearch.reloadData()

        if task2 != nil {
            task2.cancel()
        }
//        let config = SYSTEM_CONFIG()
        
        let parameters = [
            "sercret"     : globalvar.secretKey,
            "action"      : "api",
            "ac"          : "user_search",
            "d"           : "0",
            "lang"        : "en",
            "name"        : "\(value)",
            "h_id"        : "\(value)",
            "user_id_for_block" : globalUserId.userID
        ]
        let request1 = NSMutableURLRequest(URL: self.baseUrl)
        let boundary1 = generateBoundaryString()
        request1.setValue("multipart/form-data; boundary=\(boundary1)", forHTTPHeaderField: "Content-Type")
        request1.HTTPMethod = "POST"
        request1.HTTPBody = createBodyWithParameters(parameters, boundary: boundary1)
        task2 = NSURLSession.sharedSession().dataTaskWithRequest(request1) {
            data1, response1, error1 in
            if error1 != nil{
                return
            }
            do {
                if let json2 = try NSJSONSerialization.JSONObjectWithData(data1!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                    if let info = json2["result"] as? NSArray {
                        self.userData = info
                        dispatch_async(dispatch_get_main_queue()){
                            self.tblViewSearch.reloadData()
                        }
                    }
                }
            } catch {
                
            }
        }
        task2.resume()
        
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
