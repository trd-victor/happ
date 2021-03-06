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
            firstLoad = false
            didSelectChange = true
            if syslang == "en" {
                if officeNameEnData[row] != facilityEn {
                    CreateDetails.officeId = ""
                    facilityName.text = officeNameEnData[row]
                    facilityEn = officeNameEnData[row]
                    
                    if roomConstraint.constant != 0 {
                        roomConstraint.constant = 0
                        roomName.textColor = UIColor.blackColor()
                    }
                    getRoomByOffice(officeIdData[row], lang: syslang)
                }
            }else {
                if officeNameJpData[row] != facilityJp {
                    CreateDetails.officeId = ""
                    facilityName.text = officeNameJpData[row]
                    facilityJp = officeNameJpData[row]
                    
                    if roomConstraint.constant != 0 {
                        roomConstraint.constant = 0
                        roomName.textColor = UIColor.blackColor()
                    }
                    getRoomByOffice(officeIdData[row], lang: syslang)
                }
            }
        }else{
            if syslang == "en" {
                if roomNameEnData[row] != roomEn {
                    CreateDetails.roomId = ""
                    roomName.text = roomNameEnData[row]
                    roomEn = roomNameEnData[row]
                    postRoomId = roomIdData[row]
                    getReserved(roomIdData[row])
                }
            }else {
                if roomNameJpData[row] != roomJp {
                    CreateDetails.roomId = ""
                    roomName.text = roomNameJpData[row]
                    roomJp = roomNameJpData[row]
                    postRoomId = roomIdData[row]
                    getReserved(roomIdData[row])
                }
            }
        }
    }
}