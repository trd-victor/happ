//
//  Extension+Override.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/26.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

extension CreateReservation {
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()){
            // all custom views and labels
            self.addViewsLayout()
            // set all Layout for views and Labels
            self.autoLayout()
        }
        
        let config = SYSTEM_CONFIG()
        let tapStartView = UITapGestureRecognizer(target: self, action: "tapStart:")
        self.startView.addGestureRecognizer(tapStartView)
        
        let tapEndView = UITapGestureRecognizer(target: self, action: "tapEnd:")
        self.endView.addGestureRecognizer(tapEndView)
        
        let tapOfficeView = UITapGestureRecognizer(target: self, action: "tapOffice:")
        self.selectFacilityView.addGestureRecognizer(tapOfficeView)
        
        let tapRoomView = UITapGestureRecognizer(target: self, action: "tapRoom:")
        self.selectRoomView.addGestureRecognizer(tapRoomView)
        
        self.startTime.addTarget(self, action: "startPicker:", forControlEvents: .ValueChanged)
        self.endTime.addTarget(self, action: "endPicker:", forControlEvents: .ValueChanged)
        
        let sdate = self.startTime.date
        let edate = self.endTime.date
        
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: sdate)
        components.hour = 8
        components.minute = 0
        
        self.startTime.setDate(calendar.dateFromComponents(components)!, animated: true)
        components.hour = 23
        components.minute = 0
        self.endTime.setDate(calendar.dateFromComponents(components)!, animated: true)
        
        self.facilitySelect.delegate = self
        self.facilitySelect.dataSource = self
        
        self.roomSelect.delegate = self
        self.roomSelect.dataSource = self
        
        self.navCreate.title = config.translate("button_save")
        self.roomSubtitle.text = config.translate("label_room")
        self.facilityLabel.text =  config.translate("lbl_facility")
        self.roomLabel.text = config.translate("label_room")
        self.makeReservation.text = config.translate("subtitle_make_reservation")
        self.startLabel.text = config.translate("label_start")
        
        
        self.startName.text = "\(String(format: "%02d", 8)):\(String(format: "%02d", 0))"
        
        components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: edate)
        
        self.endLabel.text = config.translate("label_end")
        self.endName.text = "\(String(format: "%02d", 23)):\(String(format: "%02d", 0))"
        self.reservedLabel.text = config.translate("title_reserved")
        
        self.getOffice()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if menu_bar.sessionDeleted {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let menuController = storyBoard.instantiateViewControllerWithIdentifier("Menu") as! MenuViewController
            menuController.logoutMessage(self)
            return
        }
        
        lang = config.getSYS_VAL("AppLanguage") as! String
        let title = CreateDetails.date
        let tmpArr = title.characters.split{$0 == "-"}.map(String.init)
        if lang == "en" {
            navTitle.title = "\(tmpArr[0])-\(tmpArr[1])-\(tmpArr[2]) (\(CreateDetails.day))"
        }else{
            navTitle.title = "\(tmpArr[0])年\(tmpArr[1])月\(tmpArr[2])日 (\(CreateDetails.day))"
        }
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
