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
        
        self.selectionStyle = .None;
        
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
        addSubview(separator)
        
        self.selectionStyle = .None;
        
        title.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        title.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        title.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        title.heightAnchor.constraintEqualToConstant(50).active = true
        
        name.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
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

class DataCellWithTitle: UITableViewCell {
    
    let lblTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.backgroundColor = UIColor(hexString: "#E4D4B9")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let lblTime: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .None;
        
        addSubview(lblTitle)
        addSubview(containerView)
        addSubview(lblTime)
        
        lblTitle.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        lblTitle.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        lblTitle.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        lblTitle.heightAnchor.constraintEqualToConstant(30).active = true
        
        containerView.topAnchor.constraintEqualToAnchor(lblTitle.bottomAnchor).active = true
        containerView.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        containerView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        containerView.heightAnchor.constraintEqualToConstant(50).active = true
        
        lblTime.centerXAnchor.constraintEqualToAnchor(containerView.centerXAnchor).active = true
        lblTime.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        lblTime.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor, constant: -20).active = true
        lblTime.heightAnchor.constraintEqualToConstant(50).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DataCell: UITableViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    let lblTime: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
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
        
        self.selectionStyle = .None;
        
        addSubview(containerView)
        addSubview(lblTime)
        addSubview(separator)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        separator.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        containerView.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        containerView.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        containerView.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        containerView.heightAnchor.constraintEqualToConstant(50).active = true
        
        lblTime.centerXAnchor.constraintEqualToAnchor(containerView.centerXAnchor).active = true
        lblTime.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        lblTime.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor, constant: -20).active = true
        lblTime.heightAnchor.constraintEqualToConstant(50).active = true
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}