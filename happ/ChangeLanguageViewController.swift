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


    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var btnenglish: UIButton!
    @IBOutlet var btnJapanese: UIButton!
    @IBOutlet var backbutton: UIBarButtonItem!
    
    
    @IBOutlet var navBackSettings: UIBarButtonItem!
    
    var arrText = [
    
        "en" : [
            "navTitle": "Change Language settings",
            "engLang": "English",
            "jplang": "Japanese"
        ],
        "ja" : [
            "navTitle": "言語の設定",
            "engLang": "英語",
            "jplang": "日本語"
        ]
    
    ]
    
    var language: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load language set.
        language = setLanguage.appLanguage
        
        //set label text..
        navTitle.title = arrText["\(language)"]!["navTitle"]
        btnenglish.setTitle(arrText["\(language)"]!["engLang"], forState: .Normal)
        btnJapanese.setTitle(arrText["\(language)"]!["jplang"], forState: .Normal)
        
        //set image back button position..   
        self.navBackSettings.action = Selector("backToConfiguration:")
        btnenglish.addTarget(self, action: "englishBackButton:", forControlEvents: .TouchUpInside)
        btnJapanese.addTarget(self, action: "japaneseBackButton:", forControlEvents: .TouchUpInside)
    }

    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func presentDetail2 (viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func englishBackButton (sender: UIButton) -> () {
        
        let getTextButton = btnenglish.titleLabel!.text as String!
        changeLang.lang = getTextButton

        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("CurrentSettings") as! CurrentSettingsViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)

    }
    
    
    func japaneseBackButton (sender: UIButton) -> () {
        
        let getJpButton = btnJapanese.titleLabel!.text as String!
        changeLang.lang = getJpButton
       
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("CurrentSettings") as! CurrentSettingsViewController
        
        let transition = CATransition()
        transition.duration = 0.10
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
        transition.duration = 0.10
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
