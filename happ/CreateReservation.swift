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
}

class CreateReservation: UIViewController {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var navCreate: UIBarButtonItem!
    
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
    
    var startTimeConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var endTimeConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    @IBAction func navBar(sender: AnyObject) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    //basepath
    let baseUrl: NSURL = NSURL(string: "https://happ.biz/wp-admin/admin-ajax.php")!
    
    var dataView = [UIView]()
    var dataLabel = [UILabel]()
    var dataSeparator = [UIView]()
    
    var dataTime = [String]()
    var dataUserId = [String]()
    
    func tapStart(sender: UITapGestureRecognizer){
        if startTimeConstraint.constant == 0 {
            startTimeConstraint.constant = 200
            separator3.hidden = false
            startName.textColor = UIColor.redColor()
        }else{
            startTimeConstraint.constant = 0
            separator3.hidden = true
            startName.textColor = UIColor.blackColor()
        }
    }
    
    func tapEnd(sender: UITapGestureRecognizer){
        if endTimeConstraint.constant == 0 {
            endTimeConstraint.constant = 200
            separator4.hidden = false
            endName.textColor = UIColor.redColor()
        }else{
            endTimeConstraint.constant = 0
            separator4.hidden = true
            endName.textColor = UIColor.blackColor()
        }
    }
    
    func startPicker(sender: UIDatePicker!){
        let date = sender.date
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: date)

        
        startName.text = "\(components.hour):\(components.minute)"
    }
    
    func endPicker(sender: UIDatePicker!){
        let date = sender.date
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: date)
        
        
        endName.text = "\(components.hour):\(components.minute)"
    }
    
    @IBAction func navCreate(sender: AnyObject) {
        let sdate = "\(CreateDetails.date) \(startName.text!)"
        let edate = "\(CreateDetails.date) \(endName.text!)"
        postReservation(sdate, edate: edate)
    }
    
    
}
