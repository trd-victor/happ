//
//  FirstLaunchLanguage.swift
//  happ
//
//  Created by TokikawaTeppei on 02/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class FirstLaunchLanguage: UIViewController {


    @IBOutlet var langja: UIButton!
    @IBOutlet var langeng: UIButton!
    @IBOutlet var skip: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.skip.action = Selector("skip:")
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
        globalvar.APP_LANGUANGE = "ja"
        self.saveLanguage(globalvar.APP_LANGUANGE)
    }
    
    @IBAction func langen(sender: UIButton) {
        globalvar.APP_LANGUANGE = "en"
        self.saveLanguage(globalvar.APP_LANGUANGE)
    }
    

    
}

