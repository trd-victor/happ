//
//  CongestionViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 14/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class CongestionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#272727")
        return view
    }()
    
    let congestiontitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFontOfSize(18)
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        return label
    }()
    
    let situationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let conView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#E4D4B9")
        return view
    }()
    
    let conTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.blackColor()
        label.sizeToFit()
        label.textAlignment = .Center
        return label
    }()
    
    let personContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let percentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let prcentViewBlack: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let personImg1: UIImageView = {
        let imgview = UIImageView()
        imgview.clipsToBounds = true
        return imgview
    }()
    
    let percentage: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textColor = UIColor.blackColor()
        label.sizeToFit()
        label.textAlignment = .Center
        return label
    }()
    
    let freeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hexString: "#E4D4B9")
        return view
    }()
    
    let freeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.blackColor()
        label.sizeToFit()
        label.textAlignment = .Center
        return label
    }()
    
    var widthPercentage: CGFloat = 0
    
    var userIds = [Int]()
    
    let config = SYSTEM_CONFIG()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("refreshLang:")), name: "refreshUserTimeline", object: nil)
        
        var layoutwidth:CGFloat = 0
        
        layoutwidth = (view.frame.width - 60) / 3
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSizeMake(layoutwidth, 100)
        
        collectionView.collectionViewLayout = layout
        
        view.backgroundColor = UIColor(hexString: "#272727")
        
        view.addSubview(topView)
        topView.addSubview(congestiontitle)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UserCollection.self, forCellWithReuseIdentifier: "UserCell")
        collectionView.contentInset = UIEdgeInsetsMake(280, 10, 30, 10)
        
        collectionView.addSubview(situationView)
        collectionView.bringSubviewToFront(situationView)
        
        situationView.addSubview(conView)
        conView.addSubview(conTitle)

        percentView.clipsToBounds = true
        
        situationView.addSubview(percentView)
        
        percentView.addSubview(prcentViewBlack)
        percentView.sendSubviewToBack(prcentViewBlack)
        percentView.addSubview(personImg1)
        
        situationView.addSubview(percentage)
        situationView.addSubview(freeView)
        freeView.addSubview(freeTitle)
        
        percentage.text = "0%"
        congestiontitle.text = config.translate("title_situation")
        conTitle.text = config.translate("label_congestion_situation")
        freeTitle.text = config.translate("subtitle_now_free")
        
        autoLayout()
        
