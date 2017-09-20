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
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.lineBreakMode = .ByWordWrapping
        detailTextLabel?.sizeToFit()
    }
    
    let btnProfile: UIButton = {
        let btn = UIButton()
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
        btnUsername.widthAnchor.constraintEqualToConstant(100).active = true
        btnUsername.heightAnchor.constraintEqualToConstant(40).active = true
        
        postDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        postDate.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -36).active = true
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
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.lineBreakMode = .ByWordWrapping
        detailTextLabel?.sizeToFit()
    }
    
    let btnProfile: UIButton = {
        let btn = UIButton()
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
    
    let imgView1: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
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
        
        btnProfile.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        btnProfile.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        btnProfile.widthAnchor.constraintEqualToConstant(40).active = true
        btnProfile.heightAnchor.constraintEqualToConstant(40).active = true
        
        btnUsername.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 9).active = true
        btnUsername.leftAnchor.constraintEqualToAnchor(btnProfile.rightAnchor, constant: 5).active = true
        btnUsername.widthAnchor.constraintEqualToConstant(100).active = true
        btnUsername.heightAnchor.constraintEqualToConstant(40).active = true
        
        postDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        postDate.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -36).active = true
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
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.lineBreakMode = .ByWordWrapping
        detailTextLabel?.sizeToFit()
    }
    
    let btnProfile: UIButton = {
        let btn = UIButton()
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
    
    let imgView1: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let imgView2: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
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
        
        btnProfile.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        btnProfile.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        btnProfile.widthAnchor.constraintEqualToConstant(40).active = true
        btnProfile.heightAnchor.constraintEqualToConstant(40).active = true
        
        btnUsername.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 9).active = true
        btnUsername.leftAnchor.constraintEqualToAnchor(btnProfile.rightAnchor, constant: 5).active = true
        btnUsername.widthAnchor.constraintEqualToConstant(100).active = true
        btnUsername.heightAnchor.constraintEqualToConstant(40).active = true
        
        postDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        postDate.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -36).active = true
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
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.lineBreakMode = .ByWordWrapping
        detailTextLabel?.sizeToFit()
    }
    
    let btnProfile: UIButton = {
        let btn = UIButton()
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
    
    let imgView1: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    
    let imgView2: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
    }()
    let imgView3: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.clipsToBounds = true
        imgView.contentMode = .ScaleAspectFill
        return imgView
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
        
        btnProfile.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        btnProfile.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        btnProfile.widthAnchor.constraintEqualToConstant(40).active = true
        btnProfile.heightAnchor.constraintEqualToConstant(40).active = true
        
        btnUsername.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 9).active = true
        btnUsername.leftAnchor.constraintEqualToAnchor(btnProfile.rightAnchor, constant: 5).active = true
        btnUsername.widthAnchor.constraintEqualToConstant(100).active = true
        btnUsername.heightAnchor.constraintEqualToConstant(40).active = true
        
        postDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 13).active = true
        postDate.rightAnchor.constraintEqualToAnchor(self.rightAnchor, constant: -36).active = true
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
    
    let notifPhoto: UIImageView = {
        let photo = UIImageView()
        photo.image = UIImage(named: "photo")
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
        lblMessage.widthAnchor.constraintLessThanOrEqualToAnchor(self.widthAnchor, constant: -50).active = true
        lblMessage.lineBreakMode = .ByWordWrapping
        lblMessage.numberOfLines = 0
        lblMessage.sizeToFit()
        
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        lblDate.leftAnchor.constraintEqualToAnchor(self.notifPhoto.rightAnchor, constant: 160).active = true
        lblDate.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 50).active = true
        lblDate.widthAnchor.constraintEqualToAnchor(self.widthAnchor).active = true
        lblDate.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
