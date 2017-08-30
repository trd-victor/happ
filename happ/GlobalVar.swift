//
//  GlobalVar.swift
//  happ
//
//  Created by TokikawaTeppei on 01/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import Foundation

struct globalvar {
    static var LOGIN_ACTION  : String = "user_login"
    static var UPDATE_ACTION : String = "user_update"
    static var RESET_PW_ACTION : String = "user_rest_pw"
    static var GET_USER_INFO_ACTION : String = "get_userinfo"
    static var UPDATE_TIMELINE_ACTION : String = "update_timeline"
    static var GET_TIMELINE_ACTION : String = "get_timeline"
    static var DELETE_TIMELINE_ACTION : String = "delete_timeline"
    static var ADD_BLOCK_ACTION : String = "add_block"
    static var UNLOCK_BLOCK_ACTION : String = "unlock_block"
    static var GET_BLOCK_LIST_ACTION : String = "get_block_list"
    static var UPDATE_FREETIME_ACTION : String = "update_freetime_status"
    static var GET_FREETIME_STATUS_ACTION : String = "get_freetime_status_for_me"
    static var GET_CONGESTION_ACTION : String = "get_congestion"
    static var GET_SYSTEM_VALUE : String = "get_system_value_all"
    static var APP_LANGUANGE: String = ""
    static var API_URL: NSURL = NSURL(string: "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php")!
    static var userTitle: String = ""
    static var SYSTEM_VALUE = [String : [String: String]]()
}