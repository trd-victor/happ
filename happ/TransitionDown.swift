//
//  TransitionDown.swift
//  happ
//
//  Created by TokikawaTeppei on 27/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class TransitionDown: UIStoryboardSegue {

    override func perform() {
        //transitionsDown()
    }
    
    func transitionsDown() {
        let firstVCView = self.sourceViewController.view as UIView!
        let secondVCView = self.destinationViewController.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView.frame = CGRectMake(0.0, -screenHeight, screenWidth, screenHeight)
        secondVCView.backgroundColor = UIColor.clearColor()
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(secondVCView, aboveSubview: firstVCView)
        window?.backgroundColor = UIColor.clearColor()
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            firstVCView.frame = CGRectOffset(firstVCView.frame, 0.0, screenHeight)
            secondVCView.frame = CGRectOffset(secondVCView.frame, 0.0, -screenHeight)
        
            }) { (Finished) -> Void in
                self.sourceViewController.presentViewController(self.destinationViewController,
                    animated: false,
                    completion: nil)
        }
    }
    
}
