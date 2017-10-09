//
//  pickerViewController.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/10/09.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

extension ViewReservation: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
            if syslang == "en" {
                if officeNameEnData[row] != facilityEn {
                    facilityName.text = officeNameEnData[row]
                    facilityEn = officeNameEnData[row]
                    
                    if roomConstraint.constant != 0 {
                        roomConstraint.constant = 0
                        roomName.textColor = UIColor.blackColor()
                    }
                    postOfficeId = officeIdData[row]
                    getRoomByOffice(officeIdData[row], lang: syslang)
                }
            }else {
                if officeNameJpData[row] != facilityJp {
                    facilityName.text = officeNameJpData[row]
                    facilityJp = officeNameJpData[row]
                    
                    if roomConstraint.constant != 0 {
                        roomConstraint.constant = 0
                        roomName.textColor = UIColor.blackColor()
                    }
                    postOfficeId = officeIdData[row]
                    getRoomByOffice(officeIdData[row], lang: syslang)
                }
            }
        }else{
            if syslang == "en" {
                if roomNameEnData[row] != roomEn {
                    roomName.text = roomNameEnData[row]
                    roomEn = roomNameEnData[row]
                    postRoomId = roomIdData[row]
                    getReservationWithID(roomIdData[row])
                }
            }else {
                if roomNameJpData[row] != roomJp {
                    roomName.text = roomNameJpData[row]
                    roomJp = roomNameJpData[row]
                    postRoomId = roomIdData[row]
                    getReservationWithID(roomIdData[row])
                }
            }
        }
    }
}
