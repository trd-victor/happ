//
//  FirebaseSetup.swift
//  happ
//
//  Created by TokikawaTeppei on 23/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import Firebase

class FBConfig {
    
    //static variable connection...
    let db = FIRDatabase.database().reference().child("users")
    
    //userid
    var FB_USERID: String!
    var DataString: String!
    
    
    func setUserID(userEmail: String, completion: (String) -> () )  {
        let queryFirebase = db.queryOrderedByChild("email").queryEqualToValue("\(userEmail)")
            queryFirebase.observeSingleEventOfType(.Value, withBlock: { (snapshot)   in
            for snap in snapshot.children {
                let userSnap = snap as! FIRDataSnapshot
                self.FB_USERID = userSnap.key
                completion(self.FB_USERID)
            }
        })
    }
    
    func getUserID(str: String ) {
        dispatch_async(dispatch_get_main_queue()) {
            self.setUserID(str) { name  in
                print(name)
            }
        }
    }
    
    
}
