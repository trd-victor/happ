//
//  SystemValue.swift
//  happ
//
//  Created by TokikawaTeppei on 29/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

struct systemvalue {
    static var key : String = ""
    static var value_jp : String = ""
    static var value_en : String = ""
}

class getSystemValue {
    
    let parameters = [
        "sercret"   : "jo8nefamehisd",
        "action"    : "api",
        "ac"        : "\(globalvar.GET_SYSTEM_VALUE)",
        "d"         : "0",
        "lang"      : "en"
    ]
    
    var key = [String]()
    var value_jp = [String]()
    var value_en = [String]()
    var sysVals = [String : [String : String]]()
   
    func getKey() {

        let httpRequest = HttpDataRequest(postData: parameters)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil{
                print("\(error)")
                return;
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                if let _ = json?.valueForKey("result") as? NSArray {
                    for result in json?.valueForKey("result") as! NSArray {
                        if result["fields"] != nil && result["fields"]!!["key"] != nil {
                            if let msg = result["fields"]! {
                                let key = msg["key"] as! String
                                let en = msg["value_en"] as! String
                                let ja = msg["value_jp"] as! String
                                
                                self.sysVals[key] = [
                                    "en" : en,
                                    "jp" : ja
                                ]
                            }
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue()){
                    let config = SYSTEM_CONFIG()
                    config.setSYS_VAL(self.sysVals, key: "SYSTM_VAL")
                }
            } catch {
                print(error)
            }
        }
       task.resume()
    }
    
}



