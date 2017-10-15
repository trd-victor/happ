//
//  File.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/26.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

struct ReservationPrepareCreate {
    static var calendar:Bool = false
    static var date:String = ""
    static var day:String = ""
}

class ViewReservation: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var tableReserved: UITableView!
    @IBOutlet var navCreate: UIBarButtonItem!

    let labelNoReserved: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.boldSystemFontOfSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let viewLoading: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.6
        view.hidden = true
        return view
    }()

    let activityLoading: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.activityIndicatorViewStyle = .WhiteLarge
        return view
    }()

    var office = [[String:String]]()
    var room = [[String:String]]()

    var officeData = [String]()
    var roomData = [String]()

    var cellIndentifier = [[String:[String]]]()
    var cellPID = [[String:[String]]]()
    var cellDate = [[String:[String]]]()
    var cellTime = [[String:[String]]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableReserved.addSubview(activityLoading)
        tableReserved.bringSubviewToFront(activityLoading)
        autoLayout()

        getOffice()

        tableReserved.delegate = self
        tableReserved.dataSource = self
        tableReserved.separatorStyle = .None
        tableReserved.editing = false
        tableReserved.allowsSelection = false

        tableReserved.registerClass(ViewReservationCell.self, forCellReuseIdentifier: "TableCell")
        tableReserved.registerClass(ReservationTitle.self, forCellReuseIdentifier: "ReservationTitle")
        tableReserved.registerClass(ReservationInfo.self, forCellReuseIdentifier: "ReservationInfo")

        let config = SYSTEM_CONFIG()
        self.navCreate.title = config.translate("button_create")

        if !ReservationPrepareCreate.calendar {
            navCreate.title = ""
            navCreate.enabled = false
        }

    }

    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true

        tableReserved.translatesAutoresizingMaskIntoConstraints = false
        tableReserved.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        tableReserved.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        tableReserved.heightAnchor.constraintEqualToAnchor(view.heightAnchor, constant: -65).active = true

        activityLoading.centerXAnchor.constraintEqualToAnchor(tableReserved.centerXAnchor).active = true
        activityLoading.centerYAnchor.constraintEqualToAnchor(tableReserved.centerYAnchor).active = true
        activityLoading.widthAnchor.constraintEqualToAnchor(tableReserved.widthAnchor).active = true
        activityLoading.heightAnchor.constraintEqualToAnchor(tableReserved.heightAnchor).active = true
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return roomData.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellIndentifier.indices.contains(section) {
            return cellIndentifier[section][roomData[section]]!.count + 3
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let config = SYSTEM_CONFIG()
        let lang = config.getSYS_VAL("AppLanguage") as! String
        if cellIndentifier.indices.contains(indexPath.section) {
            if indexPath.row == 0 {
                let cell = tableReserved.dequeueReusableCellWithIdentifier("ReservationTitle", forIndexPath: indexPath) as! ReservationTitle
                cell.textLabel?.text = config.translate("subtitle_room")
                return cell
            }else if indexPath.row == 1 || indexPath.row == 2 {
                let cell = tableReserved.dequeueReusableCellWithIdentifier("ReservationInfo", forIndexPath: indexPath) as! ReservationInfo
                if indexPath.row == 1 {
                    cell.textLabel?.text = config.translate("lbl_facility")
                    for office in self.office {
                        if office["id"] == officeData[indexPath.section] {
                            if lang == "en" {
                                cell.detailTextLabel?.text = office["en"]
                            }else{
                                cell.detailTextLabel?.text = office["jp"]
                            }
                        }
                    }
                }else{
                    cell.textLabel?.text = config.translate("label_room")
                    for room in self.room {
                        if room["room_id"] == roomData[indexPath.section] {
                            if lang == "en" {
                                cell.detailTextLabel?.text = room["en"]
                            }else{
                                cell.detailTextLabel?.text = room["jp"]
                            }
                        }
                    }
                }
                return cell
            }else{
                switch(cellIndentifier[indexPath.section][roomData[indexPath.section]]![indexPath.row - 3]){
                case "SubtitleCell":
                    let cell = tableReserved.dequeueReusableCellWithIdentifier("ReservationTitle", forIndexPath: indexPath) as! ReservationTitle
                    if lang != "en" {
                        let date = cellDate[indexPath.section][roomData[indexPath.section]]![indexPath.row - 3]
                        let dateArr = date.characters.split{$0 == "-"}.map(String.init)
                        cell.textLabel?.text = "\(dateArr[0])年\(dateArr[1])月\(dateArr[2])日"
                    }else{
                        cell.textLabel?.text = cellDate[indexPath.section][roomData[indexPath.section]]![indexPath.row - 3]
                    }
                    return cell
                default:
                    let cell = tableReserved.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! ViewReservationCell
                    cell.textLabel?.text = cellTime[indexPath.section][roomData[indexPath.section]]![indexPath.row - 3]
                    return cell
                }
            }

        }else{
            let cell = tableReserved.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! ViewReservationCell
            return cell
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let config = SYSTEM_CONFIG()
        if editingStyle == .Delete {
            let indexRow = indexPath.row - 3
            let index = indexPath.row - 3
            let section = indexPath.section
            let date = cellDate[section][roomData[section]]![index]
            deleteAlertMessage(config.translate("mess_delete_res"),index: index,section: section, date: date, indexRow: indexRow)
        }
    }

    func deleteAlertMessage(userMessage:String, index: Int,section: Int, date: String, indexRow: Int){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let config = SYSTEM_CONFIG()
        myAlert.addAction(UIAlertAction(title: config.translate("button_delete"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in

            let deletePID = self.cellPID[section][self.roomData[section]]![index]

            self.removeReservation(deletePID, index: index,section: section, date: date, indexRow: indexRow)
        }))
        myAlert.addAction(UIAlertAction(title: config.translate("btn_cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    func removeReservation(pid: String, index: Int,section: Int, date: String, indexRow: Int){
        let parameters = [
            "sercret"             : "jo8nefamehisd",
            "action"              : "api",
            "ac"                  : "delete_resavation",
            "d"                   : "0",
            "lang"                : "en",
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
                self.removeReservation(pid, index: index,section: section, date: date, indexRow: indexRow)
            }else{
                do {
                    let _ = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    dispatch_async(dispatch_get_main_queue()){
                        let config = SYSTEM_CONFIG()
                        let msg = config.translate("remove_reservation")
                        self.displayMyAlertMessage(msg, error: false, index: index,section: section, date: date, indexRow: indexRow)
                    }

                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

    func displayMyAlertMessage(userMessage:String, error: Bool, index: Int,section: Int, date: String, indexRow: Int){
        let myAlert = UIAlertController(title: "", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) {
            UIAlertAction in

            self.cellDate[section][self.roomData[section]]!.removeAtIndex(index)
            self.cellPID[section][self.roomData[section]]!.removeAtIndex(index)
            self.cellIndentifier[section][self.roomData[section]]!.removeAtIndex(index)
            self.cellTime[section][self.roomData[section]]!.removeAtIndex(index)
            let count = self.cellDate[section][self.roomData[section]]!.filter({ $0.lowercaseString.containsString(date) }).count

            let indexPath = NSIndexPath(forRow: indexRow, inSection: section)
            self.tableReserved.beginUpdates()

            self.tableReserved.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            self.tableReserved.endUpdates()

            self.tableReserved.reloadData()

            if count == 1 {
                let indexPath2 = NSIndexPath(forRow: ( indexRow - 1 ), inSection: section)
                let arrIndex = self.cellDate[section][self.roomData[section]]!.indexOf(date)
                self.cellDate[section][self.roomData[section]]!.removeAtIndex(arrIndex!)
                self.cellPID[section][self.roomData[section]]!.removeAtIndex(arrIndex!)
                self.cellIndentifier[section][self.roomData[section]]!.removeAtIndex(arrIndex!)
                self.cellTime[section][self.roomData[section]]!.removeAtIndex(arrIndex!)

                self.tableReserved.beginUpdates()

                self.tableReserved.deleteRowsAtIndexPaths([indexPath2], withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableReserved.endUpdates()

                self.tableReserved.reloadData()
            }

            if self.cellIndentifier[section][self.roomData[section]]!.count == 0 {

                self.officeData.removeAtIndex(section)
                self.roomData.removeAtIndex(section)
                self.cellDate.removeAtIndex(section)
                self.cellPID.removeAtIndex(section)
                self.cellIndentifier.removeAtIndex(section)
                self.cellTime.removeAtIndex(section)

                self.tableReserved.reloadData()

            }
        }
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row >= 0 && indexPath.row <= 2 {
            return false
        }else{
            let swtch = cellIndentifier[indexPath.section][roomData[indexPath.section]]![indexPath.row - 3]
            switch (swtch) {
            case "SubtitleCell":
                return false
            default:
                return true
            }
        }
    }

    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        let config = SYSTEM_CONFIG()
        return config.translate("button_delete")
    }

    //basepath
    let baseUrl: NSURL = NSURL(string: "https://happ.biz/wp-admin/admin-ajax.php")!

    var reservedDate = [String]()

    func getOffice(){

        activityLoading.startAnimating()

        let parameters = [
            "sercret"          : "jo8nefamehisd",
            "action"           : "api",
            "ac"               : "get_office",
            "d"                : "0",
            "lang"             : "en"
        ]

        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in

            if error != nil || data == nil {
                self.getOffice()
            }else{
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary

                    if let resultArray = json!.valueForKey("result") as? NSArray {
                        for res in resultArray {
                            let id = res.valueForKey("ID")!
                            if let fields = res.valueForKey("fields") as? NSDictionary {
                                let officeEn = fields["office_name_en"] as! String
                                let officeJp = fields["office_name_jp"] as! String
                                self.office.append(["id":"\(id)","en":"\(officeEn)","jp":"\(officeJp)"])
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        self.get_meeting_room()
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

    func get_meeting_room(){
        let parameters = [
            "sercret"          : "jo8nefamehisd",
            "action"           : "api",
            "ac"               : "get_meeting_room",
            "d"                : "0",
            "lang"             : "en"
        ]

        let request = NSMutableURLRequest(URL: self.baseUrl)
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "POST"
        request.HTTPBody = createBodyWithParameters(parameters, boundary: boundary)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error  in

            if error != nil || data == nil {
                self.getOffice()
            }else{
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary

                    if let resultArray = json!.valueForKey("result") as? NSArray {
                        for res in resultArray {
                            let id = res.valueForKey("ID")!
                            if let fields = res.valueForKey("fields") as? NSDictionary {
                                if let office = fields["office"] as? NSDictionary {
                                    let roomEn = fields["room_name_en"] as! String
                                    let roomJp = fields["room_name_jp"] as! String
                                    let officeId = office["ID"]
                                    self.room.append(["room_id":"\(id)","office_id":"\(officeId!)","en":"\(roomEn)","jp":"\(roomJp)"])
                                }
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        self.getReserved()
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

    func getReserved(){

        var parameters = [String:String]()

        if ReservationPrepareCreate.date != "" {
            parameters = [
                "sercret"          : "jo8nefamehisd",
                "action"           : "api",
                "ac"               : "get_resavation",
                "d"                : "0",
                "lang"             : "en",
                "user_id"          : "\(globalUserId.userID)",
                "start"            : "\(ReservationPrepareCreate.date) 00:00:00",
                "end"              : "\(ReservationPrepareCreate.date) 23:59:59"
            ]
        }else{
            parameters = [
                "sercret"          : "jo8nefamehisd",
                "action"           : "api",
                "ac"               : "get_resavation",
                "d"                : "0",
                "lang"             : "en",
                "user_id"          : "\(globalUserId.userID)"
            ]
        }

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
                                if let meeting_room = data.valueForKey("meeting_room_pid") as? NSDictionary {
                                    let rid = String(meeting_room["ID"]!)
                                    for room in self.room {
                                        if rid == room["room_id"]! {
                                            let oid = String(room["office_id"]!)
                                            if self.officeData.contains(oid) && self.roomData.contains(rid) {

                                            }else{
                                                self.officeData.append(oid)
                                                self.roomData.append(rid)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        dispatch_async(dispatch_get_main_queue()){
                            self.generateData(resultArray)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

    func generateData(datas: NSArray){

        for room in roomData {
            var tmpIndicator = [String]()
            var tmpPID = [String]()
            var tmpDate = [String]()
            var tmpTime = [String]()

            for res in datas {
                let pid = String(res.valueForKey("ID")!)
                if let fields = res.valueForKey("fields") as? NSDictionary {
                    if let meeting_room = fields.valueForKey("meeting_room_pid") as? NSDictionary {
                        if String(meeting_room["ID"]!) == room {
                            let start = String(fields.valueForKey("start")!)
                            let dateArr = start.characters.split{$0 == " "}.map(String.init)
                            let timeArr = dateArr[1].characters.split{$0 == ":"}.map(String.init)
                            let end = String(fields.valueForKey("end")!)
                            let dateArr2 = end.characters.split{$0 == " "}.map(String.init)
                            let timeArr2 = dateArr2[1].characters.split{$0 == ":"}.map(String.init)
                            if tmpDate.contains(dateArr[0]) {
                                tmpIndicator.append("DataCell")
                                tmpPID.append(pid)
                                tmpDate.append(String(dateArr[0]))
                                tmpTime.append("\(timeArr[0]):\(timeArr[1])~\(timeArr2[0]):\(timeArr2[1])")
                            }else{
                                tmpIndicator.append("SubtitleCell")
                                tmpIndicator.append("DataCell")
                                tmpPID.append(pid)
                                tmpPID.append(pid)
                                tmpDate.append(String(dateArr[0]))
                                tmpDate.append(String(dateArr[0]))
                                tmpTime.append("\(timeArr[0]):\(timeArr[1])~\(timeArr2[0]):\(timeArr2[1])")
                                tmpTime.append("\(timeArr[0]):\(timeArr[1])~\(timeArr2[0]):\(timeArr2[1])")
                            }
                        }
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                self.cellIndentifier.append([room:tmpIndicator])
                self.cellPID.append([room:tmpPID])
                self.cellDate.append([room:tmpDate])
                self.cellTime.append([room:tmpTime])
                self.tableReserved.reloadData()
            }
        }
        dispatch_async(dispatch_get_main_queue()){
            if self.officeData.count == 0 {
                let config = SYSTEM_CONFIG()
                self.view.addSubview(self.labelNoReserved)
                self.view.bringSubviewToFront(self.labelNoReserved)

                self.labelNoReserved.topAnchor.constraintEqualToAnchor(self.navBar.bottomAnchor, constant: 10).active = true
                self.labelNoReserved.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                self.labelNoReserved.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
                self.labelNoReserved.text = config.translate("no_reservation")
            }
            self.activityLoading.stopAnimating()
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

    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let config = SYSTEM_CONFIG()
        self.navBar.topItem?.title = config.translate("title_reserved")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func navBar(sender: AnyObject) {
        if !ReservationPrepareCreate.calendar {
            let transition: CATransition = CATransition()
            transition.duration = 0.40
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.addAnimation(transition, forKey: nil)
            self.dismissViewControllerAnimated(false, completion: nil)
        }else{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func createReservation(sender: AnyObject) {
        CreateDetails.date = ReservationPrepareCreate.date
        CreateDetails.day = ReservationPrepareCreate.day
        dispatch_async(dispatch_get_main_queue()){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewControllerWithIdentifier("CreateReservation") as! CreateReservation
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
}

class ViewReservationCell: UITableViewCell {

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayColor()
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(10, 0 , self.frame.width - 10, self.frame.height)
        textLabel?.textAlignment = .Left
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)

        addSubview(separator)
        separator.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        separator.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -1).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ReservationTitle: UITableViewCell {

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayColor()
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(0, 0 , self.frame.width, self.frame.height)
        textLabel?.backgroundColor = UIColor(hexString: "#E4D4B9")
        textLabel?.textAlignment = .Center
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(separator)
        separator.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        separator.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -1).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ReservationInfo: UITableViewCell {

    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayColor()
        view.alpha = 0.8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(10, 0 , self.frame.width - 10, self.frame.height)
        textLabel?.textAlignment = .Left
        textLabel?.font = UIFont.systemFontOfSize(16)
        textLabel?.textColor = UIColor.blackColor()

        detailTextLabel?.frame = CGRectMake(90, 0 , self.frame.width - 100, self.frame.height)
        detailTextLabel?.textAlignment = .Right
        detailTextLabel?.font = UIFont.systemFontOfSize(16)
        detailTextLabel?.textColor = UIColor.blackColor()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(separator)
        separator.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        separator.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -1).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
