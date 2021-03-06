//
//  Extension+AutoLayout.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/26.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

extension CreateReservation {
    
    func addViewsLayout(){
        
        scrollView.addSubview(roomView)
        roomView.addSubview(roomSubtitle)
        scrollView.addSubview(selectFacilityView)
        selectFacilityView.addSubview(facilityLabel)
        selectFacilityView.addSubview(facilityName)
        scrollView.addSubview(facilitySelect)
        scrollView.addSubview(separator)
        scrollView.addSubview(selectRoomView)
        selectRoomView.addSubview(roomLabel)
        selectRoomView.addSubview(roomName)
        scrollView.addSubview(roomSelect)
        scrollView.addSubview(makeReservation)
        scrollView.addSubview(startView)
        startView.addSubview(startLabel)
        startView.addSubview(startName)
        scrollView.addSubview(separator2)
        scrollView.addSubview(startTime)
        scrollView.addSubview(separator3)
        scrollView.addSubview(endView)
        endView.addSubview(endLabel)
        endView.addSubview(endName)
        scrollView.addSubview(separator4)
        scrollView.addSubview(separator5)
        scrollView.addSubview(separator6)
        scrollView.addSubview(endTime)
        scrollView.addSubview(reservedLabel)
        
        view.addSubview(viewLoading)
        view.bringSubviewToFront(viewLoading)
        viewLoading.backgroundColor = UIColor.grayColor()
        viewLoading.addSubview(activityLoading)
        
        separator3.hidden = true
        separator4.hidden = true
        separator5.hidden = true
        separator6.hidden = true
        
    }
    
