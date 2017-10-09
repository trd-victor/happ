//
//  SearchCustomCell.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/18.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class SearchCustomCell: UITableViewCell {
    
    let profileImg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "noPhoto")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 35
        imgView.contentMode = .ScaleAspectFill
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.grayColor()
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clearColor()
        
        textLabel?.frame = CGRectMake(90, textLabel!.frame.origin.y - 10 , textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.frame = CGRectMake(90, detailTextLabel!.frame.origin.y - 3, self.frame.width - 90, detailTextLabel!.frame.height)
        
        detailTextLabel?.font = UIFont.systemFontOfSize(16)
        detailTextLabel?.textColor = UIColor.grayColor()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImg)
        addSubview(separator)
        
        profileImg.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        profileImg.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        profileImg.widthAnchor.constraintEqualToConstant(70).active = true
        profileImg.heightAnchor.constraintEqualToConstant(70).active = true
        
        separator.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        separator.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 65).active = true
        separator.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -65).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
