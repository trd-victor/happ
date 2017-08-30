//
//  LaunchScreenViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 29/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit


class SYSTEM_CONFIG {
    internal var SYS_VAL = NSUserDefaults.standardUserDefaults()
    
    internal func setSYS_VAL(array: AnyObject, key: String){
        if self.SYS_VAL.valueForKey(key) != nil {
            self.SYS_VAL.removeObjectForKey(key)
        }
        self.SYS_VAL.setValue(array, forKey: key)
        self.SYS_VAL.synchronize()
    }
    
    internal func getSYS_VAL(key: String) -> AnyObject?{
        return self.SYS_VAL.valueForKey(key)
    }
}

class LaunchScreenViewController: UIViewController {
    
    var myTimer : NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delayLaunchScreen()
        let config = getSystemValue()
        config.getKey()
        
        
        //setup Views..
        self.setUpView()
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func gotoMainBoard() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let mainViewController = storyBoard.instantiateViewControllerWithIdentifier("MainBoard") as! ViewController
        self.presentViewController(mainViewController, animated:false, completion:nil)
    }
    
    func delayLaunchScreen() {
        self.delay(5.0) {
            self.dismissViewControllerAnimated(false, completion: nil)
            self.gotoMainBoard()
            print("Dismiss ME NOW!")
        }
    }
    
    func setUpView() {
        let viewbg = UIView()
        viewbg.backgroundColor = UIColor(hexString: "#eeeeee")
        view.addSubview(viewbg)
    }



}
