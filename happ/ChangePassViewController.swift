//
//  ChangePassViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 05/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class ChangePassViewController: UIViewController {
    
//    @IBOutlet var userPass: UITextField!
//    @IBOutlet var userEmail: UITextField!
//
//    @IBOutlet var ExitButtonTapped: UIButton!
//    @IBOutlet var ChangePassButtonTapped: UIButton!
    
    
    
    @IBOutlet var userEmail: UITextField!
    @IBOutlet var ChangePassButtonTapped: UIButton!
    @IBOutlet var userPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ExitTapped(sender: UIButton) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func ChangePassButtonTapped(sender: AnyObject) {
        let username = userEmail.text!
        let password = userPass.text!
        checkEmail(username
                    , userPassword: password)

    }

    //check what email password to update
    func checkEmail(username: String, userPassword: String) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let userEmail = defaults.stringForKey("username")
        
        if(userEmail == username) {
            defaults.removeObjectForKey("password")
            defaults.setObject(userPassword, forKey: "password")
            defaults.synchronize()
            displayMyAlertMessage("Successfully Change Password!")
        } else {
            displayMyAlertMessage("Not equal username.Please check email!")
        }
    }
    

    
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "Happ Message", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

   
    

}