//        getCongestion()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getCongestion()
    }
    
    func refreshLang(notification: NSNotification){
        //set title and text accdg. to language set....
        self.congestiontitle.text = config.translate("title_situation")
        self.conTitle.text = config.translate("label_congestion_situation")
        self.freeTitle.text = config.translate("subtitle_now_free")
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func calculatePercentage(percent: Int)-> CGFloat {
        var x:CGFloat = 0
        
        for var i = 1; i <= percent; i++ {
            if (i % 20) == 0  && i != 100 {
                x += 13.75
            }
            x += 2.2
        }
        return x
    }
    
    func autoLayout() {
        topView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        topView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        topView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        topView.heightAnchor.constraintEqualToConstant(44).active = true
        
        congestiontitle.centerXAnchor.constraintEqualToAnchor(topView.centerXAnchor).active = true
        congestiontitle.centerYAnchor.constraintEqualToAnchor(topView.centerYAnchor).active = true
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraintEqualToAnchor(topView.bottomAnchor).active = true
        collectionView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        collectionView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        collectionView.heightAnchor.constraintEqualToAnchor(view.heightAnchor, constant: -100).active = true
        collectionView.backgroundColor = UIColor.whiteColor()
        
        situationView.topAnchor.constraintEqualToAnchor(collectionView.topAnchor, constant: -280).active = true
        situationView.centerXAnchor.constraintEqualToAnchor(collectionView.centerXAnchor).active = true
        situationView.widthAnchor.constraintEqualToAnchor(collectionView.widthAnchor, constant: 20).active = true
        situationView.heightAnchor.constraintEqualToConstant(280).active = true
        
        conView.topAnchor.constraintEqualToAnchor(situationView.topAnchor).active = true
        conView.centerXAnchor.constraintEqualToAnchor(situationView.centerXAnchor, constant: -10).active = true
        conView.widthAnchor.constraintEqualToAnchor(situationView.widthAnchor).active = true
        conView.heightAnchor.constraintEqualToConstant(31).active = true
        
        conTitle.centerYAnchor.constraintEqualToAnchor(conView.centerYAnchor).active = true
        conTitle.centerXAnchor.constraintEqualToAnchor(conView.centerXAnchor).active = true
        conTitle.widthAnchor.constraintEqualToAnchor(conView.widthAnchor).active = true
        conTitle.heightAnchor.constraintEqualToConstant(21).active = true
        
        percentView.topAnchor.constraintEqualToAnchor(conView.bottomAnchor, constant: 25).active = true
        percentView.centerXAnchor.constraintEqualToAnchor(situationView.centerXAnchor, constant: -10).active = true
        percentView.widthAnchor.constraintEqualToConstant(275).active = true
        percentView.heightAnchor.constraintEqualToConstant(146).active = true
        percentView.backgroundColor = UIColor.grayColor()
        
        personImg1.translatesAutoresizingMaskIntoConstraints = false
        personImg1.topAnchor.constraintEqualToAnchor(percentView.topAnchor).active = true
        personImg1.centerXAnchor.constraintEqualToAnchor(percentView.centerXAnchor).active = true
        personImg1.widthAnchor.constraintEqualToConstant(275).active = true
        personImg1.heightAnchor.constraintEqualToConstant(146).active = true
        
        personImg1.image = UIImage(named: "congestionGroup")
        personImg1.contentMode = .ScaleAspectFill
        
        percentage.topAnchor.constraintEqualToAnchor(percentView.bottomAnchor, constant: 10).active = true
        percentage.centerXAnchor.constraintEqualToAnchor(situationView.centerXAnchor, constant: -10).active = true
        percentage.widthAnchor.constraintEqualToAnchor(situationView.widthAnchor).active = true
        percentage.heightAnchor.constraintEqualToConstant(21).active = true
        
        freeView.bottomAnchor.constraintEqualToAnchor(situationView.bottomAnchor).active = true
        freeView.centerXAnchor.constraintEqualToAnchor(situationView.centerXAnchor, constant: -10).active = true
        freeView.widthAnchor.constraintEqualToAnchor(situationView.widthAnchor).active = true
        freeView.heightAnchor.constraintEqualToConstant(31).active = true
        
        freeTitle.centerYAnchor.constraintEqualToAnchor(freeView.centerYAnchor).active = true
        freeTitle.centerXAnchor.constraintEqualToAnchor(freeView.centerXAnchor).active = true
        freeTitle.widthAnchor.constraintEqualToAnchor(freeView.widthAnchor).active = true
        freeTitle.heightAnchor.constraintEqualToConstant(21).active = true
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userIds.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("UserCell", forIndexPath: indexPath) as! UserCollection
        
        let username = config.getSYS_VAL("username_\(userIds[indexPath.row])") as! String
        let userimageURL = config.getSYS_VAL("userimage_\(userIds[indexPath.row])") as! String
        let tapCell = UITapGestureRecognizer(target: self, action: "tapCell:")
        
        cell.addGestureRecognizer(tapCell)
        
        cell.imgView.profileForCache(userimageURL)
        cell.userName.text = username
        return cell
    }
    
    func tapCell(sender: UITapGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Ended {
            let tapLocation = sender.locationInView(self.collectionView)
            if let indexPath = self.collectionView.indexPathForItemAtPoint(tapLocation) {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyBoard.instantiateViewControllerWithIdentifier("UserProfile") as! UserProfileController
                let transition = CATransition()
                
                UserProfile.id = String(self.userIds[indexPath.row])
                
                transition.duration = 0.25
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                self.view.window!.layer.addAnimation(transition, forKey: nil)
                presentViewController(vc, animated: false, completion: nil)
            }
        }
    }
    
}

class UserCollection: UICollectionViewCell {
    
    let imgView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 30
        img.clipsToBounds = true
        return img
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgView)
        addSubview(userName)
        
        
        imgView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        imgView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor, constant: -10).active = true
        imgView.widthAnchor.constraintEqualToConstant(60).active = true
        imgView.heightAnchor.constraintEqualToConstant(60).active = true
        
        userName.topAnchor.constraintEqualToAnchor(imgView.bottomAnchor, constant: 5).active = true
        userName.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        userName.widthAnchor.constraintEqualToAnchor(self.widthAnchor, constant: -25).active = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
