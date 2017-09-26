//
//  CreateReservation.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/26.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

struct CreateDetails {
    static var date:String = ""
    static var day:String = ""
}

class CreateReservation: UIViewController {
    
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var scrollView: UIView!
    @IBOutlet var navTitle: UINavigationItem!
    
    let config = SYSTEM_CONFIG()
    var lang = ""
    
    let roomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#E4D4B9")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let roomSubtitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let facilityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.alpha = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let facilityName: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let roomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.alpha = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let roomName: UILabel = {
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
    
    let makeReservation: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.backgroundColor = UIColor(hexString: "#E4D4B9")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.alpha = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startName: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.alpha = 0.8
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let endName: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        label.backgroundColor = UIColor.clearColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.addSubview(roomView)
        roomView.addSubview(roomSubtitle)
        
        scrollView.addSubview(facilityLabel)
        scrollView.addSubview(facilityName)
        scrollView.addSubview(separator)
        scrollView.addSubview(roomLabel)
        scrollView.addSubview(roomName)
        scrollView.addSubview(makeReservation)
        
        roomSubtitle.text = "ルーム"
        facilityLabel.text = "施設"
        facilityName.text = "FUKUOKA"
        roomLabel.text = "ルーム"
        roomName.text = "A"
        makeReservation.text = "予約する"
        
        autoLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        lang = config.getSYS_VAL("AppLanguage") as! String
        let title = CreateDetails.date
        let tmpArr = title.characters.split{$0 == "-"}.map(String.init)
        if lang == "en" {
            navTitle.title = "\(tmpArr[0])-\(tmpArr[1])-\(tmpArr[2]) (\(CreateDetails.day))"
        }else{
            navTitle.title = "\(tmpArr[0])年\(tmpArr[1])月\(tmpArr[2])日 (\(CreateDetails.day))"
        }
    }
    
    func autoLayout(){
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        scrollView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        scrollView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        scrollView.heightAnchor.constraintEqualToAnchor(view.heightAnchor).active = true
        
        roomView.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        roomView.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
        roomView.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        roomView.heightAnchor.constraintEqualToConstant(30).active = true
        
        roomSubtitle.centerXAnchor.constraintEqualToAnchor(roomView.centerXAnchor).active = true
        roomSubtitle.centerYAnchor.constraintEqualToAnchor(roomView.centerYAnchor).active = true
        roomSubtitle.widthAnchor.constraintEqualToAnchor(roomView.widthAnchor).active = true
        roomSubtitle.heightAnchor.constraintEqualToConstant(30).active = true
        
        facilityLabel.topAnchor.constraintEqualToAnchor(roomView.bottomAnchor).active = true
        facilityLabel.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 20).active = true
        facilityLabel.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -40).active = true
        facilityLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        facilityName.topAnchor.constraintEqualToAnchor(roomView.bottomAnchor).active = true
        facilityName.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
        facilityName.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        facilityName.heightAnchor.constraintEqualToConstant(50).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 20).active = true
        separator.topAnchor.constraintEqualToAnchor(facilityLabel.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        roomLabel.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        roomLabel.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor, constant: 20).active = true
        roomLabel.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -40).active = true
        roomLabel.heightAnchor.constraintEqualToConstant(50).active = true
        
        roomName.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        roomName.leftAnchor.constraintEqualToAnchor(scrollView.leftAnchor).active = true
        roomName.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor, constant: -20).active = true
        roomName.heightAnchor.constraintEqualToConstant(50).active = true
        
        makeReservation.centerXAnchor.constraintEqualToAnchor(scrollView.centerXAnchor).active = true
        makeReservation.topAnchor.constraintEqualToAnchor(roomLabel.bottomAnchor).active = true
        makeReservation.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
        makeReservation.heightAnchor.constraintEqualToConstant(30).active = true
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
