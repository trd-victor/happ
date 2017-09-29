//
//  ConfigurationViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 25/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import Firebase

class ConfigurationViewController: UIViewController {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var infoView: UIView!
    @IBOutlet var logoutView: UIView!
    @IBOutlet var imgRightPass: UIImageView!
    @IBOutlet var imgRightEmail: UIImageView!
    @IBOutlet var imgRightProfile: UIImageView!
    @IBOutlet var separator: UIView!
    @IBOutlet var separator2: UIView!
    @IBOutlet var separator3: UIView!
    @IBOutlet var separator4: UIView!
    @IBOutlet var imgRightLang: UIImageView!
    
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
    
    
    var language: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(("refreshLang:")), name: "refreshConfig", object: nil)
        
        //load language set.
        language = setLanguage.appLanguage
        
        self.loadConfigure()

        
        //set action 
         btnEditProfile.addTarget(self, action: "viewtoEditProfile:", forControlEvents: .TouchUpInside)
        
        btnMailAddressChange.addTarget(self, action: "viewtoMailChange:", forControlEvents: .TouchUpInside)
        
        btnChangePass.addTarget(self, action: "viewChangePass:", forControlEvents: .TouchUpInside)
        
         btnLanguageSettings.addTarget(self, action: "viewChangeLanguage:", forControlEvents: .TouchUpInside)
        
        autoLayout()
        
    }
    
    func autoLayout() {
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 22).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(44).active = true
        
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        infoView.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        infoView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        infoView.heightAnchor.constraintEqualToConstant(38).active = true
        
        labelBasicInfo.translatesAutoresizingMaskIntoConstraints = false
        labelBasicInfo.centerXAnchor.constraintEqualToAnchor(infoView.centerXAnchor).active = true
        labelBasicInfo.centerYAnchor.constraintEqualToAnchor(infoView.centerYAnchor).active = true
        labelBasicInfo.widthAnchor.constraintEqualToAnchor(infoView.widthAnchor).active = true
        labelBasicInfo.heightAnchor.constraintEqualToConstant(38).active = true
        
        btnEditProfile.translatesAutoresizingMaskIntoConstraints = false
        btnEditProfile.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnEditProfile.topAnchor.constraintEqualToAnchor(infoView.bottomAnchor).active = true
        btnEditProfile.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        btnEditProfile.heightAnchor.constraintEqualToConstant(38).active = true
        
        imgRightProfile.translatesAutoresizingMaskIntoConstraints = false
        imgRightProfile.rightAnchor.constraintEqualToAnchor(btnEditProfile.rightAnchor).active = true
        imgRightProfile.topAnchor.constraintEqualToAnchor(btnEditProfile.topAnchor, constant: 5).active = true
        imgRightProfile.widthAnchor.constraintEqualToConstant(30).active = true
        imgRightProfile.heightAnchor.constraintEqualToConstant(30).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator.topAnchor.constraintEqualToAnchor(btnEditProfile.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        btnMailAddressChange.translatesAutoresizingMaskIntoConstraints = false
        btnMailAddressChange.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnMailAddressChange.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        btnMailAddressChange.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        btnMailAddressChange.heightAnchor.constraintEqualToConstant(38).active = true
        
        imgRightEmail.translatesAutoresizingMaskIntoConstraints = false
        imgRightEmail.rightAnchor.constraintEqualToAnchor(btnMailAddressChange.rightAnchor).active = true
        imgRightEmail.topAnchor.constraintEqualToAnchor(btnMailAddressChange.topAnchor, constant: 5).active = true
        imgRightEmail.widthAnchor.constraintEqualToConstant(30).active = true
        imgRightEmail.heightAnchor.constraintEqualToConstant(30).active = true
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator2.topAnchor.constraintEqualToAnchor(btnMailAddressChange.bottomAnchor).active = true
        separator2.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator2.heightAnchor.constraintEqualToConstant(1).active = true
        
        btnChangePass.translatesAutoresizingMaskIntoConstraints = false
        btnChangePass.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnChangePass.topAnchor.constraintEqualToAnchor(separator2.bottomAnchor).active = true
        btnChangePass.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        btnChangePass.heightAnchor.constraintEqualToConstant(38).active = true
        
        imgRightPass.translatesAutoresizingMaskIntoConstraints = false
        imgRightPass.rightAnchor.constraintEqualToAnchor(btnChangePass.rightAnchor).active = true
        imgRightPass.topAnchor.constraintEqualToAnchor(btnChangePass.topAnchor, constant: 5).active = true
        imgRightPass.widthAnchor.constraintEqualToConstant(30).active = true
        imgRightPass.heightAnchor.constraintEqualToConstant(30).active = true
        
        separator3.translatesAutoresizingMaskIntoConstraints = false
        separator3.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator3.topAnchor.constraintEqualToAnchor(btnChangePass.bottomAnchor).active = true
        separator3.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator3.heightAnchor.constraintEqualToConstant(1).active = true
        
        btnLanguageSettings.translatesAutoresizingMaskIntoConstraints = false
        btnLanguageSettings.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnLanguageSettings.topAnchor.constraintEqualToAnchor(separator3.bottomAnchor).active = true
        btnLanguageSettings.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        btnLanguageSettings.heightAnchor.constraintEqualToConstant(38).active = true
        
        //Incorrect Name should be for Language
        imgRightLang.translatesAutoresizingMaskIntoConstraints = false
        imgRightLang.rightAnchor.constraintEqualToAnchor(btnLanguageSettings.rightAnchor).active = true
        imgRightLang.topAnchor.constraintEqualToAnchor(btnLanguageSettings.topAnchor, constant: 5).active = true
        imgRightLang.widthAnchor.constraintEqualToConstant(30).active = true
        imgRightLang.heightAnchor.constraintEqualToConstant(30).active = true
        
        logoutView.translatesAutoresizingMaskIntoConstraints = false
        logoutView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        logoutView.topAnchor.constraintEqualToAnchor(btnLanguageSettings.bottomAnchor).active = true
        logoutView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        logoutView.heightAnchor.constraintEqualToConstant(38).active = true
        
        labelLogout.translatesAutoresizingMaskIntoConstraints = false
        labelLogout.centerXAnchor.constraintEqualToAnchor(logoutView.centerXAnchor).active = true
        labelLogout.centerYAnchor.constraintEqualToAnchor(logoutView.centerYAnchor).active = true
        labelLogout.widthAnchor.constraintEqualToAnchor(logoutView.widthAnchor).active = true
        labelLogout.heightAnchor.constraintEqualToConstant(38).active = true
        
        btnLogout.translatesAutoresizingMaskIntoConstraints = false
        btnLogout.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        btnLogout.topAnchor.constraintEqualToAnchor(logoutView.bottomAnchor).active = true
        btnLogout.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        btnLogout.heightAnchor.constraintEqualToConstant(38).active = true
        
        separator4.translatesAutoresizingMaskIntoConstraints = false
        separator4.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator4.topAnchor.constraintEqualToAnchor(btnLogout.bottomAnchor).active = true
        separator4.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator4.heightAnchor.constraintEqualToConstant(1).active = true
        
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
    
    func refreshLang(notification: NSNotification) {
        
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

    @IBAction func btnLogout(sender: AnyObject) {
        let config = SYSTEM_CONFIG()
        
        let myAlert = UIAlertController(title: "", message: config.translate("logout_message"), preferredStyle: UIAlertControllerStyle.ActionSheet)
        myAlert.addAction(UIAlertAction(title: config.translate("label_logout"), style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            do {
                try FIRAuth.auth()?.signOut()
            } catch (let error) {
                print((error as NSError).code)
            }
            
            let transition: CATransition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.addAnimation(transition, forKey: nil)
            self.dismissViewControllerAnimated(false, completion: nil)
        }))
        myAlert.addAction(UIAlertAction(title: config.translate("btn_cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
}
