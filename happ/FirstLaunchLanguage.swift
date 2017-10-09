//
//  FirstLaunchLanguage.swift
//  happ
//
//  Created by TokikawaTeppei on 02/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class FirstLaunchLanguage: UIViewController {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var separator: UIView!
    @IBOutlet var separator2: UIView!
    
    
    @IBOutlet var langja: UIButton!
    @IBOutlet var langeng: UIButton!
    @IBOutlet var skip: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skip.action = Selector("skip:")
        
        autoLayout()
        
        
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func autoLayout(){
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navBar.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
        navBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navBar.heightAnchor.constraintEqualToConstant(64).active = true
        
        langja.translatesAutoresizingMaskIntoConstraints = false
        langja.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        langja.topAnchor.constraintEqualToAnchor(navBar.bottomAnchor).active = true
        langja.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        langja.heightAnchor.constraintEqualToConstant(45).active = true
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator.topAnchor.constraintEqualToAnchor(langja.bottomAnchor).active = true
        separator.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        
        langeng.translatesAutoresizingMaskIntoConstraints = false
        langeng.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        langeng.topAnchor.constraintEqualToAnchor(separator.bottomAnchor).active = true
        langeng.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -10).active = true
        langeng.heightAnchor.constraintEqualToConstant(45).active = true
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        separator2.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        separator2.topAnchor.constraintEqualToAnchor(langeng.bottomAnchor).active = true
        separator2.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        separator2.heightAnchor.constraintEqualToConstant(1).active = true
    }
    
    override func viewWillAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func skip(sender: UIBarButtonItem) -> () {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveLanguage(sender: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(sender, forKey: "AppLanguage")
        userDefaults.synchronize()
    }
    
    @IBAction func langja(sender: UIButton) {
        globalvar.APP_LANGUANGE = "jp"
        setLanguage.appLanguage = "jp"
        self.saveLanguage(globalvar.APP_LANGUANGE)
    }
    
    @IBAction func langen(sender: UIButton) {
        globalvar.APP_LANGUANGE = "en"
        setLanguage.appLanguage = "en"
        self.saveLanguage(globalvar.APP_LANGUANGE)
    }
    

    
}

