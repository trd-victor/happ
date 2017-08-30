//
//  Constants.swift
//  happ
//
//  Created by TokikawaTeppei on 17/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//
import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot =  FIRDatabase.reference(FIRDatabase.database())
        static let databaseChats = databaseRoot().child("chat")
    }
}
