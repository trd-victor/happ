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
    var startDate:Int = 0
    var numDays:Int = 0
    var lastDay: Int = 0
    
    var calendarYear:Int = 0
    var calendarDay:Int = 0
    var calendarMonth:Int = 0
    var calendarCurrent: String = ""
    
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
        
        let swipeUpward = UISwipeGestureRecognizer(target: self, action: "swipeUpward:")
        swipeUpward.direction = .Down
        let swipeDownward = UISwipeGestureRecognizer(target: self, action: "swipeDownward:")
        swipeDownward.direction = .Up
        
        view.addGestureRecognizer(swipeUpward)
        view.addGestureRecognizer(swipeDownward)
        loadCalendar()
        autoLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        let config = SYSTEM_CONFIG()
        self.navBar.topItem?.title = config.translate("title_room_reservation")
    }
    
    func swipeUpward(gest: UISwipeGestureRecognizer){
        if calendarMonth == 1 {
            calendarYear -= 1
            calendarMonth = 12
        }else{
            calendarMonth -= 1
        }
        loadCalendar()
    }
    
    func swipeDownward(gest: UISwipeGestureRecognizer){
        if calendarMonth == 12 {
            calendarYear += 1
            calendarMonth = 1
        }else{
            calendarMonth += 1
        }
        loadCalendar()
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
    
    var lang: String = ""
    
    func loadCalendar(){
        
        var month = ""
        
        if lang == "en" {
            let tmpArr = ["January","February","March","April","May","June","July","August","September","October","November","December"]
            month = "\(tmpArr[self.calendarMonth-1]) \(self.calendarYear)"
        }else{
            month = "\(self.calendarYear)年\(self.calendarMonth)月"
        }
        
        self.lblMonth.text = String(month)
        
        self.numDays = 0
        
        self.startDate = self.getStartDay(Int(self.calendarMonth),forYear: Int(self.calendarYear))
        self.getLastDay(Int(self.calendarMonth),forYear: Int(self.calendarYear))
        self.lastDay = self.getLastDay(Int(self.calendarMonth),forYear: Int(self.calendarYear))!
        self.calendarDays.removeAll()
        self.calendarDates.removeAll()
        self.calendarDaysWords.removeAll()
        self.calendarCollectionView.reloadData()
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
        calendarCollectionView.heightAnchor.constraintEqualToConstant(400).active = true
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    var calendarDays = [String]()
    var calendarDates = [String]()
    var calendarDaysWords = [String]()
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCell
        if indexPath.row >= (startDate - 1) && indexPath.row <= (lastDay + (startDate - 2) ) {
            if numDays < lastDay  {
                numDays += 1
            }
            if calendarDays.indices.contains(indexPath.row) {
                cell.lblDate.text = calendarDays[indexPath.row]
            }else{
                calendarDays.append(String(numDays))
                cell.lblDate.text = String(numDays)
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-d"
            let date2 = "\(calendarYear)-\(calendarMonth)-\(numDays)"
            
            if checkDate(calendarCurrent, string2: date2) == "GreaterThan" {
                calendarDates.append("\(calendarYear)-\(calendarMonth)-\(numDays)")
                cell.lblDate.textColor = UIColor.blackColor()
                cell.lblDate.font = UIFont.systemFontOfSize(16)
            }else if checkDate(calendarCurrent, string2: date2) == "LessThan" {
                calendarDates.append("NoDates")
                cell.lblDate.textColor = UIColor.grayColor()
                cell.lblDate.font = UIFont.systemFontOfSize(16)
            }else{
                calendarDates.append("NoDates")
                cell.lblDate.font = UIFont.boldSystemFontOfSize(16)
                cell.lblDate.textColor = UIColor.blackColor()
            }
            
        }else{
            if calendarDays.indices.contains(indexPath.row) {
                cell.lblDate.text = calendarDays[indexPath.row]
            }else{
                calendarDates.append("NoDates")
                calendarDaysWords.append("None")
                calendarDays.append("")
                cell.lblDate.text = ""
            }
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if calendarDates[indexPath.row] != "NoDates" {
            CreateDetails.date = calendarDates[indexPath.row]
            CreateDetails.day = getDayOfWeek(calendarDates[indexPath.row])
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewControllerWithIdentifier("CreateReservation") as! CreateReservation
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
            presentViewController(vc, animated: false, completion: nil)
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
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("ViewReservation") as! ViewReservation
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(vc, animated: false, completion: nil)
    }
}
