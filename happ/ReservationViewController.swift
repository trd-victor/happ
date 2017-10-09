//
//  ReservationViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 14/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var calendarCollectionView: UICollectionView!
    @IBOutlet weak var viewDaysoftheWeeks: UIView!
    
    let lblMon: UILabel = UILabel()
    let lblTue: UILabel = UILabel()
    let lblWed: UILabel = UILabel()
    let lblThu: UILabel = UILabel()
    let lblFri: UILabel = UILabel()
    let lblSat: UILabel = UILabel()
    let lblSun: UILabel = UILabel()
    let lblMonth: UILabel = UILabel()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        viewDaysoftheWeeks.addSubview(lblMonth)
        viewDaysoftheWeeks.addSubview(lblMon)
        viewDaysoftheWeeks.addSubview(lblTue)
        viewDaysoftheWeeks.addSubview(lblWed)
        viewDaysoftheWeeks.addSubview(lblThu)
        viewDaysoftheWeeks.addSubview(lblFri)
        viewDaysoftheWeeks.addSubview(lblSat)
        viewDaysoftheWeeks.addSubview(lblSun)
        lblMonth.textAlignment = .Center
        lblMonth.textColor = UIColor(hexString: "#EABD7A")
        lblMonth.font = UIFont.boldSystemFontOfSize(18)
        
        calendarCollectionView.collectionViewLayout = layout
        calendarCollectionView.registerClass(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        calendarCollectionView.backgroundColor = UIColor.clearColor()
        calendarCollectionView.showsVerticalScrollIndicator = false
        configCalendar(calendarMonth, year: calendarYear)
        
        autoLayout()
    }
    
    var firstLoad:Bool = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !firstLoad {
            dispatch_async(dispatch_get_main_queue()){
                let indexPath = NSIndexPath(forItem: 43, inSection: 0)
                self.calendarCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Top, animated: false)
            }
            firstLoad = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        let config = SYSTEM_CONFIG()
        self.navBar.topItem?.title = config.translate("title_room_reservation")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let config = SYSTEM_CONFIG()
        lang = config.getSYS_VAL("AppLanguage") as! String
        
        lblMon.text = (lang == "en") ? "Mon" : "日"
        lblMon.textAlignment = .Center
        lblTue.text = (lang == "en") ? "Tue" : "月"
        lblTue.textAlignment = .Center
        lblWed.text = (lang == "en") ? "Wed" : "火"
        lblWed.textAlignment = .Center
        lblThu.text = (lang == "en") ? "Thu" : "水"
        lblThu.textAlignment = .Center
        lblFri.text = (lang == "en") ? "Fri" : "木"
        lblFri.textAlignment = .Center
        lblSat.text = (lang == "en") ? "Sat" : "金"
        lblSat.textAlignment = .Center
        lblSun.text = (lang == "en") ? "Sun" : "土"
        lblSun.textAlignment = .Center
        
        var month = ""
        
        if lang == "en" {
            let tmpArr = ["January","February","March","April","May","June","July","August","September","October","November","December"]
            month = "\(tmpArr[self.calendarMonth-1]) \(self.calendarYear)"
        }else{
            month = "\(self.calendarYear)年\(self.calendarMonth)月"
        }
        
        self.lblMonth.text = String(month)
        
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
        
        lblMon.translatesAutoresizingMaskIntoConstraints = false
        lblMon.leftAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.leftAnchor).active = true
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
        
        lblSun.translatesAutoresizingMaskIntoConstraints = false
        lblSun.leftAnchor.constraintEqualToAnchor(lblSat.rightAnchor).active = true
        lblSun.centerYAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.centerYAnchor).active = true
        lblSun.widthAnchor.constraintEqualToConstant(layoutwidth).active = true
        lblSun.heightAnchor.constraintEqualToConstant(44).active = true
        
        lblMonth.translatesAutoresizingMaskIntoConstraints = false
        lblMonth.centerXAnchor.constraintEqualToAnchor(mainView.centerXAnchor).active = true
        lblMonth.topAnchor.constraintEqualToAnchor(viewDaysoftheWeeks.bottomAnchor).active = true
        lblMonth.widthAnchor.constraintEqualToAnchor(mainView.widthAnchor).active = true
        lblMonth.heightAnchor.constraintEqualToConstant(44).active = true
        
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        calendarCollectionView.topAnchor.constraintEqualToAnchor(lblMonth.bottomAnchor).active = true
        calendarCollectionView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        calendarCollectionView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        calendarCollectionView.heightAnchor.constraintEqualToConstant(264).active = true
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayString.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCell
        
        let count = dayString.count / 42
        for var x = 1 ; x <= count ; x++ {
            if ( indexPath.row) >= (19 + ((x - 1) * 42)) {
                if ( indexPath.row) <= (31 + ((x - 1) * 42)) {
                    lblMonth.text = getDateString(Int(monthString[indexPath.row])!,year: Int(yearString[indexPath.row])!)
                }
            }
        }
        if dayString[indexPath.row] != "" {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-d"
            let date2 = "\(yearString[indexPath.row])-\(monthString[indexPath.row])-\(dayString[indexPath.row])"
            
            if checkDate(calendarCurrent, string2: date2) == "GreaterThan" {
                calendarDates[indexPath.row] = date2
                cell.lblDate.textColor = UIColor.blackColor()
                cell.lblDate.font = UIFont.systemFontOfSize(16)
            }else if checkDate(calendarCurrent, string2: date2) == "LessThan" {
                cell.lblDate.textColor = UIColor.grayColor()
                cell.lblDate.font = UIFont.systemFontOfSize(16)
            }else{
                cell.lblDate.font = UIFont.boldSystemFontOfSize(16)
                cell.lblDate.textColor = UIColor.blackColor()
            }
        }
        cell.lblDate.text = dayString[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if calendarDates[indexPath.row] != "NoDates" {
            ReservationPrepareCreate.calendar = true
            ReservationPrepareCreate.date = calendarDates[indexPath.row]
            ReservationPrepareCreate.day = getDayOfWeek(calendarDates[indexPath.row])
            
            dispatch_async(dispatch_get_main_queue()){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewControllerWithIdentifier("ViewReservation") as! ViewReservation
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    var contentOffset: CGFloat = 0.0
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.contentOffset.y < 264 && collectionView.contentOffset.y > contentOffset {
            contentOffset = collectionView.contentOffset.y
            collectionView.contentOffset.y = collectionView.contentOffset.y + 264
            configureCalendarWithEvents("Top", month: Int(monthString[indexPath.row])!,year: Int(yearString[indexPath.row])!)
        }
        if indexPath.row == (dayString.count - 16) {
            configureCalendarWithEvents("append", month: Int(monthString[indexPath.row])!,year: Int(yearString[indexPath.row])!)
        }
    }
    
    func configureCalendarWithEvents(type: String, var month: Int, var year: Int) {
        switch(type) {
        case "Top":
            month -= 1
            if month == 0 {
                month = 12
                year -= 1
            }
            // Variable to check if start date is set on cell
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
                    dayString.insert(String(numDays), atIndex: (x - 1))
                    calendarDates.insert("NoDates", atIndex: (x - 1))
                    // Set Start Bool to true
                    startBool = true
                    // add numDays
                    numDays += 1
                }else{
                    // If start date not yet set
                    if !startBool {
                        // append empty string
                        dayString.insert("", atIndex: (x - 1))
                        calendarDates.insert("NoDates", atIndex: (x - 1))
                    }else if numDays <= endDay {
                        dayString.insert(String(numDays), atIndex: (x - 1))
                        calendarDates.insert("NoDates", atIndex: (x - 1))
                        numDays += 1
                    } else if numDays > endDay {
                        dayString.insert("", atIndex: (x - 1))
                        calendarDates.insert("NoDates", atIndex: (x - 1))
                    }
                }
                monthString.insert(String(month), atIndex: (x - 1))
                yearString.insert(String(year), atIndex: (x - 1))
            }
            dispatch_async(dispatch_get_main_queue()){
                self.calendarCollectionView.reloadData()
                self.contentOffset = 0.0
            }
            break
        default:
            // Add 1 to month
            month += 1
            // Check Month is equal to 13
            if month == 13 {
                // Set Month to 1
                month = 1
                // Add Year with 1
                year += 1
            }
            // Variable to check if start date is set on cell
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
                    }else if numDays <= endDay {
                        dayString.append(String(numDays))
                        calendarDates.append("NoDates")
                        numDays += 1
                    } else if numDays > endDay {
                        dayString.append("")
                        calendarDates.append("NoDates")
                    }
                }
                monthString.append(String(month))
                yearString.append(String(year))
            }
            dispatch_async(dispatch_get_main_queue()){
                self.calendarCollectionView.reloadData()
            }
            break
        }
    }
    
    func configCalendar(var month: Int, var year: Int){
        // Prepare variables
        // Minus month with 2
        month -= 2
        //Check Month is equal to 0
        if month == 0 {
            // Set month to 12
            month == 0
            // Subtract Year
            year -= 1
        }else if month == -1 { // Check Month is equal to -1
            // Set month to 11
            month == 11
            // Subtract Year
            year -= 1
        }
        
        // Loop and create Caledar Data
        for _ in 1...3 {
            // Add 1 to month
            month += 1
            // Check Month is equal to 13
            if month == 13 {
                // Set Month to 1
                month = 1
                // Add Year with 1
                year += 1
            }
            // Variable to check if start date is set on cell
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
                    }else if numDays <= endDay {
                        dayString.append(String(numDays))
                        calendarDates.append("NoDates")
                        numDays += 1
                    } else if numDays > endDay {
                        dayString.append("")
                        calendarDates.append("NoDates")
                    }
                }
                monthString.append(String(month))
                yearString.append(String(year))
                
            }
        }
    }
    
    func getDateString(month: Int, year: Int)->String {
        let config = SYSTEM_CONFIG()
        lang = config.getSYS_VAL("AppLanguage") as! String
        if lang == "en" {
            let tmpArr = ["January","February","March","April","May","June","July","August","September","October","November","December"]
            return "\(tmpArr[month - 1]) \(year)"
        }else{
            return "\(month)年\(year)月"
        }
        
    }
    
    func getWeeks(month: Int, forYear year: Int) -> Int? {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let comps = NSDateComponents()
        comps.month = month+1
        comps.year = year
        comps.day = 0
        guard let last = calendar.dateFromComponents(comps) else {
            return nil
        }
        // Note: Could get other options as well
        let tag = calendar.components([.WeekOfMonth,.WeekOfYear,
            .YearForWeekOfYear,.Weekday,.Quarter],fromDate: last)
        
        return tag.weekOfMonth
    }
    
    func getStartDay(month: Int, forYear year: Int) -> Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-M-d"
        let date = dateFormatter.dateFromString("\(year)-\(month)-01")
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let weekday = calendar.component(NSCalendarUnit.Weekday, fromDate: date!)
        switch(weekday) {
        case 2:
            return 1
        case 3:
            return 2
        case 4:
            return 3
        case 5:
            return 4
        case 6:
            return 5
        case 7:
            return 6
        default:
            return 7
        }
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
    
    func getDayOfWeek(today:String) -> String {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.dateFromString(today)!
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components([.Weekday, .WeekOfMonth], fromDate: todayDate)
        let weekDay = components.weekday
        
        let config = SYSTEM_CONFIG()
        lang = config.getSYS_VAL("AppLanguage") as! String
        
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
    
    
    @IBAction func viewReservation(sender: AnyObject) {
        ReservationPrepareCreate.calendar = false
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
