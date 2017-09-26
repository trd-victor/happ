//
//  CalendarCustomCell.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/25.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class CalendarCell: UICollectionViewCell {
    
    let lblDate: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lblDate)
        
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        lblDate.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        lblDate.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
