//
//  TrasitionLeft.swift
//  happ
//
//  Created by TokikawaTeppei on 28/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class TrasitionLeft: UIStoryboardSegue {
    
    override func perform() {
        transitionsleft()
    }
    
    func transitionsleft() {
//        let src: UIViewController = self.sourceViewController
//        let dst: UIViewController = self.destinationViewController
//        let transition: CATransition = CATransition()
//        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.duration = 3
//        transition.timingFunction = timeFunc
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromLeft
//        src.view.layer.addAnimation(transition, forKey: kCATransition)
//        src.presentViewController(dst, animated: false, completion: nil).
        
        
        let src = self.sourceViewController
        let dst = self.destinationViewController
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransformMakeTranslation(-src.view.frame.size.width, 0)
        
        UIView.animateWithDuration(0.25,
            delay: 0.0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: {
                dst.view.transform = CGAffineTransformMakeTranslation(0, 0)
            },
            completion: { finished in
                src.presentViewController(dst, animated: false, completion: nil)
            }
        )
    }
}
