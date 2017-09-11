//
//  CustomCell.swift
//  happ
//
//  Created by TokikawaTeppei on 25/07/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit


class CustomCell: UITableViewCell {
   
    @IBOutlet var uesrImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var userContent: UITextView!
    @IBOutlet var delet: UIButton!
    
    
    let userContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16)
        return label
    }()

    let imageContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let imgView1: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    let imgView2: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    let imgView3: UIImageView = {
        let img = UIImageView()
        return img
    }()
}
