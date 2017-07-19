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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func browseImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageView.contentMode = .ScaleAspectFit
                imageView.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func registerBtn(sender: UIButton) {
        registerUser()
    }
    
    func registerUser() {
        //setting up the textbox...
        let email = userEmail.text!
        let pass = userPassword.text!
        let name = userName.text!
        let message = userMessage.text!
        
        
        if email == "" || pass == "" || name == "" || message == "" {
            displayMyAlertMessage("All Fields Required")
        } else {
            //created NSURL
            let URL_SAVE_TEAM = "http://happ.timeriverdesign.com/wp-admin/admin-ajax.php"
            
            //created NSURL
            let requestURL = NSURL(string: URL_SAVE_TEAM)
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(URL: requestURL!)
            
            //set boundary string..
            let boundary = generateBoundaryString()
            
            //set value for image upload
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            //setting the method to post
            request.HTTPMethod = "POST"
            
            //declaring button state
            let frontEndSkill   = frontEndSwitch
            let backEndSkill    = backEndSwitch
            let iosSkill        = iosSwitch
            let androidSkill    = AndroidSwitch
            let appDesignSkill  = appdesignSwitch
            let webDesignSkill  = webdesignSwitch
            
            //get state
            let frontEndState   = switchButtonCheck(frontEndSkill)
            let backEndState    = switchButtonCheck(backEndSkill)
            let iosState        = switchButtonCheck(iosSkill)
            let androidState    = switchButtonCheck(androidSkill)
            let appDesignState  = switchButtonCheck(appDesignSkill)
            let webDesignState  = switchButtonCheck(webDesignSkill)
            
            let skills: [Int: String] = [
                1  : "\(frontEndState)",
                2  : "\(backEndState)",
                3  : "\(iosState)",
                4  : "\(androidState)",
                5  : "\(appDesignState)",
                6  : "\(webDesignState)"
            ]
            
            //set skill into variable and targets...
            let keyskill = returnSkillValue(skills)
            let targetedData: String = "email,passwd,name,skills,mess,change_lang"
            
            
            //set parameters...
            let param = [
                "sercret"     : "jo8nefamehisd",
                "action"      : "api",
                "ac"          : "user_update",
                "d"           : "1",
                "lang"        : "jp",
                "user_id"     : "2",
                "email"       : "\(email)",
                "passwd"      : "\(pass)",
                "name"        : "\(name)",
                "mess"        : "\(message)",
                "skills"      : "\(keyskill)",
                "change_lang" : "",
                "targets"     : "\(targetedData)"
            ]
            
            //set image Data
            let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
            
            //check imageData
            if (imageData == nil) { return;  }
            
            //adding the parameters to request body
            request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
            
            
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error  in
                    
                    if error != nil{
                        print("error is \(error)")
                        return;
                    }
                
                    do {
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    
                        print(json)
                        
                    } catch {
                        print(error)
                    }
                
            }
            task.resume()
            
            //display message when user data updated
            displayMyAlertMessage("User Data Updated")
            
            
        }
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }


    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
      
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    //check state..
    func switchButtonCheck(switchButton : UISwitch) -> String {
        var State: String = ""
        if switchButton.on {
            State = "On"
        } else {
            State = "Off"
        }
        return State
    }
    
    //return skill value
    func returnSkillValue(parameters : [Int : String]?) -> String {
        var retString: String = "";
        if parameters != nil {
            for(key, value) in parameters! {
                if value != "On" { continue }
                retString += "\(key),"
            }
        }
        return retString
    }
    
    //display aler message box...
    func displayMyAlertMessage(userMessage:String){
        let myAlert = UIAlertController(title: "Happ", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}


/*DON'T DELETE, THIS IS TEST CONNECTION CODE*/
//    func testconnection() {
//        let myURLString = "http://happ.timeriverdesign.com/wp-content/plugins/happ/scripts/insert_user.php"
//
//        if let myURL = NSURL(string: myURLString) {
//
//            do {
//                let myHTMLString = try String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding)
//                print("HTML : \(myHTMLString)")
//            } catch {
//                print("Error : \(error)")
//            }
//        } else {
//            print("Error: \(myURLString) doesn't  URL")
//        }
//    }

