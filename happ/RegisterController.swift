//
//  RegisterController.swift
//  happ
//
//  Created by TokikawaTeppei on 04/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class RegisterController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    /*setting up the UITextField variable...*/

    @IBOutlet var userEmail: UITextField!
    @IBOutlet var userPassword: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var userMessage: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var browseImage: UIButton!
    
    
    //skills swithcUIButton..dfv  vbgtewh0110899
    
    @IBOutlet var frontEndSwitch: UISwitch!
    @IBOutlet var backEndSwitch: UISwitch!
    @IBOutlet var iosSwitch: UISwitch!
    @IBOutlet var AndroidSwitch: UISwitch!
    @IBOutlet var appdesignSwitch: UISwitch!
    @IBOutlet var webdesignSwitch: UISwitch!
    var language: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}