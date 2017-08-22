//
//  SearchUserViewController.swift
//  happ
//
//  Created by TokikawaTeppei on 08/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class SearchUserViewController: UITableViewController, UISearchResultsUpdating {

    var name:[String] = ["Ricky","Testing", "Roy"]
    var filterName = [String]()
    
    var searchController : UISearchController!
    var resultController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultController.tableView.dataSource = self
        self.resultController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        //        self.searchController.dimsBackgroundDuringPresentation = false
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //filter thourogh names
        
        
        self.filterName = self.name.filter{ ( name: String ) -> Bool in
            if name.lowercaseString.containsString(self.searchController.searchBar.text!.lowercaseString) {
                return true
            } else {
                return false
            }
        }
        //update tableview results..
        self.resultController.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            return self.name.count
        } else {
            return self.filterName.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        if tableView == self.tableView {
            cell.textLabel?.text = self.name[indexPath.row]
            print("\(self.name)\([indexPath.row])")
        } else {
            cell.textLabel?.text = self.filterName[indexPath.row]
        }
        
        
        return cell
    }

}
