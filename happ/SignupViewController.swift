//
//  SignupViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 03/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//
import UIKit

class SignupViewController: UIViewController {

    /*Setting up variable*/
    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPass: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginBtn(sender: UIButton) {
        login_func()
    }

    func login_func() {
        //unwrapped textfield...
        let username = txtUser.text!
        let password = txtPass.text!
            
        //check for empty values..
        if username == "" || password == "" {
            displayMyAlertMessage("All Fields Required")
        }else {
            //login if correct credentials
            loginNow(username,PassWord: password)
        }
    }
    func loginNow(UserName: String, PassWord: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let user_name = defaults.stringForKey("username")
        let user_pass = defaults.stringForKey("password")
        
        if UserName != user_name || PassWord != user_pass {
            displayMyAlertMessage("Error: Not Registered User!")
        } else {
            defaults.setBool(true, forKey: "user_login")
            defaults.synchronize()
           
        }
    }
    
    func displayMyAlertMessage(userMessage:String){ 
        let myAlert = UIAlertController(title: "Happ Message", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

}
