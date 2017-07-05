//
//  AccountViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 05/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet var logoutButtonTapped: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated:Bool) {
        let nsdefaults = NSUserDefaults.standardUserDefaults()
        let check_user_login = nsdefaults.boolForKey("user_login")
        if(!check_user_login) {
            self.performSegueWithIdentifier("LogoutView", sender: self)
        }
    }
 
    @IBAction func logoutButtonTapped(sender: UIButton) {
        let logoutDefaults = NSUserDefaults.standardUserDefaults()
        logoutDefaults.setBool(false, forKey: "user_login")
        logoutDefaults.synchronize()
        self.performSegueWithIdentifier("LogoutView", sender: self)

    }

}
