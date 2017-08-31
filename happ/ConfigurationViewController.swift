//
//  ConfigurationViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 25/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {

    
    //set button variable... builder interface..
    @IBOutlet var btnEditProfile: UIButton!
   
    @IBOutlet var navTitle: UINavigationItem!
    @IBOutlet var Timeline: UILabel!
    @IBOutlet var Message: UILabel!
    @IBOutlet var Reservation: UILabel!
    @IBOutlet var Situation: UILabel!
    @IBOutlet var Configuration: UILabel!
    
    
    
    @IBOutlet var btnMailAddressChange: UIButton!
    @IBOutlet var btnChangePass: UIButton!
    @IBOutlet var btnLanguageSettings: UIButton!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var labelLogout: UILabel!
    @IBOutlet var labelBasicInfo: UILabel!
    var arrText = [
        "en" :
            [
                "EditProfile" : "Edit profile",
                "EmailAddressChange" : "E-mail address change",
                "ChangePassword" : "Change Password",
                "LangSettings" : "Language settings",
                "labelLogout": "Logout",
                "ToLogOut" : "To log out",
                "labelBasicInfo" : "Basic information",
                "navTitle" : "Configuration",
                "Timeline" : "Timeline",
                "Message" : "Message",
                "Reservation": "Room Reservation",
                "Situation": "Situation",
                "Configuration": "Configuration"
                
        ],
        "ja" : [
                "EditProfile" : "プロフィールの編集",
                "EmailAddressChange" : "メールアドレスの変更",
                "ChangePassword" : "パスワードの変更",
                "LangSettings" : "言語の設定",
                "labelLogout": "ログアウト",
                "labelBasicInfo" : "基本情報",
                "ToLogOut" : "ログアウトする",
                "navTitle" : "設定",
                "Timeline" : "タイムライン",
                "Message" : "メッセージ",
                "Reservation": "ルーム予約",
                "Situation": "状況",
                "Configuration": "設定"
        ]
    ]
    
    var language: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load language set.
        language = setLanguage.appLanguage
        
        self.loadConfigure()

        //set action 
         btnEditProfile.addTarget(self, action: "viewtoEditProfile:", forControlEvents: .TouchUpInside)
        
        btnMailAddressChange.addTarget(self, action: "viewtoMailChange:", forControlEvents: .TouchUpInside)
        
        btnChangePass.addTarget(self, action: "viewChangePass:", forControlEvents: .TouchUpInside)
        
         btnLanguageSettings.addTarget(self, action: "viewChangeLanguage:", forControlEvents: .TouchUpInside)
    
    }
    
    func loadConfigure() {
        
        let config = SYSTEM_CONFIG()
        
        //set label text..
        navTitle.title = config.translate("menu_configuration")
        labelLogout.text = config.translate("label_logout")
        labelBasicInfo.text = config.translate("subtitle_basic_information")
        labelLogout.text = config.translate("label_logout")
        
        btnEditProfile.setTitle(config.translate("title_edit_profile"), forState: .Normal)
        btnMailAddressChange.setTitle(config.translate("label_e-mail_address_change"), forState: .Normal)
        btnChangePass.setTitle(config.translate("label_change-password"), forState: .Normal)
        btnLanguageSettings.setTitle(config.translate("title_language_settings"), forState: .Normal)
        btnLogout.setTitle(config.translate("btn_logout"), forState: .Normal)
        
    }
    
    func presentDetail(viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.addAnimation(transition, forKey: "leftToRightTransition")
        
        presentViewController(viewControllerToPresent, animated: false, completion: nil)
    }
    
    func viewtoEditProfile(sender: UIButton) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("EditProfile") as! EditProfileViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    func viewtoMailChange(sender: UIButton) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("MailChange") as! MailChangeViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    
    func viewChangePass(sender: UIButton) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("ChangeNewPassword") as! ChangeNewPasswordViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
    
    func viewChangeLanguage(sender: UIButton) -> () {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("CurrentSettings") as! CurrentSettingsViewController
        
        let transition = CATransition()
        transition.duration = 0.10
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.layer.addAnimation(transition, forKey: "leftToRightTransition")
        self.presentDetail(vc)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
