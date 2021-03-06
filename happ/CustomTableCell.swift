//
//  CustomTableCell.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/09.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class NoImage: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clearColor()
        
        whiteView.layer.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - 10)
        
        textLabel?.frame = CGRectMake(70, 22, textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFontOfSize(14)
        detailTextLabel?.frame = CGRectMake(10, 55, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFontOfSize(16)
        detailTextLabel?.numberOfLines = 7
        detailTextLabel?.lineBreakMode = .ByTruncatingTail
    }
    
    let btnProfile: TimelineProfileImage = {
        let btn = TimelineProfileImage()
        btn.contentMode = .ScaleAspectFill
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        return btn
    }()
    
    let btnUsername: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel!.textColor = UIColor.blackColor()
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Selected)
        btn.setTitleColor(UIColor.blackColor(), forState: .Focused)
        btn.titleLabel!.lineBreakMode = .ByTruncatingTail
        btn.titleLabel!.font = UIFont.boldSystemFontOfSize(14)
        btn.contentHorizontalAlignment = .Left
        return btn
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    let profileImg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "photo")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 25
        imgView.contentMode = .ScaleAspectFill
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let postDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Right
        label.textColor = UIColor.grayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnDelete: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .ScaleToFill
        btn.frame.size = CGSize(width: 29, height: 34)
        return btn
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(whiteView)
        sendSubviewToBack(whiteView)
        
        addSubview(btnUsername)
        addSubview(btnProfile)
        addSubview(postDate)
        addSubview(btnDelete)
        
        
        btnProfile.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        btnProfile.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        btnProfile.widthAnchor.constraintEqualToConstant(40).active = true
        btnProfile.heightAnchor.constraintEqualToConstant(40).active = true
        
        btnUsername.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 9).active = true
        btnUsername.leftAnchor.constraintEqualToAnchor(btnProfile.rightAnchor, constant: 5).active = true
        btnUsername.widthAnchor.constraintEqualToConstant(120).active = true
        btnUsername.heightAnchor.constraintEqualToConstant(40).active = true
        
        postDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        postDate.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -30).active = true
        postDate.widthAnchor.constraintEqualToConstant(130).active = true
        postDate.heightAnchor.constraintEqualToConstant(34).active = true
        
        btnDelete.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        btnDelete.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        btnDelete.widthAnchor.constraintEqualToConstant(29).active = true
        btnDelete.heightAnchor.constraintEqualToConstant(34).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class SingleImage: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clearColor()
        
        whiteView.layer.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - 10)
        
        textLabel?.frame = CGRectMake(70, 22, textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFontOfSize(14)
        
        detailTextLabel?.frame = CGRectMake(10, 70, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFontOfSize(16)
        detailTextLabel?.numberOfLines = 7
        detailTextLabel?.lineBreakMode = .ByTruncatingTail
    }
    
    let btnProfile: TimelineProfileImage = {
        let btn = TimelineProfileImage()
        btn.contentMode = .ScaleAspectFill
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        return btn
    }()
    
    let btnUsername: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel!.textColor = UIColor.blackColor()
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Selected)
        btn.setTitleColor(UIColor.blackColor(), forState: .Focused)
        btn.titleLabel!.lineBreakMode = .ByTruncatingTail
        btn.titleLabel!.font = UIFont.boldSystemFontOfSize(14)
        btn.contentHorizontalAlignment = .Left
        return btn
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    let profileImg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "photo")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 25
        imgView.contentMode = .ScaleAspectFill
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let postDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.grayColor()
        label.textAlignment = .Right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnDelete: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .ScaleToFill
        btn.frame.size = CGSize(width: 29, height: 34)
        return btn
    }()
    
    let imgContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let imgView1: TimelineImage = {
        let imgView = TimelineImage()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(whiteView)
        sendSubviewToBack(whiteView)
        
        addSubview(btnUsername)
        addSubview(btnProfile)
        addSubview(postDate)
        addSubview(btnDelete)
        addSubview(imgContainer)
        imgContainer.addSubview(imgView1)
        imgContainer.addSubview(indicator)
        imgContainer.bringSubviewToFront(indicator)
        
        btnProfile.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        btnProfile.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        btnProfile.widthAnchor.constraintEqualToConstant(40).active = true
        btnProfile.heightAnchor.constraintEqualToConstant(40).active = true
        
        btnUsername.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 9).active = true
        btnUsername.leftAnchor.constraintEqualToAnchor(btnProfile.rightAnchor, constant: 5).active = true
        btnUsername.widthAnchor.constraintEqualToConstant(120).active = true
        btnUsername.heightAnchor.constraintEqualToConstant(40).active = true
        
        postDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        postDate.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -30).active = true
        postDate.widthAnchor.constraintEqualToConstant(130).active = true
        postDate.heightAnchor.constraintEqualToConstant(34).active = true
        
        btnDelete.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        btnDelete.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        btnDelete.widthAnchor.constraintEqualToConstant(29).active = true
        btnDelete.heightAnchor.constraintEqualToConstant(34).active = true
        
        imgContainer.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -30).active = true
        imgContainer.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        imgContainer.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        imgContainer.heightAnchor.constraintEqualToConstant(300).active = true
        
        indicator.centerXAnchor.constraintEqualToAnchor(imgContainer.centerXAnchor).active = true
        indicator.centerYAnchor.constraintEqualToAnchor(imgContainer.centerYAnchor).active = true
        
        imgView1.centerXAnchor.constraintEqualToAnchor(imgContainer.centerXAnchor).active = true
        imgView1.centerYAnchor.constraintEqualToAnchor(imgContainer.centerYAnchor).active = true
        imgView1.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor).active = true
        imgView1.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class DoubleImage: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clearColor()
        
        whiteView.layer.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - 10)
        
        textLabel?.frame = CGRectMake(70, 22, textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFontOfSize(14)
        
        detailTextLabel?.frame = CGRectMake(10, 70, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFontOfSize(16)
        detailTextLabel?.numberOfLines = 7
        detailTextLabel?.lineBreakMode = .ByTruncatingTail
    }
    
    let btnProfile: TimelineProfileImage = {
        let btn = TimelineProfileImage()
        btn.contentMode = .ScaleAspectFill
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        return btn
    }()
    
    let btnUsername: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel!.textColor = UIColor.blackColor()
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Selected)
        btn.setTitleColor(UIColor.blackColor(), forState: .Focused)
        btn.titleLabel!.lineBreakMode = .ByTruncatingTail
        btn.titleLabel!.font = UIFont.boldSystemFontOfSize(14)
        btn.contentHorizontalAlignment = .Left
        return btn
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    let profileImg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "photo")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 25
        imgView.contentMode = .ScaleAspectFill
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let postDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.grayColor()
        label.textAlignment = .Right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnDelete: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .ScaleToFill
        btn.frame.size = CGSize(width: 29, height: 34)
        return btn
    }()
    
    let imgContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgView1: TimelineImage = {
        let imgView = TimelineImage()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let imgView2: TimelineImage = {
        let imgView = TimelineImage()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let indicator2: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(whiteView)
        sendSubviewToBack(whiteView)
        
        addSubview(btnUsername)
        addSubview(btnProfile)
        addSubview(postDate)
        addSubview(btnDelete)
        addSubview(imgContainer)
        imgContainer.addSubview(imgView1)
        imgContainer.addSubview(imgView2)
        imgContainer.addSubview(indicator)
        imgContainer.addSubview(indicator2)
        imgContainer.bringSubviewToFront(indicator)
        imgContainer.bringSubviewToFront(indicator2)
        
        btnProfile.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        btnProfile.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        btnProfile.widthAnchor.constraintEqualToConstant(40).active = true
        btnProfile.heightAnchor.constraintEqualToConstant(40).active = true
        
        btnUsername.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 9).active = true
        btnUsername.leftAnchor.constraintEqualToAnchor(btnProfile.rightAnchor, constant: 5).active = true
        btnUsername.widthAnchor.constraintEqualToConstant(120).active = true
        btnUsername.heightAnchor.constraintEqualToConstant(40).active = true
        
        postDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        postDate.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -30).active = true
        postDate.widthAnchor.constraintEqualToConstant(130).active = true
        postDate.heightAnchor.constraintEqualToConstant(34).active = true
        
        btnDelete.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        btnDelete.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        btnDelete.widthAnchor.constraintEqualToConstant(29).active = true
        btnDelete.heightAnchor.constraintEqualToConstant(34).active = true
        
        imgContainer.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -30).active = true
        imgContainer.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        imgContainer.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        imgContainer.heightAnchor.constraintEqualToConstant(300).active = true
        
        indicator.topAnchor.constraintEqualToAnchor(imgContainer.topAnchor).active = true
        indicator.leftAnchor.constraintEqualToAnchor(imgContainer.leftAnchor).active = true
        indicator.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        indicator.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor).active = true
        
        indicator2.topAnchor.constraintEqualToAnchor(imgContainer.topAnchor).active = true
        indicator2.rightAnchor.constraintEqualToAnchor(imgContainer.rightAnchor).active = true
        indicator2.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        indicator2.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor).active = true
        
        imgView1.topAnchor.constraintEqualToAnchor(imgContainer.topAnchor).active = true
        imgView1.leftAnchor.constraintEqualToAnchor(imgContainer.leftAnchor).active = true
        imgView1.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        imgView1.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor).active = true
        
        
        imgView2.topAnchor.constraintEqualToAnchor(imgContainer.topAnchor).active = true
        imgView2.rightAnchor.constraintEqualToAnchor(imgContainer.rightAnchor).active = true
        imgView2.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        imgView2.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TripleImage: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = UIColor.clearColor()
        
        whiteView.layer.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - 10)
        
        textLabel?.frame = CGRectMake(70, 22, textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFontOfSize(14)
        
        detailTextLabel?.frame = CGRectMake(10, 70, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFontOfSize(16)
        detailTextLabel?.numberOfLines = 7
        detailTextLabel?.lineBreakMode = .ByTruncatingTail
    }
    
    let btnProfile: TimelineProfileImage = {
        let btn = TimelineProfileImage()
        btn.contentMode = .ScaleAspectFill
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 20
        btn.clipsToBounds = true
        return btn
    }()
    
    let btnUsername: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel!.textColor = UIColor.blackColor()
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Selected)
        btn.setTitleColor(UIColor.blackColor(), forState: .Focused)
        btn.titleLabel!.lineBreakMode = .ByTruncatingTail
        btn.titleLabel!.font = UIFont.boldSystemFontOfSize(14)
        btn.contentHorizontalAlignment = .Left
        return btn
    }()
    
    let whiteView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 2.0
        view.layer.shadowOffset = CGSize(width: -1, height: 1)
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    let profileImg: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "photo")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.layer.cornerRadius = 25
        imgView.contentMode = .ScaleAspectFill
        imgView.layer.masksToBounds = true
        return imgView
    }()
    
    let postDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.grayColor()
        label.textAlignment = .Right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnDelete: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .ScaleToFill
        btn.frame.size = CGSize(width: 29, height: 34)
        return btn
    }()
    
    let imgContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgView1: TimelineImage = {
        let imgView = TimelineImage()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let imgView2: TimelineImage = {
        let imgView = TimelineImage()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let indicator2: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgView3: TimelineImage = {
        let imgView = TimelineImage()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let indicator3: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(whiteView)
        sendSubviewToBack(whiteView)
        
        addSubview(btnUsername)
        addSubview(btnProfile)
        addSubview(postDate)
        addSubview(btnDelete)
        addSubview(imgContainer)
        imgContainer.addSubview(imgView1)
        imgContainer.addSubview(imgView2)
        imgContainer.addSubview(imgView3)
        imgContainer.addSubview(indicator)
        imgContainer.addSubview(indicator2)
        imgContainer.addSubview(indicator3)
        imgContainer.bringSubviewToFront(indicator)
        imgContainer.bringSubviewToFront(indicator2)
        imgContainer.bringSubviewToFront(indicator3)
        
        btnProfile.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        btnProfile.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        btnProfile.widthAnchor.constraintEqualToConstant(40).active = true
        btnProfile.heightAnchor.constraintEqualToConstant(40).active = true
        
        btnUsername.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 9).active = true
        btnUsername.leftAnchor.constraintEqualToAnchor(btnProfile.rightAnchor, constant: 5).active = true
        btnUsername.widthAnchor.constraintEqualToConstant(120).active = true
        btnUsername.heightAnchor.constraintEqualToConstant(40).active = true
        
        postDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        postDate.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -30).active = true
        postDate.widthAnchor.constraintEqualToConstant(130).active = true
        postDate.heightAnchor.constraintEqualToConstant(34).active = true
        
        btnDelete.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        btnDelete.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        btnDelete.widthAnchor.constraintEqualToConstant(29).active = true
        btnDelete.heightAnchor.constraintEqualToConstant(34).active = true
        
        imgContainer.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor, constant: -30).active = true
        imgContainer.leftAnchor.constraintEqualToAnchor(self.leftAnchor).active = true
        imgContainer.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        imgContainer.heightAnchor.constraintEqualToConstant(300).active = true
        
        indicator.topAnchor.constraintEqualToAnchor(imgContainer.topAnchor).active = true
        indicator.leftAnchor.constraintEqualToAnchor(imgContainer.leftAnchor).active = true
        indicator.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        indicator.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor).active = true
        
        indicator2.topAnchor.constraintEqualToAnchor(imgContainer.topAnchor).active = true
        indicator2.rightAnchor.constraintEqualToAnchor(imgContainer.rightAnchor).active = true
        indicator2.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        indicator2.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor, multiplier: 1/2).active = true
        
        indicator3.bottomAnchor.constraintEqualToAnchor(imgContainer.bottomAnchor).active = true
        indicator3.rightAnchor.constraintEqualToAnchor(imgContainer.rightAnchor).active = true
        indicator3.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        indicator3.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor, multiplier: 1/2).active = true
        
        imgView1.topAnchor.constraintEqualToAnchor(imgContainer.topAnchor).active = true
        imgView1.leftAnchor.constraintEqualToAnchor(imgContainer.leftAnchor).active = true
        imgView1.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        imgView1.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor).active = true
        
        imgView2.topAnchor.constraintEqualToAnchor(imgContainer.topAnchor).active = true
        imgView2.rightAnchor.constraintEqualToAnchor(imgContainer.rightAnchor).active = true
        imgView2.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        imgView2.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor, multiplier: 1/2).active = true
        
        imgView3.bottomAnchor.constraintEqualToAnchor(imgContainer.bottomAnchor).active = true
        imgView3.rightAnchor.constraintEqualToAnchor(imgContainer.rightAnchor).active = true
        imgView3.widthAnchor.constraintEqualToAnchor(imgContainer.widthAnchor, multiplier: 1/2).active = true
        imgView3.heightAnchor.constraintEqualToAnchor(imgContainer.heightAnchor, multiplier: 1/2).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NotifCell: UITableViewCell {
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#E8E8E8")
        return view
    }()
    
    let notifPhoto: TimelineImage = {
        let photo = TimelineImage()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.layer.cornerRadius = 23
        photo.contentMode = .ScaleAspectFill
        photo.layer.masksToBounds = true
        return photo
    }()
    
    let lblMessage: UILabel = {
        let lblMessage = UILabel()
        lblMessage.font = UIFont.systemFontOfSize(16)
        return lblMessage
    }()
    let lblDate: UILabel = {
        let lblDate = UILabel()
        lblDate.font = UIFont.systemFontOfSize(12)
        return lblDate
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(separator)
        addSubview(notifPhoto)
        addSubview(lblMessage)
        addSubview(lblDate)
        
        notifPhoto.translatesAutoresizingMaskIntoConstraints = false
        notifPhoto.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 5).active = true
        notifPhoto.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        notifPhoto.widthAnchor.constraintEqualToConstant(46).active = true
        notifPhoto.heightAnchor.constraintEqualToConstant(46).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        separator.leftAnchor.constraintEqualToAnchor(notifPhoto.rightAnchor).active = true
        separator.centerXAnchor.constraintGreaterThanOrEqualToAnchor(self.centerXAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        lblMessage.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true
        lblMessage.leftAnchor.constraintEqualToAnchor(self.notifPhoto.rightAnchor, constant: 5).active = true
        lblMessage.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -55).active = true
        lblMessage.lineBreakMode = .ByWordWrapping
        lblMessage.numberOfLines = 0
        lblMessage.sizeToFit()
        
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        lblDate.leftAnchor.constraintEqualToAnchor(self.notifPhoto.rightAnchor).active = true
        lblDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 50).active = true
        lblDate.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -65).active = true
        lblDate.sizeToFit()
        lblDate.textAlignment = .Right
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MessageCell: UICollectionViewCell {
    
    let txtLbl: UILabel = {
        let tv = UILabel()
        tv.font = UIFont.systemFontOfSize(16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clearColor()
        tv.numberOfLines = 0
        tv.lineBreakMode = .ByWordWrapping
        tv.sizeToFit()
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    let chatmatePhoto: TimelineImage = {
        let photo = TimelineImage()
        photo.image = UIImage(named: "noPhoto")
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.layer.cornerRadius = 16
        photo.layer.masksToBounds = true
        photo.contentMode = .ScaleAspectFill
        return photo
    }()
    
    let userPhoto: TimelineImage = {
        let photo = TimelineImage()
        photo.image = UIImage(named: "noPhoto")
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.layer.cornerRadius = 16
        photo.layer.masksToBounds = true
        photo.contentMode = .ScaleAspectFill
        return photo
    }()
    
    let dateLblLeft: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor.clearColor()
        lbl.font = UIFont.systemFontOfSize(10)
        return lbl
    }()
    
    let dateLblRight: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor.clearColor()
        lbl.font = UIFont.systemFontOfSize(10)
        return lbl
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleHeightAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(txtLbl)
        addSubview(userPhoto)
        addSubview(chatmatePhoto)
        addSubview(dateLblLeft)
        addSubview(dateLblRight)
        
        chatmatePhoto.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 5).active = true
        chatmatePhoto.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true
        chatmatePhoto.widthAnchor.constraintEqualToConstant(32).active = true
        chatmatePhoto.heightAnchor.constraintEqualToConstant(32).active = true
        
        userPhoto.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -5).active = true
        userPhoto.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 5).active = true
        userPhoto.widthAnchor.constraintEqualToConstant(32).active = true
        userPhoto.heightAnchor.constraintEqualToConstant(32).active = true
        
        bubbleViewRightAnchor =  bubbleView.rightAnchor.constraintEqualToAnchor(self.userPhoto.leftAnchor, constant: -5)
        bubbleViewRightAnchor?.active = true
        //        bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -8).active = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraintEqualToAnchor(self.chatmatePhoto.rightAnchor, constant: 5)
        //        bubbleViewLeftAnchor?.active = true
        
        //        bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraintEqualToConstant(200)
        bubbleWidthAnchor?.active = true
        
        
        bubbleHeightAnchor = bubbleView.heightAnchor.constraintEqualToConstant(40)
        bubbleHeightAnchor?.active = true
        
        txtLbl.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
        txtLbl.topAnchor.constraintEqualToAnchor(bubbleView.topAnchor, constant: -10).active = true
        txtLbl.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor, constant: -8).active = true
        
        txtLbl.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        dateLblLeft.topAnchor.constraintEqualToAnchor(self.bubbleView.bottomAnchor).active = true
        dateLblLeft.leftAnchor.constraintEqualToAnchor(self.bubbleView.leftAnchor).active = true
        dateLblLeft.widthAnchor.constraintEqualToConstant(130).active = true
        dateLblLeft.heightAnchor.constraintEqualToConstant(15).active = true
        dateLblLeft.textAlignment = .Left
        
        dateLblRight.topAnchor.constraintEqualToAnchor(self.bubbleView.bottomAnchor).active = true
        dateLblRight.rightAnchor.constraintEqualToAnchor(self.bubbleView.rightAnchor).active = true
        dateLblRight.widthAnchor.constraintEqualToConstant(130).active = true
        dateLblRight.heightAnchor.constraintEqualToConstant(15).active = true
        dateLblRight.textAlignment = .Right
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}