    func autoLayout(){
        self.navCreate.tintColor = UIColor.whiteColor()
        self.navCreate.titleTextAttributesForState(.Normal)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        scrollView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        scrollView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        scrollView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        scrollView.contentSize = CGSizeMake(320, 700)
        
        roomView.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        roomView.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
        roomView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        roomView.heightAnchor.constraintEqualToConstant(30).active = true
        
        roomSubtitle.centerXAnchor.constraintEqualToAnchor(roomView.centerXAnchor).active = true
        roomSubtitle.centerYAnchor.constraintEqualToAnchor(roomView.centerYAnchor).active = true
        roomSubtitle.widthAnchor.constraintEqualToAnchor(roomView.widthAnchor).active = true
        roomSubtitle.heightAnchor.constraintEqualToConstant(30).active = true
        
        selectFacilityView.topAnchor.constraintEqualToAnchor(roomView.bottomAnchor).active = true
        selectFacilityView.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
        selectFacilityView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        selectFacilityView.heightAnchor.constraintEqualToConstant(50).active = true
        
        facilityLabel.topAnchor.constraintEqualToAnchor(roomView.bottomAnchor).active = true
        facilityLabel.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 10).active = true
        facilityLabel.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        facilityLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        facilityName.topAnchor.constraintEqualToAnchor(roomView.bottomAnchor).active = true
        facilityName.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 100).active = true
        facilityName.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -110).active = true
        facilityName.heightAnchor.constraintEqualToConstant(50).active = true
        
        separator5.translatesAutoresizingMaskIntoConstraints = false
        separator5.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 10).active = true
        separator5.topAnchor.constraintEqualToAnchor(selectFacilityView.bottomAnchor).active = true
        separator5.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator5.heightAnchor.constraintEqualToConstant(1).active = true
        
        facilitySelect.topAnchor.constraintEqualToAnchor(separator5.bottomAnchor).active = true
        facilitySelect.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        facilitySelect.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        facilityConstraint = facilitySelect.heightAnchor.constraintEqualToConstant(0)
        facilityConstraint.active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 10).active = true
        separator.topAnchor.constraintEqualToAnchor(facilitySelect.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        selectRoomView.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        selectRoomView.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
        selectRoomView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        selectRoomView.heightAnchor.constraintEqualToConstant(50).active = true
        
        roomLabel.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        roomLabel.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 10).active = true
        roomLabel.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -10).active = true
        roomLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        roomName.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        roomName.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 100).active = true
        roomName.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -110).active = true
        roomName.heightAnchor.constraintEqualToConstant(50).active = true
        
        separator6.translatesAutoresizingMaskIntoConstraints = false
        separator6.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 10).active = true
        separator6.topAnchor.constraintEqualToAnchor(selectRoomView.bottomAnchor).active = true
        separator6.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator6.heightAnchor.constraintEqualToConstant(1).active = true
        
        roomSelect.topAnchor.constraintEqualToAnchor(roomName.bottomAnchor).active = true
        roomSelect.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        roomSelect.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        roomConstraint = roomSelect.heightAnchor.constraintEqualToConstant(0)
        roomConstraint.active = true
        
        makeReservation.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        makeReservation.topAnchor.constraintEqualToAnchor(roomSelect.bottomAnchor).active = true
        makeReservation.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        makeReservation.heightAnchor.constraintEqualToConstant(30).active = true
        
        startView.topAnchor.constraintEqualToAnchor(makeReservation.bottomAnchor).active = true
        startView.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
        startView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        startView.heightAnchor.constraintEqualToConstant(50).active = true
        
        startLabel.centerXAnchor.constraintEqualToAnchor(startView.centerXAnchor).active = true
        startLabel.centerYAnchor.constraintEqualToAnchor(startView.centerYAnchor).active = true
        startLabel.widthAnchor.constraintEqualToAnchor(startView.widthAnchor, constant: -20).active = true
        startLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        startName.centerXAnchor.constraintEqualToAnchor(startView.centerXAnchor).active = true
        startName.centerYAnchor.constraintEqualToAnchor(startView.centerYAnchor).active = true
        startName.widthAnchor.constraintEqualToAnchor(startView.widthAnchor, constant: -20).active = true
        startName.heightAnchor.constraintEqualToConstant(50).active = true
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 20).active = true
        separator2.topAnchor.constraintEqualToAnchor(startView.bottomAnchor).active = true
        separator2.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator2.heightAnchor.constraintEqualToConstant(1).active = true
        
        startTime.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        startTime.topAnchor.constraintEqualToAnchor(separator2.bottomAnchor).active = true
        startTime.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        startTimeConstraint = startTime.heightAnchor.constraintEqualToConstant(0)
        startTimeConstraint.active = true
        
        separator3.translatesAutoresizingMaskIntoConstraints = false
        separator3.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 20).active = true
        separator3.topAnchor.constraintEqualToAnchor(startTime.bottomAnchor).active = true
        separator3.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator3.heightAnchor.constraintEqualToConstant(1).active = true
        
        endView.topAnchor.constraintEqualToAnchor(separator3.bottomAnchor).active = true
        endView.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
        endView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        endView.heightAnchor.constraintEqualToConstant(50).active = true
        
        endLabel.centerXAnchor.constraintEqualToAnchor(endView.centerXAnchor).active = true
        endLabel.centerYAnchor.constraintEqualToAnchor(endView.centerYAnchor).active = true
        endLabel.widthAnchor.constraintEqualToAnchor(endView.widthAnchor, constant: -20).active = true
        endLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        endName.centerXAnchor.constraintEqualToAnchor(endView.centerXAnchor).active = true
        endName.centerYAnchor.constraintEqualToAnchor(endView.centerYAnchor).active = true
        endName.widthAnchor.constraintEqualToAnchor(endView.widthAnchor, constant: -20).active = true
        endName.heightAnchor.constraintEqualToConstant(50).active = true
        
        separator4.translatesAutoresizingMaskIntoConstraints = false
        separator4.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 20).active = true
        separator4.topAnchor.constraintEqualToAnchor(endLabel.bottomAnchor).active = true
        separator4.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator4.heightAnchor.constraintEqualToConstant(1).active = true
        
        endTime.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        endTime.topAnchor.constraintEqualToAnchor(separator4.bottomAnchor).active = true
        endTime.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        endTimeConstraint = endTime.heightAnchor.constraintEqualToConstant(0)
        endTimeConstraint.active = true
        
        reservedLabel.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        reservedLabel.topAnchor.constraintEqualToAnchor(endTime.bottomAnchor).active = true
        reservedLabel.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        reservedLabel.heightAnchor.constraintEqualToConstant(30).active = true
        
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
