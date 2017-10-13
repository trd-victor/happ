//
//  ViewCalendarTest.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/10/13.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class ViewCalendarTest: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    let TestSection = ["Section1","Section2"]
    let TestCell = [
        ["test1","test2"],
        ["test3","test4"]
    ]

    var office = [[String:String]]()
    var room = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        getOffice()
        get_meeting_room()
        getReserved()

        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerClass(ViewReservationCell.self, forCellReuseIdentifier: "TableCell")

        autoLayout()
    }

    func autoLayout(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        tableView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        tableView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, constant: -22).active = true
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return TestSection.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestCell[section].count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! ViewReservationCell
        cell.textLabel?.text = String(TestSection[indexPath.section])
        cell.detailTextLabel?.text = String(TestCell[indexPath.section][indexPath.row])
        return cell
    }


    //basepath
    let baseUrl: NSURL = NSURL(string: "https://happ.biz/wp-admin/admin-ajax.php")!

    var reservedDate = [String]()

    func getOffice(){
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
                    print(self.office)
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
                    print(self.room)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }

    func getReserved(){
        let parameters = [
            "sercret"          : "jo8nefamehisd",
            "action"           : "api",
            "ac"               : "get_resavation",
            "d"                : "0",
            "lang"             : "en",
            "user_id"          : "\(globalUserId.userID)"
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
                                print(data)
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

class ViewReservationCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
