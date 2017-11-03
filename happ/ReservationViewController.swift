//
//  ReservationViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 14/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

struct Reservation {
    static var reserved = [String]()
}

class ReservationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewDaysoftheWeeks: UIView!

    @IBOutlet var reservation: UIBarButtonItem!

    let lblMon: UILabel = UILabel()
    let lblTue: UILabel = UILabel()
    let lblWed: UILabel = UILabel()
    let lblThu: UILabel = UILabel()
    let lblFri: UILabel = UILabel()
    let lblSat: UILabel = UILabel()
    let lblSun: UILabel = UILabel()

    var layoutwidth: CGFloat = 0

    var calendarYear:Int = 0
    var calendarDay:Int = 0
    var calendarMonth:Int = 0
    var calendarCurrent: String = ""

    var lang: String = ""

    var monthString = [String]()
    var yearString = [String]()
    var dayString = [String]()


    var calendarDays = [String]()
    var calendarDates = [String]()
    var calendarDaysWords = [String]()

    var checkDate:Bool = false


    var cellData = [String]()
    var month = [String]()
    var year = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("openReservation:")), name: "openReservation", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("reloadCalendar:")), name: "reloadCalendar", object: nil)

        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        calendarYear =  components.year
        calendarMonth = components.month
        calendarDay = components.day

        calendarCurrent = "\(calendarYear)-\(calendarMonth)-\(calendarDay)"

        layoutwidth = view.frame.width / 7

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSizeMake(layoutwidth, 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .Vertical

        viewDaysoftheWeeks.addSubview(lblMon)
        viewDaysoftheWeeks.addSubview(lblTue)
        viewDaysoftheWeeks.addSubview(lblWed)
        viewDaysoftheWeeks.addSubview(lblThu)
        viewDaysoftheWeeks.addSubview(lblFri)
        viewDaysoftheWeeks.addSubview(lblSat)
        viewDaysoftheWeeks.addSubview(lblSun)

        tableView.registerClass(CalendarTableCell.self, forCellReuseIdentifier: "CalendarDate")
        tableView.registerClass(CalendarTitle.self, forCellReuseIdentifier: "CalendarTitle")

        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorStyle = .None
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        autoLayout()

    }

    func prepareCalendarData(){
        cellData.removeAll()
        month.removeAll()
        year.removeAll()

        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        var calendarYear =  components.year
        var calendarMonth = components.month

        calendarMonth -= 2
        if calendarMonth == 0 {
            calendarMonth = 12
            calendarYear -= 1
        }else if calendarMonth == -1 {
            calendarMonth = 11
            calendarYear -= 1
        }

        for _ in 1...4 {
            calendarMonth += 1
            if calendarMonth == 13 {
                calendarMonth = 1
                calendarYear += 1
            }

            cellData.append("CalendarTitle")
            cellData.append("CalendarDate")
            month.append("\(calendarMonth)")
            month.append("\(calendarMonth)")
            year.append("\(calendarYear)")
            year.append("\(calendarYear)")
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
                let indexPath = NSIndexPath(forRow: 2, inSection: 0)
                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
            }
        }

    }

    var firstLoad:Bool = false

    override func viewDidAppear(animated: Bool) {
        let config = SYSTEM_CONFIG()
        self.navBar.topItem?.title = config.translate("title_room_reservation")
        
        FIRDatabase.database().reference().child("user-badge").child("reservation").child(globalUserId.FirID).setValue(0)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        getReserved()

        let config = SYSTEM_CONFIG()
        lang = config.getSYS_VAL("AppLanguage") as! String

        lblMon.text = (lang == "en") ? "Mon" : "月"
        lblMon.textAlignment = .Center
        lblTue.text = (lang == "en") ? "Tue" : "火"
        lblTue.textAlignment = .Center
        lblWed.text = (lang == "en") ? "Wed" : "水"
        lblWed.textAlignment = .Center
        lblThu.text = (lang == "en") ? "Thu" : "木"
        lblThu.textAlignment = .Center
        lblFri.text = (lang == "en") ? "Fri" : "金"
        lblFri.textAlignment = .Center
        lblSat.text = (lang == "en") ? "Sat" : "土"
        lblSat.textAlignment = .Center
        lblSun.text = (lang == "en") ? "Sun" : "日"
        lblSun.textAlignment = .Center

        reservation.title = config.translate("title_reserved")

    }

    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true

        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        mainView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        mainView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        mainView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, constant: -60).active = true

        viewDaysoftheWeeks.translatesAutoresizingMaskIntoConstraints = false
        viewDaysoftheWeeks.topAnchor.constraintEqualToAnchor(mainView.topAnchor).active = true
        viewDaysoftheWeeks.centerXAnchor.constraintEqualToAnchor(mainView.centerXAnchor).active = true
        viewDaysoftheWeeks.widthAnchor.constraintEqualToAnchor(mainView.widthAnchor).active = true
        viewDaysoftheWeeks.heightAnchor.constraintEqualToConstant(44).active = true

        lblSun.translatesAutoresizingMaskIntoConstraints = false
        lblSun.leftAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.leftAnchor).active = true
        lblSun.centerYAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.centerYAnchor).active = true
        lblSun.widthAnchor.constraintEqualToConstant(layoutwidth).active = true
        lblSun.heightAnchor.constraintEqualToConstant(44).active = true
        
        lblMon.translatesAutoresizingMaskIntoConstraints = false
        lblMon.leftAnchor.constraintEqualToAnchor(lblSun.rightAnchor).active = true
        lblMon.centerYAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.centerYAnchor).active = true
        lblMon.widthAnchor.constraintEqualToConstant(layoutwidth).active = true
        lblMon.heightAnchor.constraintEqualToConstant(44).active = true

        lblTue.translatesAutoresizingMaskIntoConstraints = false
        lblTue.leftAnchor.constraintEqualToAnchor(lblMon.rightAnchor).active = true
        lblTue.centerYAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.centerYAnchor).active = true
        lblTue.widthAnchor.constraintEqualToConstant(layoutwidth).active = true
        lblTue.heightAnchor.constraintEqualToConstant(44).active = true

        lblWed.translatesAutoresizingMaskIntoConstraints = false
        lblWed.leftAnchor.constraintEqualToAnchor(lblTue.rightAnchor).active = true
        lblWed.centerYAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.centerYAnchor).active = true
        lblWed.widthAnchor.constraintEqualToConstant(layoutwidth).active = true
        lblWed.heightAnchor.constraintEqualToConstant(44).active = true

        lblThu.translatesAutoresizingMaskIntoConstraints = false
        lblThu.leftAnchor.constraintEqualToAnchor(lblWed.rightAnchor).active = true
        lblThu.centerYAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.centerYAnchor).active = true
        lblThu.widthAnchor.constraintEqualToConstant(layoutwidth).active = true
        lblThu.heightAnchor.constraintEqualToConstant(44).active = true

        lblFri.translatesAutoresizingMaskIntoConstraints = false
        lblFri.leftAnchor.constraintEqualToAnchor(lblThu.rightAnchor).active = true
        lblFri.centerYAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.centerYAnchor).active = true
        lblFri.widthAnchor.constraintEqualToConstant(layoutwidth).active = true
        lblFri.heightAnchor.constraintEqualToConstant(44).active = true

        lblSat.translatesAutoresizingMaskIntoConstraints = false
        lblSat.leftAnchor.constraintEqualToAnchor(lblFri.rightAnchor).active = true
        lblSat.centerYAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.centerYAnchor).active = true
        lblSat.widthAnchor.constraintEqualToConstant(layoutwidth).active = true
        lblSat.heightAnchor.constraintEqualToConstant(44).active = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.bottomAnchor).active = true
        tableView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        tableView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        tableView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    }

    func openReservation(notification: NSNotification){
        dispatch_async(dispatch_get_main_queue()){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewControllerWithIdentifier("ViewReservation") as! ViewReservation
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    func reloadCalendar(notification: NSNotification){
        getReserved()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch(cellData[indexPath.row]){
        case "CalendarTitle":
            let cell = tableView.dequeueReusableCellWithIdentifier("CalendarTitle", forIndexPath: indexPath) as! CalendarTitle

            cell.textLabel?.text = getDateString(Int(month[indexPath.row])!, year: Int(year[indexPath.row])!)

            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("CalendarDate", forIndexPath: indexPath) as! CalendarTableCell

            if month.indices.contains(indexPath.row) && year.indices.contains(indexPath.row) {
                cell.month = Int(month[indexPath.row])!
                cell.year = Int(year[indexPath.row])!
            }

            return cell
        }
    }

    var tableOffsety: CGFloat = 0.0

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            calendarConfigWithScrollEvents("Top", month: Int(month[indexPath.row])!, year: Int(year[indexPath.row])!)
        }
        if indexPath.row == (cellData.count - 1){
            calendarConfigWithScrollEvents("Bottom", month: Int(month[indexPath.row])!, year: Int(year[indexPath.row])!)
        }

    }

    func calendarConfigWithScrollEvents(type: String, var month: Int, var year: Int){
        switch(type){
        case "Top":
            month -= 1
            if month == 0 {
                month = 12
                year -= 1
            }
            cellData.insert("CalendarTitle", atIndex: 0)
            cellData.insert("CalendarDate", atIndex: 1)
            self.month.insert("\(month)", atIndex: 0)
            self.month.insert("\(month)", atIndex: 1)
            self.year.insert("\(year)", atIndex: 0)
            self.year.insert("\(year)", atIndex: 1)
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.contentOffset.y += 314.0
                self.tableView.reloadData()
            }
            break
        default:
            month += 1
            if month == 13 {
                month = 1
                year += 1
            }
            cellData.append("CalendarTitle")
            cellData.append("CalendarDate")
            self.month.append("\(month)")
            self.month.append("\(month)")
            self.year.append("\(year)")
            self.year.append("\(year)")
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
            break
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch(cellData[indexPath.row]){
        case "CalendarTitle":
            return 50
        default:
            return 264
        }
    }

    func getDateString(month: Int, year: Int)->String {
        if lang == "en" {
            let tmpArr = ["January","February","March","April","May","June","July","August","September","October","November","December"]
            return "\(tmpArr[month - 1]) \(year)"
        }else{
            return "\(year)年\(month)月"
        }
    }


    //basepath
    let baseUrl: NSURL = globalvar.API_URL
    var reservedDate = [String]()
    func getReserved(){
        Reservation.reserved.removeAll()

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
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary {
                        
                        dispatch_async(dispatch_get_main_queue()){
                            if let resultArray = json.valueForKey("result") as? NSArray {
                                if let fields = resultArray.valueForKey("fields") as? NSArray {
                                    for data in fields {
                                        let date = data.valueForKey("start") as! String
                                        let dateArr = date.characters.split{$0 == " "}.map(String.init)
                                        Reservation.reserved.append(dateArr[0])
                                    }
                                }
                            }
                            
                            self.prepareCalendarData()
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

    @IBAction func viewReservation(sender: AnyObject) {
        ReservationPrepareCreate.calendar = false
        ReservationPrepareCreate.date = ""
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("ViewReservation") as! ViewReservation
        let transition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")

        presentViewController(vc, animated: false, completion: nil)
    }

}


class CalendarTitle: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(0, 0, self.frame.width, 50)
        textLabel?.textAlignment = .Center
        textLabel?.textColor = UIColor(hexString: "#EABD7A")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CalendarTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var year:Int = 0
    var month:Int = 0

    let calendarDate: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    var calendarYear:Int = 0
    var calendarDay:Int = 0
    var calendarMonth:Int = 0
    var calendarCurrent: String = ""

    var monthString = [String]()
    var yearString = [String]()
    var dayString = [String]()


    var calendarDays = [String]()
    var calendarDates = [String]()
    var calendarDaysWords = [String]()

    var checkDate:Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRectMake(0, 0, self.frame.width, 50)
        textLabel?.textAlignment = .Center
        textLabel?.textColor = UIColor(hexString: "#EABD7A")

        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        calendarYear =  components.year
        calendarMonth = components.month
        calendarDay = components.day

        calendarDate.registerClass(CalendarDateCell.self, forCellWithReuseIdentifier: "Calendar")

        calendarDate.scrollEnabled = false

        calendarCurrent = "\(calendarYear)-\(calendarMonth)-\(calendarDay)"
        if month == 0 && year == 0 {
            month = calendarMonth
            year = calendarYear
        }

        configCalendar(month, year: year)

        configCalendar(month, year: year)

        calendarDate.reloadData()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        didLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didLayout(){
        calendarDate.reloadData()

        calendarDate.delegate = self
        calendarDate.dataSource = self

        var layoutwidth:CGFloat = 0.0
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        if identifier.containsString("iPad") || identifier.containsString("ipad") || identifier.containsString("x86_64") {
            layoutwidth = self.frame.width / 7
        }else if identifier.containsString("iPhone5,2") || identifier.containsString("iPhone5,1"){
            layoutwidth = self.frame.width / 7
        }else{
            layoutwidth = (self.frame.width + 20) / 7
        }

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSizeMake(layoutwidth, 44)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        calendarDate.collectionViewLayout = layout

        addSubview(calendarDate)

        calendarDate.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        calendarDate.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        calendarDate.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        calendarDate.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Calendar", forIndexPath: indexPath) as! CalendarDateCell
        cell.labelIndicator.hidden = true
        if dayString[indexPath.row] != "" {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-d"
            let monthStr = String(format: "%02d", Int(monthString[indexPath.row])!)
            let dayStr = String(format: "%02d", Int(dayString[indexPath.row])!)
            let date2 = "\(yearString[indexPath.row])-\(monthStr)-\(dayStr)"
            if checkDate(calendarCurrent, string2: date2) == "GreaterThan" {
                calendarDates[indexPath.row] = date2
                cell.dateLabel.textColor = UIColor.blackColor()
                cell.dateLabel.font = UIFont.systemFontOfSize(16)
                if Reservation.reserved.contains("\(date2)") {
                        cell.labelIndicator.hidden = false
                }
            }else if checkDate(calendarCurrent, string2: date2) == "LessThan" {
                cell.dateLabel.textColor = UIColor.grayColor()
                cell.dateLabel.font = UIFont.systemFontOfSize(16)
                    if Reservation.reserved.contains("\(date2)") {
                        cell.labelIndicator.hidden = false
                }
            }else{
                calendarDates[indexPath.row] = date2
                cell.dateLabel.font = UIFont.boldSystemFontOfSize(16)
                cell.dateLabel.textColor = UIColor.blackColor()
                if Reservation.reserved.contains("\(date2)") {
                    cell.labelIndicator.hidden = false
                }
            }
        }
        cell.dateLabel.text = dayString[indexPath.row]
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if calendarDates[indexPath.row] != "NoDates" {
            ReservationPrepareCreate.calendar = true
            ReservationPrepareCreate.date = calendarDates[indexPath.row]
            ReservationPrepareCreate.day = getDayOfWeek(calendarDates[indexPath.row])

            NSNotificationCenter.defaultCenter().postNotificationName("openReservation", object: nil, userInfo: nil)
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
            if(lang == "en"){ return "Mon" }else{ return "月" }
        case 3:
            if(lang == "en"){ return "Tue" }else{ return "火" }
        case 4:
            if(lang == "en"){ return "Wed" }else{ return "水" }
        case 5:
            if(lang == "en"){ return "Thu" }else{ return "木" }
        case 6:
            if(lang == "en"){ return "Fri" }else{ return "金" }
        case 7:
            if(lang == "en"){ return "Sat" }else{ return "土" }
        default:
            if(lang == "en"){ return "Sun" }else{ return "日" }
        }

    }

    func getMonthAsDefusable(month: Int)-> String{
        let tmpArr = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        return "\(tmpArr[month - 1])"
    }

    func checkDate(string1: String, string2: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-d"

        let date1 = dateFormatter.dateFromString(string1)!
        let date2 = dateFormatter.dateFromString(string2)!

        let order = NSCalendar.currentCalendar().compareDate(date1, toDate: date2, toUnitGranularity: .Day)

        switch order {
        case .OrderedAscending :
            return "GreaterThan"
        case .OrderedDescending :
            return "LessThan"
        default :
            return "Equal"
        }
    }

    func configCalendar(month: Int, year: Int){
        dayString.removeAll()
        calendarDates.removeAll()
        yearString.removeAll()
        monthString.removeAll()
        var startBool:Bool = false
        // Get starting day of the month
        let startDay = getStartDay(month, forYear: year)
        // Get ending day of the month
        let endDay = getLastDay(month, forYear: year)
        // Number of Days to present
        var numDays:Int = 1
        //Loop 42 Cell Data ( 6 weeks Calendar )
        for var x = 1 ; x <= 42 ; x++ {
            // Check if x is equal to startday by using modulo
            // and if start date isn't set on cell
            if (x % startDay) == 0 && !startBool {
                // Add Data to Global Variable
                dayString.append(String(numDays))
                calendarDates.append("NoDates")
                // Set Start Bool to true
                startBool = true
                // add numDays
                numDays += 1
            }else{
                // If start date not yet set
                if !startBool {
                    // append empty string
                    dayString.append("")
                    calendarDates.append("NoDates")
                }else if numDays <= endDay! {
                    dayString.append(String(numDays))
                    calendarDates.append("NoDates")
                    numDays += 1
                } else if numDays > endDay! {
                    dayString.append("")
                    calendarDates.append("NoDates")
                }
            }
            monthString.append(String(month))
            yearString.append(String(year))

        }
    }

    func getStartDay(month: Int, forYear year: Int) -> Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        let date = dateFormatter.dateFromString("\(year)-\(month)-01")
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let weekday = calendar.component(NSCalendarUnit.Weekday, fromDate: date!)
        
        return weekday
    }

    func getLastDay(month: Int, forYear year: Int) -> Int? {
        let calendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-d"
        let date = dateFormatter.dateFromString("\(year)-\(month)-01")

        let components = calendar.components([.Year, .Month], fromDate: date!)
        let startOfMonth = calendar.dateFromComponents(components)!

        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calendar.dateByAddingComponents(comps2, toDate: startOfMonth, options: [])!
        let endMonthString = String(dateFormatter.stringFromDate(endOfMonth))
        let tmp = endMonthString.characters.split{$0 == "-"}.map(String.init)
        return Int(tmp[2])
    }


}

class CalendarDateCell: UICollectionViewCell {

    let dateLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let labelIndicator: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.text = "."
        label.textColor = UIColor.grayColor()
        label.font = UIFont.boldSystemFontOfSize(30)
        label.hidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dateLabel)
        addSubview(labelIndicator)
        dateLabel.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        dateLabel.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        labelIndicator.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        labelIndicator.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: 10).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}