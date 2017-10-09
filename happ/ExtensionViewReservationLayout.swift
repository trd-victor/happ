//
//  ExtensionViewReservationLayout.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/10/08.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

extension ViewReservation {
    
    func addSubViews(){
        view.addSubview(topView)
        topView.addSubview(roomSubtitle)
        topView.addSubview(selectFacilityView)
        topView.addSubview(selectRoomView)
        selectFacilityView.addSubview(facilityLabel)
        selectFacilityView.addSubview(facilityName)
        topView.addSubview(separator)
        topView.addSubview(facilitySelect)
        topView.addSubview(separator2)
        selectRoomView.addSubview(roomLabel)
        selectRoomView.addSubview(roomName)
        topView.addSubview(separator3)
        topView.addSubview(roomSelect)
        topView.addSubview(separator4)
        
        view.addSubview(viewLoading)
        view.bringSubviewToFront(viewLoading)
        viewLoading.backgroundColor = UIColor.grayColor()
        viewLoading.addSubview(activityLoading)
    }
    
    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        topView.centerXAnchor.constraintEqualToAnchor(tableReserved.centerXAnchor).active = true
        topView.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        topView.widthAnchor.constraintEqualToAnchor(tableReserved.widthAnchor).active = true
        topViewConstraint = topView.heightAnchor.constraintEqualToConstant(132)
        topViewConstraint.active = true
        
        tableReserved.translatesAutoresizingMaskIntoConstraints = false
        tableReserved.topAnchor.constraintEqualToAnchor(topView.bottomAnchor).active = true
        tableReserved.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        tableReserved.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        tableReserved.heightAnchor.constraintEqualToAnchor(view.heightAnchor, constant: -66).active = true
        
        roomSubtitle.centerXAnchor.constraintEqualToAnchor(topView.centerXAnchor).active = true
        roomSubtitle.topAnchor.constraintEqualToAnchor(topView.topAnchor).active = true
        roomSubtitle.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        roomSubtitle.heightAnchor.constraintEqualToConstant(30).active = true
        
        selectFacilityView.topAnchor.constraintEqualToAnchor(roomSubtitle.bottomAnchor).active = true
        selectFacilityView.leftAnchor.constraintEqualToAnchor(topView.leftAnchor).active = true
        selectFacilityView.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        selectFacilityView.heightAnchor.constraintEqualToConstant(50).active = true
        
        facilityLabel.topAnchor.constraintEqualToAnchor(roomSubtitle.bottomAnchor).active = true
        facilityLabel.leftAnchor.constraintEqualToAnchor(topView.leftAnchor, constant: 10).active = true
        facilityLabel.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        facilityLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        facilityName.topAnchor.constraintEqualToAnchor(roomSubtitle.bottomAnchor).active = true
        facilityName.leftAnchor.constraintEqualToAnchor(topView.leftAnchor, constant: 100).active = true
        facilityName.widthAnchor.constraintEqualToAnchor(topView.widthAnchor, constant: -110).active = true
        facilityName.heightAnchor.constraintEqualToConstant(50).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.leftAnchor.constraintEqualToAnchor(topView.leftAnchor, constant: 10).active = true
        separator.topAnchor.constraintEqualToAnchor(selectFacilityView.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        facilitySelect.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        facilitySelect.centerXAnchor.constraintEqualToAnchor(topView.centerXAnchor).active = true
        facilitySelect.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        facilityConstraint = facilitySelect.heightAnchor.constraintEqualToConstant(0)
        facilityConstraint.active = true
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.leftAnchor.constraintEqualToAnchor(topView.leftAnchor, constant: 10).active = true
        separator2.topAnchor.constraintEqualToAnchor(facilitySelect.bottomAnchor).active = true
        separator2.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        separator2.heightAnchor.constraintEqualToConstant(1).active = true
        
        selectRoomView.topAnchor.constraintEqualToAnchor(separator2.bottomAnchor).active = true
        selectRoomView.leftAnchor.constraintEqualToAnchor(topView.leftAnchor).active = true
        selectRoomView.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        selectRoomView.heightAnchor.constraintEqualToConstant(50).active = true
        
        roomLabel.topAnchor.constraintEqualToAnchor(selectRoomView.topAnchor).active = true
        roomLabel.leftAnchor.constraintEqualToAnchor(topView.leftAnchor, constant: 10).active = true
        roomLabel.widthAnchor.constraintEqualToAnchor(topView.widthAnchor, constant: -10).active = true
        roomLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        roomName.topAnchor.constraintEqualToAnchor(selectRoomView.topAnchor).active = true
        roomName.leftAnchor.constraintEqualToAnchor(topView.leftAnchor, constant: 100).active = true
        roomName.widthAnchor.constraintEqualToAnchor(topView.widthAnchor, constant: -110).active = true
        roomName.heightAnchor.constraintEqualToConstant(50).active = true
        
        separator3.translatesAutoresizingMaskIntoConstraints = false
        separator3.leftAnchor.constraintEqualToAnchor(topView.leftAnchor, constant: 10).active = true
        separator3.topAnchor.constraintEqualToAnchor(selectRoomView.bottomAnchor).active = true
        separator3.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        separator3.heightAnchor.constraintEqualToConstant(1).active = true
        
        roomSelect.topAnchor.constraintEqualToAnchor(separator3.bottomAnchor).active = true
        roomSelect.centerXAnchor.constraintEqualToAnchor(topView.centerXAnchor).active = true
        roomSelect.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        roomConstraint = roomSelect.heightAnchor.constraintEqualToConstant(0)
        roomConstraint.active = true
        
        separator4.translatesAutoresizingMaskIntoConstraints = false
        separator4.leftAnchor.constraintEqualToAnchor(topView.leftAnchor, constant: 10).active = true
        separator4.topAnchor.constraintEqualToAnchor(roomSelect.bottomAnchor).active = true
        separator4.widthAnchor.constraintEqualToAnchor(topView.widthAnchor).active = true
        separator4.heightAnchor.constraintEqualToConstant(1).active = true
        
        viewLoading.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        viewLoading.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        viewLoading.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        viewLoading.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        activityLoading.centerXAnchor.constraintEqualToAnchor(viewLoading.centerXAnchor).active = true
        activityLoading.centerYAnchor.constraintEqualToAnchor(viewLoading.centerYAnchor).active = true
        activityLoading.widthAnchor.constraintEqualToAnchor(viewLoading.widthAnchor).active = true
        activityLoading.heightAnchor.constraintEqualToAnchor(viewLoading.heightAnchor).active = true
    }
    
}