//
//  CreateReservation.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/26.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

struct CreateDetails {
    static var date:String = ""
    static var day:String = ""
    static var office:String = ""
    static var officeId: String = ""
    static var room:String = ""
    static var roomId: String = ""
}

class CreateReservation: UIViewController {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var navCreate: UIBarButtonItem!
    
    var didSelectChange: Bool = false
    
    let config = SYSTEM_CONFIG()
    var lang = ""
    
    let roomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#E4D4B9")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let roomSubtitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let facilityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.alpha = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let facilityName: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectFacilityView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let facilitySelect: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let roomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.alpha = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let roomName: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let selectRoomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let roomSelect: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    let makeReservation: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.backgroundColor = UIColor(hexString: "#E4D4B9")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.alpha = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startName: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let endLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.alpha = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endName: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separator2: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    let startTime: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .Time
        picker.minuteInterval = 30
        picker.locale = NSLocale(localeIdentifier: "da_DK")
        return picker
    }()
    
    let separator3: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    let endTime: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .Time
        picker.minuteInterval = 30
        picker.locale = NSLocale(localeIdentifier: "da_DK")
        return picker
    }()
    
    let separator4: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    let reservedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.backgroundColor = UIColor(hexString: "#E4D4B9")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separator5: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    let separator6: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
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
    
    var facility = String()
    var room = String()
    
    var facilityConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var roomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var startTimeConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var endTimeConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    @IBAction func navBar(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("reloadCalendar", object: nil, userInfo: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
     
    //basepath
    let baseUrl: NSURL = globalvar.API_URL
    
    var dataView = [UIView]()
    var dataLabel = [UILabel]()
    var dataSeparator = [UIView]()
    
    var dataTime = [String]()
    var dataUserId = [String]()
    
    var officeIdData = [String]()
    var officeNameEnData = [String]()
    var officeNameJpData = [String]()
    var roomIdData = [String]()
    var roomNameEnData = [String]()
    var roomNameJpData = [String]()
    
    var postRoomId = String()
    
    var firstLoad:Bool = false
    
    var facilityEn = String()
    var facilityJp = String()
    var roomEn = String()
    var roomJp = String()
    
    func tapStart(sender: UITapGestureRecognizer){
        if startTimeConstraint.constant == 0 {
            startTimeConstraint.constant = 200
            //            scrollView.contentSize = CGRectM
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + 200)
            separator3.hidden = false
            startName.textColor = UIColor.redColor()
        }else{
            startTimeConstraint.constant = 0
            separator3.hidden = true
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height - 200)
            startName.textColor = UIColor.blackColor()
        }
    }
    
    func tapEnd(sender: UITapGestureRecognizer){
        if endTimeConstraint.constant == 0 {
            endTimeConstraint.constant = 200
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + 200)
            separator4.hidden = false
            endName.textColor = UIColor.redColor()
        }else{
            endTimeConstraint.constant = 0
            separator4.hidden = true
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height - 200)
            endName.textColor = UIColor.blackColor()
        }
    }
    
    func startPicker(sender: UIDatePicker!){
        let date = sender.date
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: date)
        
        
        startName.text = "\(String(format: "%02d", components.hour)):\(String(format: "%02d", components.minute))"
    }
    
    func endPicker(sender: UIDatePicker!){
        let date = sender.date
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: date)
        
        
        endName.text = "\(String(format: "%02d", components.hour)):\(String(format: "%02d", components.minute))"
    }
    
    func tapOffice(sender: UIPickerView!){
        if facilityConstraint.constant == 0 {
            facilityConstraint.constant = 100
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + 100)
            facilityName.textColor = UIColor.redColor()
            separator5.hidden = false
        }else{
            facilityConstraint.constant = 0
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height - 100)
            facilityName.textColor = UIColor.blackColor()
            separator5.hidden = true
        }
    }
    
    func tapRoom(sender: UIPickerView!){
        if roomConstraint.constant == 0 {
            roomConstraint.constant = 100
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + 100)
            roomName.textColor = UIColor.redColor()
            separator6.hidden = false
        }else{
            roomConstraint.constant = 0
            scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height - 100)
            roomName.textColor = UIColor.blackColor()
            separator6.hidden = true
        }
    }
    
    @IBAction func navCreate(sender: AnyObject) {
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }

        viewLoading.hidden = false
        activityLoading.startAnimating()
        let sdate = "\(CreateDetails.date) \(startName.text!)"
        let edate = "\(CreateDetails.date) \(endName.text!)"
        postReservation(postRoomId,sdate: sdate, edate: edate)
    }
    
    
}
