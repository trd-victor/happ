//
//  RegisterController.swift
//  happ
//
//  Created by TokikawaTeppei on 04/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    
    /*setting up the variable...*/
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtpass: UITextField!
    @IBOutlet var txtrepeatpas: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func registerBtn(sender: UIButton) {
        registerUser()
    }
    
    func registerUser() {
        
        //unwrapped textfields..
        let userEmail = txtEmail.text!
        let userPass  = txtpass.text!
        let userRepeatPass = txtrepeatpas.text!
        
        //check empty fields..
        if userEmail == "" || userPass == "" || userRepeatPass == "" {
            displayMyAlertMessage("All Fields Required!")
        }
        else if userPass != userRepeatPass {
            displayMyAlertMessage("Password does not match!")
        } else {
            //save it locally instiate NSUDefaults..
            let defaults = NSUserDefaults.standardUserDefaults()
            
            //store data..
            defaults.setObject(userEmail, forKey: "username")
            defaults.setObject(userPass, forKey: "password")
            defaults.synchronize()
            
            //show pop up box successfully registered..
            let myAlert = UIAlertController(title: "Happ Message", message: "Successfully Registered!", preferredStyle: UIAlertControllerStyle.Alert)
            let saveAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default
                , handler: nil)
            myAlert.addAction(saveAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            
            //clear all fields..
            txtEmail.text = ""
            txtpass.text = ""
            txtrepeatpas.text = ""
        }
        
    }

    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "Happ Message", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    
   
}
