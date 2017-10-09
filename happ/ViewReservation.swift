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
    
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let roomSubtitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.backgroundColor = UIColor(hexString: "#E4D4B9")
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
    
    let separator2: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    let separator3: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    let separator4: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    var topViewConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var facilityConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var roomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    var heightForcell = [CGFloat]()
    
    var config = SYSTEM_CONFIG()
    
    //basepath
    let baseUrl: NSURL = NSURL(string: "http://dev.happ.timeriverdesign.com/wp-admin/admin-ajax.php")!
    
    var cellIndentifier = [String]()
    var cellDate = [String]()
    var cellTime = [String]()
    var cellPID = [String]()
    
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
    
    var postOfficeId = String()
    var postRoomId = String()
    var firstLoad:Bool = false
    
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
    
    var facilityEn = String()
    var facilityJp = String()
    var roomEn = String()
    var roomJp = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableReserved.registerClass(SubtitleCell.self, forCellReuseIdentifier: "SubtitleCell")
        tableReserved.registerClass(InformationCell.self, forCellReuseIdentifier: "InformationCell")
        tableReserved.registerClass(DataCellWithTitle.self, forCellReuseIdentifier: "DataCellWithTitle")
        tableReserved.registerClass(DataCell.self, forCellReuseIdentifier: "DataCell")
        tableReserved.delegate = self
        tableReserved.dataSource = self
        tableReserved.backgroundColor = UIColor.whiteColor()
        tableReserved.separatorStyle = .None
        tableReserved.editing = false
        
        tableReserved.contentInset = UIEdgeInsetsMake(0, 0, 132, 0)
        
        self.roomSubtitle.text = config.translate("subtitle_room")
        self.facilityLabel.text =  config.translate("lbl_facility")
        self.roomLabel.text = config.translate("label_room")
        
        let tapOfficeView = UITapGestureRecognizer(target: self, action: "tapOffice:")
        self.selectFacilityView.addGestureRecognizer(tapOfficeView)
        
        let tapRoomView = UITapGestureRecognizer(target: self, action: "tapRoom:")
        self.selectRoomView.addGestureRecognizer(tapRoomView)
        
        separator2.hidden = true
        separator4.hidden = true
        
        facilitySelect.delegate = self
        facilitySelect.dataSource = self
        
        roomSelect.delegate = self
        roomSelect.dataSource = self
        
        self.navCreate.title = config.translate("button_create")
        
        if !ReservationPrepareCreate.calendar {
            navCreate.title = ""
            navCreate.enabled = false
        }
        
        getOffice()
        //        getReservationWithID()
        addSubViews()
        autoLayout()
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navBar.topItem?.title = config.translate("title_reserved")
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
    
    func tapOffice(sender: UIPickerView!){
        if facilityConstraint.constant == 0 {
            facilityConstraint.constant = 100
            facilityName.textColor = UIColor.redColor()
            topViewConstraint.constant = topViewConstraint.constant + 100
            separator2.hidden = false
        }else{
            facilityConstraint.constant = 0
            topViewConstraint.constant = topViewConstraint.constant - 100
            facilityName.textColor = UIColor.blackColor()
            separator2.hidden = true
            tableReserved.layoutIfNeeded()
        }
    }
    
    func tapRoom(sender: UIPickerView!){
        if roomConstraint.constant == 0 {
            roomConstraint.constant = 100
            topViewConstraint.constant = topViewConstraint.constant + 100
            roomName.textColor = UIColor.redColor()
            separator4.hidden = false
        }else{
            roomConstraint.constant = 0
            topViewConstraint.constant = topViewConstraint.constant - 100
            roomName.textColor = UIColor.blackColor()
            separator4.hidden = true
        }
    }
    
    @IBAction func createReservation(sender: AnyObject) {
        CreateDetails.date = ReservationPrepareCreate.date
        CreateDetails.day = ReservationPrepareCreate.day
        CreateDetails.office = facilityName.text!
        CreateDetails.room = roomName.text!
        CreateDetails.officeId = postOfficeId
        CreateDetails.roomId = postRoomId
        
        dispatch_async(dispatch_get_main_queue()){
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewControllerWithIdentifier("CreateReservation") as! CreateReservation
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
}
