//
//  File.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/26.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class ViewReservation: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var tableReserved: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableReserved.registerClass(SubtitleCell.self, forCellReuseIdentifier: "SubtitleCell")
        tableReserved.registerClass(InformationCell.self, forCellReuseIdentifier: "InformationCell")
        tableReserved.delegate = self
        tableReserved.dataSource = self
        tableReserved.backgroundColor = UIColor.whiteColor()
        autoLayout()
    }
    
    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        tableReserved.translatesAutoresizingMaskIntoConstraints = false
        tableReserved.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        tableReserved.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        tableReserved.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        tableReserved.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    @IBAction func navBar(sender: AnyObject) {
        let transition: CATransition = CATransition()
        transition.duration = 0.25
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
