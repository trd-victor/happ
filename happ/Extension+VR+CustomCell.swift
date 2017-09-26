//
//  Extension+VR+CustomCell.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/27.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class SubtitleCell: UITableViewCell {
    
    let lblTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.backgroundColor = UIColor(hexString: "#E4D4B9")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(lblTitle)
        
        lblTitle.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        lblTitle.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        lblTitle.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        lblTitle.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class InformationCell: UITableViewCell {
    
    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.alpha = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.alpha = 0.8
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(title)
        addSubview(name)
        
        title.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        title.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        title.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        title.heightAnchor.constraintEqualToConstant(50).active = true
        
        name.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        name.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        name.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -10).active = true
        name.heightAnchor.constraintEqualToConstant(50).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        separator.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DateCell: UICollectionViewCell {
    
}