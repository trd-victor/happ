//
//  NavigationMessage.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/27.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class NavigationMessage: UINavigationController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.topAnchor.constraintEqualToAnchor(view.topAnchor,constant: 22).active = true
        navigationBar.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        navigationBar.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        navigationBar.heightAnchor.constraintEqualToConstant(44).active = true
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
