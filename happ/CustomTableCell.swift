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
        
        detailTextLabel?.frame = CGRectMake(10, 70, detailTextLabel!.frame.width, detailTextLabel!.frame.height)
        detailTextLabel?.font = UIFont.systemFontOfSize(16)
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.lineBreakMode = .ByWordWrapping
        detailTextLabel?.sizeToFit()
    }
    
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
        
        addSubview(profileImg)
        addSubview(postDate)
        addSubview(btnDelete)
        
        
        profileImg.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        profileImg.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        profileImg.widthAnchor.constraintEqualToConstant(50).active = true
        profileImg.heightAnchor.constraintEqualToConstant(50).active = true
        
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
        
        addSubview(profileImg)
        addSubview(postDate)
        addSubview(btnDelete)
        addSubview(imgContainer)
        imgContainer.addSubview(imgView1)
        
        profileImg.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        profileImg.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        profileImg.widthAnchor.constraintEqualToConstant(50).active = true
        profileImg.heightAnchor.constraintEqualToConstant(50).active = true
        
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
        
        addSubview(profileImg)
        addSubview(postDate)
        addSubview(btnDelete)
        addSubview(imgContainer)
        imgContainer.addSubview(imgView1)
        imgContainer.addSubview(imgView2)
        
        profileImg.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        profileImg.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        profileImg.widthAnchor.constraintEqualToConstant(50).active = true
        profileImg.heightAnchor.constraintEqualToConstant(50).active = true
        
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
        
        addSubview(profileImg)
        addSubview(postDate)
        addSubview(btnDelete)
        addSubview(imgContainer)
        imgContainer.addSubview(imgView1)
        imgContainer.addSubview(imgView2)
        imgContainer.addSubview(imgView3)
        
        profileImg.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 10).active = true
        profileImg.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 10).active = true
        profileImg.widthAnchor.constraintEqualToConstant(50).active = true
        profileImg.heightAnchor.constraintEqualToConstant(50).active = true
        
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
