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
    var skillsVal = [String : [String : String]]()

    
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
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                    if let _ = json.valueForKey("result") as? NSArray {
                        for result in json.valueForKey("result") as! NSArray {
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
                }
            } catch {
                print(error)
            }
        }
       task.resume()
    }
    
    func getCallBackKey(completion: (success: Bool)-> Void){
        
        let httpRequest = HttpDataRequest(postData: parameters)
        let request = httpRequest.requestGet()
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil{
                self.getCallBackKey(completion)
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        if let _ = json.valueForKey("result") as? NSArray {
                            for result in json.valueForKey("result") as! NSArray {
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
                            completion(success: true)
                        }
                    }else{
                        self.getCallBackKey(completion)
                    }
                } catch {
                    self.getCallBackKey(completion)
                }
            }
        }
        task.resume()
    }
    
    
    func getSkill(){
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(URL: globalvar.API_URL)
        
        //set boundary string..
        let boundary = generateBoundaryString()
        
        //set value for image upload
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //setting the method to post
        request.HTTPMethod = "POST"
        
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_skill",
            "d"           : "0",
            "lang"        : "jp",
            "with_cat"     : "0"
        ]
        
        //adding the parameters to request body
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            
            if error != nil || data == nil{
                print("error kay ", error)
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        
                        
                        if let result = json["result"] as? NSArray {
                            for (value) in result {
                                let dataVal = value as? NSDictionary
                                let id = dataVal!["ID"] as? Int
                                
                                if let fields = dataVal!["fields"] as? NSDictionary {
                                    let en = fields["skill_name_en"] as? String
                                    let jp = fields["skill_name_jp"] as? String
                                    let key = fields["key"] as? String
                                    
                                    self.skillsVal[String(id!)] = [
                                        "en": en!,
                                        "jp": jp!,
                                        "key": key!,
                                    ]
                                }
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue()){
                            let config = SYSTEM_CONFIG()
                            config.setSYS_VAL(self.skillsVal, key: "SYSTM_SKILL")
                        }
                    }
                }catch {
                    print("error kay2 ", error)
                }
                
            }
            
        }
        task.resume()
    }
    
    
    func getCallbackSkill(completion: (success: Bool)-> Void){
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(URL: globalvar.API_URL)
        
        //set boundary string..
        let boundary = generateBoundaryString()
        
        //set value for image upload
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        //setting the method to post
        request.HTTPMethod = "POST"
        
        let param = [
            "sercret"     : "jo8nefamehisd",
            "action"      : "api",
            "ac"          : "get_skill",
            "d"           : "0",
            "lang"        : "jp",
            "with_cat"     : "0"
        ]
        
        //adding the parameters to request body
        request.HTTPBody = createBodyWithParameters(param, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            if error != nil || data == nil{
                self.getCallbackSkill(completion)
            }else{
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        
                        
                        if let result = json["result"] as? NSArray {
                            for (value) in result {
                                let dataVal = value as? NSDictionary
                                let id = dataVal!["ID"] as? Int
                                
                                if let fields = dataVal!["fields"] as? NSDictionary {
                                    let en = fields["skill_name_en"] as? String
                                    let jp = fields["skill_name_jp"] as? String
                                    let key = fields["key"] as? String
                                    
                                    self.skillsVal[String(id!)] = [
                                        "en": en!,
                                        "jp": jp!,
                                        "key": key!,
                                    ]
                                }
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue()){
                            let config = SYSTEM_CONFIG()
                            config.setSYS_VAL(self.skillsVal, key: "SYSTM_SKILL")
                            completion(success: true)
                        }
                    }else{
                        self.getCallbackSkill(completion)
                    }
                }catch {
                    self.getCallbackSkill(completion)
                }   
            }
        }
        task.resume()
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



