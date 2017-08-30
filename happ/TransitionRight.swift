//
//  TransitionRight.swift
//  happ
//
//  Created by TokikawaTeppei on 27/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class TransitionRight: UIStoryboardSegue {

    override func perform() {
        transitionsRight()
    }
    
    func transitionsRight() {
        let src = self.sourceViewController
        let dst = self.destinationViewController
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransformMakeTranslation(src.view.frame.size.width, 0)
        
        UIView.animateWithDuration(0.25,
            delay: 0.10,
            options: UIViewAnimationOptions.TransitionFlipFromRight,
            animations: {
                dst.view.transform = CGAffineTransformMakeTranslation(0, 0)
            },
            completion: { finished in
                src.presentViewController(dst, animated: false, completion: nil)
            }
        )
    }
    
}
