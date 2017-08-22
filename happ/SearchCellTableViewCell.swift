//
//  SearchCellTableViewCell.swift
//  happ
//
//  Created by TokikawaTeppei on 13/08/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class SearchCellTableViewCell: UITableViewCell {

    @IBOutlet var username: UILabel!
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet var imageuser: UIImageView!
    
    @IBOutlet var nameuser: UILabel!
    
    @IBOutlet var skills: UILabel!
    @IBOutlet var secondname: UILabel!
    
    @IBOutlet var userID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
