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
    
    var heightForcell = [CGFloat]()
    
    var config = SYSTEM_CONFIG()
    //basepath
    let baseUrl: NSURL = NSURL(string: "http://dev.happ.timeriverdesign.com/wp-admin/admin-ajax.php")!
    
    var cellIndentifier = [String]()
    var cellDate = [String]()
    var cellTime = [String]()
    var cellPID = [String]()
    
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
        
        getReservationWithID()
        
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
        tableReserved.heightAnchor.constraintEqualToAnchor(view.heightAnchor, constant: -66).active = true
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navBar.topItem?.title = config.translate("title_reserved")
    }
    
    @IBAction func navBar(sender: AnyObject) {
        let transition: CATransition = CATransition()
        transition.duration = 0.40
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}
