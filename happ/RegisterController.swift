//
//  RegisterController.swift
//  happ
//
//  Created by TokikawaTeppei on 04/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class RegisterController: UIViewController {

    
    /*setting up the UI variable...*/
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtpass: UITextField!
    @IBOutlet var txtrepeatpas: UITextField!
    
    @IBOutlet var frontEndSwitch: UISwitch!
    @IBOutlet var backEndSwitch: UISwitch!
    @IBOutlet var iosSwitch: UISwitch!
    
    /*setting up varaibles*/
    var setState: String = ""
    var frontEndState: String = ""
    var backEndState: String = ""
    var IOSstate: String = ""
    
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
        let fronEndSkill = getFrontEndState()
        let backEndSkill = getBackEndState()
        let iosSkill = getIOSState()
        
        //check empty fields..
        if userEmail == "" || userPass == "" || userRepeatPass == "" {
            displayMyAlertMessage("All Fields Required!")
        }
        else if userPass != userRepeatPass {
            displayMyAlertMessage("Password does not match!")
        } else {
            
            print(fronEndSkill)
            print(backEndSkill)
            print(iosSkill)
            //save it locally instiate NSUDefaults..
            let defaults = NSUserDefaults.standardUserDefaults()
            
            //store data..
            defaults.setObject(userEmail, forKey: "username")
            defaults.setObject(userPass, forKey: "password")
            defaults.setObject(fronEndSkill, forKey: "Front_end")
            defaults.setObject(backEndSkill, forKey: "Back_end")
            defaults.setObject(iosSkill, forKey: "Ios_end")
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
  
    //switch button action
    @IBAction func frontEndSwitch(sender: UISwitch) {
        self.frontEndState = clickSwitchButton(frontEndSwitch)
        
    }
    @IBAction func backEndSwitch(sender: UISwitch) {
        self.backEndState = clickSwitchButton(backEndSwitch)
    }
    @IBAction func iosSwitch(sender: UISwitch) {
        self.IOSstate = clickSwitchButton(iosSwitch)
    }

    //check button state...
    func clickSwitchButton(switchButton : UISwitch) -> String {
        var SwitchState = ""
        
        if switchButton.on {
            SwitchState = "On"
        }else {
           SwitchState = "Off"
        }
        return SwitchState
    }
    
    //getters...
    func getFrontEndState() -> String {
        return self.frontEndState
    }
    func getBackEndState() -> String {
        return self.frontEndState
    }
    
    func getIOSState() -> String {
        return self.IOSstate
    }
    
    //display aler message box...
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "Happ Message", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

    
   
}
