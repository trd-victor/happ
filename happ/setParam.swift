//
//  setParam.swift
//  happ
//
//  Created by TokikawaTeppei on 01/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import Foundation

class setParameters{
    
    var param: [String: String]?
    var sercret: String = globalvar.secretKey
    var action: String = "api"
    var debug: String = "0"
    var lang: String = "jp"
    
    init() {
        
    }
    
    func Paramaters(data: [String: String]? ) -> [String : String] {
        
        var myArray = [[String: String]]()

        let param = [
            "sercret"     : "\(self.sercret)",
            "action"      : "\(self.action)",
            "d"           : "\(self.debug)",
            "lang"        : "\(self.lang)"
        ]
        myArray.append(data!)
        myArray.append(param)
        
        return param
    }
    
    func parseParam(key: [String], value: [String]) -> [String: String] {
        var result: [String: String] = [:]
        key.enumerate().forEach{ result[$0.element] = value[$0.index]}
        return result
    }
}