//
//  Constants.swift
//  happ
//
//  Created by TokikawaTeppei on 20/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import Firebase

struct Constants {
    
    struct ref {
        static var rootDb = FIRDatabase.database().reference()
        static var rootChild = rootDb.child("chat").child("messages").childByAutoId()
        static var memberDb = rootDb.child("chat").child("members")
    }
    
}
