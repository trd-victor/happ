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
        
        let config = SYSTEM_CONFIG()
        let tapStartView = UITapGestureRecognizer(target: self, action: "tapStart:")
        startView.addGestureRecognizer(tapStartView)
        
        let tapEndView = UITapGestureRecognizer(target: self, action: "tapEnd:")
        endView.addGestureRecognizer(tapEndView)
        
        startTime.addTarget(self, action: "startPicker:", forControlEvents: .ValueChanged)
        endTime.addTarget(self, action: "endPicker:", forControlEvents: .ValueChanged)
        
        // all custom views and labels
        addViewsLayout()
        
        // set all Layout for views and Labels
        autoLayout()
        
        self.navCreate.title = config.translate("button_create")
        roomSubtitle.text = config.translate("subtitle_room")
        facilityLabel.text =  config.translate("lbl_facility")
        facilityName.text = "FUKUOKA"
        roomLabel.text = config.translate("label_room")
        roomName.text = "A"
        makeReservation.text = config.translate("subtitle_make_reservation")
        startLabel.text = config.translate("label_start")
        let sdate = startTime.date
        
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: sdate)
        
        startName.text = "\(String(format: "%02d",components.hour)):\(String(format: "%02d", components.minute))"
        
        let edate = endTime.date
        
        components = calendar.components([NSCalendarUnit.Hour, NSCalendarUnit.Minute] , fromDate: edate)
        
        endLabel.text = config.translate("label_end")
        endName.text = "\(String(format: "%02d",components.hour)):\(String(format: "%02d", components.minute))"
        reservedLabel.text = config.translate("title_reserved")

        
        getReserved()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
