//
//  Extension+VR+CollectionView.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/27.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

extension ViewReservation {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SubtitleCell", forIndexPath: indexPath) as! SubtitleCell
            cell.lblTitle.text = "Test"
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("InformationCell", forIndexPath: indexPath) as! InformationCell
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
}
