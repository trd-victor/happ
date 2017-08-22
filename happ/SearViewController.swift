//
//  SearViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 09/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class SearViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet var navigation: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.navigation.hidden = true
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.navigation.hidden = false
        return true
    }
    
    

}
