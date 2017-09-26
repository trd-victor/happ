//
//  Extension+CR+Controller.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/26.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

extension CreateReservation {

    func postReservation(sdate: String, edate: String){
        
        var paramLang = ""
        lang = config.getSYS_VAL("AppLanguage") as! String
        if lang == "en" {
            paramLang = "en"
        }else{
            paramLang = "jp"
        
        }
        let parameters = [
            "sercret"                 : "jo8nefamehisd",
            "action"                  : "api",
            "ac"                      : "update_resavation",
            "d"                       : "0",
            "lang"                    : "\(paramLang)",
            "meeting_room_pid"        : "82",
            "start"                   : "\(sdate)",
            "end"                     : "\(edate)",
            "user_id"                 : "\(globalUserId.userID)"
        ]
        
        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil {
                
            }else{
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if json!["error"] == nil {
                        dispatch_async(dispatch_get_main_queue()){
                            let msg = self.config.translate("done_reservation") 
                            self.displayMyAlertMessage(msg,error: false)
                        }
                    }else{
                        dispatch_async(dispatch_get_main_queue()){
                            self.displayMyAlertMessage(String(json!["message"]!),error: true)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func displayMyAlertMessage(userMessage:String, error: Bool){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            if !error {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func getReserved(){
        let parameters = [
            "sercret"          : "jo8nefamehisd",
            "action"           : "api",
            "ac"               : "get_resavation",
            "d"                : "0",
            "lang"             : "en",
            "office_id"        : "82",
            "start"            : "\(CreateDetails.date) 00:00:00",
            "end"              : "\(CreateDetails.date) 23:59:59"
        ]
        
        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil {
                self.getReserved()
            }else{
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if let resultArray = json!.valueForKey("result") as? NSArray {
                        if let fields = resultArray.valueForKey("fields") as? NSArray {
                            for data in fields {
                                let start = String(data.valueForKey("start")!)
                                let dateArr = start.characters.split{$0 == " "}.map(String.init)
                                let timeArr = dateArr[1].characters.split{$0 == ":"}.map(String.init)
                                let end = String(data.valueForKey("end")!)
                                let dateArr2 = end.characters.split{$0 == " "}.map(String.init)
                                let timeArr2 = dateArr2[1].characters.split{$0 == ":"}.map(String.init)
                                self.dataTime.append("\(timeArr[0]):\(timeArr[1])~\(timeArr2[0]):\(timeArr2[1])")
                                let userid = String(data.valueForKey("user_id")!)
                                self.dataUserId.append(userid)
                            }
                            dispatch_async(dispatch_get_main_queue()){
                                self.addReservedView()
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func addReservedView(){
        for _ in dataTime {
            let view = UIView()
            let label:UILabel = {
                let label = UILabel()
                label.textAlignment = .Left
                label.textColor = UIColor.grayColor()
                label.font = UIFont.systemFontOfSize(15)
                label.alpha = 0.8
                label.backgroundColor = UIColor.clearColor()
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            let separator:UIView = {
                let view = UIView()
                view.alpha = 0.8
                view.backgroundColor = UIColor.grayColor()
                return view
            }()
            dataView.append(view)
            dataLabel.append(label)
            dataSeparator.append(separator)
        }
        
        if dataTime.count > 0 {
            for i in 0...(dataView.count - 1) {
                let constant:CGFloat = CGFloat((i * 35) + i)
                scrollView.addSubview(dataView[i])
                dataView[i].addSubview(dataLabel[i])
                scrollView.addSubview(dataSeparator[i])
                dataView[i].translatesAutoresizingMaskIntoConstraints = false
                dataView[i].topAnchor.constraintEqualToAnchor(reservedLabel.bottomAnchor, constant: constant).active = true
                dataView[i].centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
                dataView[i].widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
                dataView[i].heightAnchor.constraintEqualToConstant(35).active = true
                
                dataLabel[i].centerXAnchor.constraintEqualToAnchor(dataView[i].centerXAnchor).active = true
                dataLabel[i].centerYAnchor.constraintEqualToAnchor(dataView[i].centerYAnchor).active = true
                dataLabel[i].widthAnchor.constraintEqualToAnchor(dataView[i].widthAnchor, constant: -20).active = true
                dataLabel[i].heightAnchor.constraintEqualToConstant(35).active = true
                
                if String(globalUserId.userID) == String(dataUserId[i]) {
                    lang = config.getSYS_VAL("AppLanguage") as! String
                    if lang == "en" {
                        dataLabel[i].text = "\(dataTime[i]) (Me)"
                    }else{
                        dataLabel[i].text = "\(dataTime[i]) (あなた)"
                    }
                }else{
                    dataLabel[i].text = dataTime[i]
                }
                
                dataSeparator[i].translatesAutoresizingMaskIntoConstraints = false
                dataSeparator[i].leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
                dataSeparator[i].topAnchor.constraintEqualToAnchor(dataView[i].bottomAnchor).active = true
                dataSeparator[i].widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
                dataSeparator[i].heightAnchor.constraintEqualToConstant(1).active = true
            }

        }
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
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
}
