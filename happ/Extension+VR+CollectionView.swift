//
//  Extension+VR+CollectionView.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/27.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

extension ViewReservation {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let config = SYSTEM_CONFIG()
        let lang = config.getSYS_VAL("AppLanguage") as! String
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SubtitleCell", forIndexPath: indexPath) as! SubtitleCell
            cell.lblTitle.text = config.translate("label_room")
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("InformationCell", forIndexPath: indexPath) as! InformationCell
            cell.title.text = config.translate("lbl_facility")
            cell.name.text = "FUKUOKA"
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("InformationCell", forIndexPath: indexPath) as! InformationCell
            cell.title.text = config.translate("subtitle_room")
            cell.name.text = "A"
            cell.separator.hidden = true
            return cell
        }else{
            let index = indexPath.row - 3
            let swtch = cellIndentifier[index]
            switch(swtch){
            case "SubtitleCell":
                let cell = tableView.dequeueReusableCellWithIdentifier("SubtitleCell", forIndexPath: indexPath) as! SubtitleCell
                var date:String = cellDate[index]
                if lang != "en" {
                    let dateArr = date.characters.split{$0 == "-"}.map(String.init)
                    date = "\(dateArr[0])年\(dateArr[1])月\(dateArr[2])日"
                }
                cell.lblTitle.text = "\(date) (\(getDayOfWeek(cellDate[index])))"
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath) as! DataCell
                cell.lblTime.text = cellTime[index]
                return cell
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row <= 2 {
            return false
        }else{
            let index = indexPath.row - 3
            let swtch = cellIndentifier[index]
            switch (swtch) {
            case "SubtitleCell":
                return false
            default:
                return true
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let indexRow = indexPath.row
            let index = indexPath.row - 3
            let date = cellDate[index]
            deleteAlertMessage("Remove Reservation?",index: index, date: date, indexRow: indexRow)
        }
    }
    
    func deleteAlertMessage(userMessage:String, index: Int, date: String, indexRow: Int){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        myAlert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            
            let deletePID = self.cellPID[index]
            
            self.cellDate.removeAtIndex(index)
            self.cellPID.removeAtIndex(index)
            self.cellIndentifier.removeAtIndex(index)
            self.cellTime.removeAtIndex(index)
            let count = self.cellDate.filter({ $0.lowercaseString.containsString(date) }).count
            
            let indexPath = NSIndexPath(forRow: indexRow, inSection: 0)
            self.tableReserved.beginUpdates()
            
            self.tableReserved.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableReserved.endUpdates()
            
            self.tableReserved.reloadData()
            
            if count == 1 {
                let indexPath2 = NSIndexPath(forRow: ( indexRow - 1 ), inSection: 0)
                let arrIndex = self.cellDate.indexOf(date)
                self.cellDate.removeAtIndex(arrIndex!)
                self.cellPID.removeAtIndex(arrIndex!)
                self.cellIndentifier.removeAtIndex(arrIndex!)
                self.cellTime.removeAtIndex(arrIndex!)
                
                self.tableReserved.beginUpdates()
                
                self.tableReserved.deleteRowsAtIndexPaths([indexPath2], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableReserved.endUpdates()
                
                self.tableReserved.reloadData()
            }
            
            self.removeReservation(deletePID)
            
        }))
        myAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (3 + cellIndentifier.count)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        }else if indexPath.row == 1 || indexPath.row == 2 {
            return 50
        }else{
            let swtch = cellIndentifier[(indexPath.row - 3)]
            switch(swtch){
            case "SubtitleCell":
                return 30
            default:
                return 51
            }
        }
    }
    
    func getDayOfWeek(today:String) -> String {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(today)!
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components([.Weekday, .WeekOfMonth], fromDate: todayDate)
        let weekDay = components.weekday
        
        let config = SYSTEM_CONFIG()
        let lang = config.getSYS_VAL("AppLanguage") as! String
        
        switch(weekDay) {
        case 2:
            if(lang == "en"){ return "Mon" }else{ return "日" }
        case 3:
            if(lang == "en"){ return "Tue" }else{ return "月" }
        case 4:
            if(lang == "en"){ return "Wed" }else{ return "火" }
        case 5:
            if(lang == "en"){ return "Thu" }else{ return "水" }
        case 6:
            if(lang == "en"){ return "Fri" }else{ return "木" }
        case 7:
            if(lang == "en"){ return "Sat" }else{ return "金" }
        default:
            if(lang == "en"){ return "Sun" }else{ return "土" }
        }
        
    }
    
    func getReservationWithID(){
        let parameters = [
            "sercret"                 : "jo8nefamehisd",
            "action"                  : "api",
            "ac"                      : "get_resavation",
            "d"                       : "0",
            "lang"                    : "en",
            "meeting_room_pid"        : "82",
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
                self.getReservationWithID()
            }else{
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                    if let resultArray = json!.valueForKey("result") as? NSArray {
                        for res in resultArray {
                            let pid = String(res.valueForKey("ID")!)
                            if let fields = res.valueForKey("fields") as? NSDictionary {
                                let start = String(fields.valueForKey("start")!)
                                let dateArr = start.characters.split{$0 == " "}.map(String.init)
                                let timeArr = dateArr[1].characters.split{$0 == ":"}.map(String.init)
                                let end = String(fields.valueForKey("end")!)
                                let dateArr2 = end.characters.split{$0 == " "}.map(String.init)
                                let timeArr2 = dateArr2[1].characters.split{$0 == ":"}.map(String.init)
                                if self.cellDate.contains(dateArr[0]) {
                                    self.cellIndentifier.append("DataCell")
                                    self.cellPID.append(pid)
                                    self.cellDate.append(String(dateArr[0]))
                                    self.cellTime.append("\(timeArr[0]):\(timeArr[1])~\(timeArr2[0]):\(timeArr2[1])")
                                }else{
                                    self.cellIndentifier.append("SubtitleCell")
                                    self.cellIndentifier.append("DataCell")
                                    self.cellPID.append(pid)
                                    self.cellPID.append(pid)
                                    self.cellDate.append(String(dateArr[0]))
                                    self.cellDate.append(String(dateArr[0]))
                                    self.cellTime.append("\(timeArr[0]):\(timeArr[1])~\(timeArr2[0]):\(timeArr2[1])")
                                    self.cellTime.append("\(timeArr[0]):\(timeArr[1])~\(timeArr2[0]):\(timeArr2[1])")
                                }
                            }
                        }
                        dispatch_async(dispatch_get_main_queue()){
                            self.tableReserved.reloadData()
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func removeReservation(pid: String){
        
        let parameters = [
            "sercret"             : "jo8nefamehisd",
            "action"              : "api",
            "ac"                  : "delete_resavation",
            "d"                   : "0",
            "lang"                : "en",
            "meeting_room_pid"    : "82",
            "pid"                 : "\(pid)"
        ]
        
        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in
            
            if error != nil || data == nil {
                self.removeReservation(pid)
            }else{
                do {
                    let _ = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    dispatch_async(dispatch_get_main_queue()){
                        let config = SYSTEM_CONFIG()
                        let msg = config.translate("remove_reservation")
                        self.displayMyAlertMessage(msg, error: false)
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
            
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
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
