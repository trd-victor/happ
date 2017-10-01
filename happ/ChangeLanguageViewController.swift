//
//  ChangeLanguageViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 25/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

struct changeLang {
    static var lang: String = ""
}

class ChangeLanguageViewController: UIViewController {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var separator: UIView!
    @IBOutlet var separator2: UIView!

    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var btnenglish: UIButton!
    @IBOutlet var btnJapanese: UIButton!
    @IBOutlet var backbutton: UIBarButtonItem!
    
    
    @IBOutlet var navBackSettings: UIBarButtonItem!
    
    var language: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load language set.
        language = setLanguage.appLanguage
        
        if language == "ja" {
            language = "jp"
        }
        
        self.loadConfigure()
        
        //set image back button position..   
        self.navBackSettings.action = Selector("backToConfiguration:")
        btnenglish.addTarget(self, action: "englishBackButton:", forControlEvents: .TouchUpInside)
        btnJapanese.addTarget(self, action: "japaneseBackButton:", forControlEvents: .TouchUpInside)
    
        autoLayout()
    }
    
    
    func autoLayout() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        btnenglish.translatesAutoresizingMaskIntoConstraints = false
        btnenglish.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnenglish.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        btnenglish.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -20).active = true
        btnenglish.heightAnchor.constraintEqualToConstant(38).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator.topAnchor.constraintEqualToAnchor(btnenglish.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        btnJapanese.translatesAutoresizingMaskIntoConstraints = false
        btnJapanese.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnJapanese.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        btnJapanese.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -20).active = true
        btnJapanese.heightAnchor.constraintEqualToConstant(38).active = true
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator2.topAnchor.constraintEqualToAnchor(btnJapanese.bottomAnchor).active = true
        separator2.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator2.heightAnchor.constraintEqualToConstant(1).active = true
    }
    
    func loadConfigure() {
        let config = SYSTEM_CONFIG()
        
        //set label text..
        navTitle.title = config.translate("title_language_settings")
        btnenglish.setTitle(config.translate("label_en"), forState: .Normal)
        btnJapanese.setTitle(config.translate("label_ja"), forState: .Normal)
    }

    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.05
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
       self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func presentDetail2 (viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.05
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func englishBackButton (sender: UIButton) -> () {
        
        let getTextButton = btnenglish.titleLabel!.text as String!
        changeLang.lang = getTextButton
        
    NSNotificationCenter.defaultCenter().postNotificationName("changeLang", object: nil, userInfo: nil)

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("CurrentSettings") as! CurrentSettingsViewController
        
        let transition = CATransition()
        transition.duration = 0.05
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
        
        
    }
    
    
    func japaneseBackButton (sender: UIButton) -> () {
        
        let getJpButton = btnJapanese.titleLabel!.text as String!
        changeLang.lang = getJpButton
    NSNotificationCenter.defaultCenter().postNotificationName("changeLang", object: nil, userInfo: nil)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("CurrentSettings") as! CurrentSettingsViewController
        
        let transition = CATransition()
        transition.duration = 0.05
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
        
    }
    
    
    func backToConfiguration(sender: UIBarButtonItem) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("CurrentSettings") as! CurrentSettingsViewController
        
        let transition = CATransition()
        transition.duration = 0.05
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
