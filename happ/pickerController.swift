//
//  pickerController.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/10/01.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

extension CreateReservation: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == facilitySelect {
            return officeIdData.count
        }
        return roomIdData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let config = SYSTEM_CONFIG()
        let syslang = config.getSYS_VAL("AppLanguage") as! String
        
        if pickerView == facilitySelect {
            if syslang == "en" {
                return officeNameEnData[row]
            }else {
                return officeNameJpData[row]
            }
        }else{
            if syslang == "en" {
                return roomNameEnData[row]
            }else {
                return roomNameJpData[row]
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let config = SYSTEM_CONFIG()
        let syslang = config.getSYS_VAL("AppLanguage") as! String
        
        if pickerView == facilitySelect {
            if syslang == "en" {
                facilityName.text = officeNameEnData[row]
            }else {
                facilityName.text = officeNameJpData[row]
            }
            if roomConstraint.constant != 0 {
                roomConstraint.constant = 0
                scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height - 100)
                roomName.textColor = UIColor.blackColor()
                separator6.hidden = true
            }
            firstLoad = false
            getRoomByOffice(officeIdData[row], lang: syslang)
        }else{
            if syslang == "en" {
                roomName.text = roomNameEnData[row]
            }else {
                roomName.text = roomNameJpData[row]
            }
            postRoomId = roomIdData[row]
            getReserved(roomIdData[row])
        }
    }   
}