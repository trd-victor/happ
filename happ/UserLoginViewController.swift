//
//  UserLoginViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 06/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController, UISearchBarDelegate {

    
    
    @IBOutlet var mysearchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //remove back button title 
        self.removeBackButtonTitle()
        
        mysearchbar.delegate = self
        
        self.searchBarShouldEndEditing(mysearchbar)
        self.searchBarShouldEndEditing(mysearchbar)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.backBarButtonItem?.action = Selector("dismissController:")
        
        self.navigationController?.setNavigationBarHidden(false
            , animated: animated)
    }
    
    func removeBackButtonTitle () {
        self.navigationController?.navigationBar.topItem!.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = UIColor.blueColor()
    }
    
    func dismissController(sender: UIBarButtonItem) ->() {
            print("TEST")
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.navigationController?.navigationBarHidden = false
        return true
    }
    
   
}