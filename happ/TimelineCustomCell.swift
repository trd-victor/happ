//
//  TimelineCustomCell.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/08.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//


class SingleImageView: UITableViewCell {
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var userName: UILabel!
    
    let userContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16)
        return label
    }()
    
    let imgContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let imgView1: UIImageView = {
        let img = UIImageView()
        return img
    }()

}

class DoubleImageView: UITableViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    
    let userContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16)
        return label
    }()
    
    let imgContainer: UIView = {
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
    
}

class TripleImageView: UITableViewCell {
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var btnDelete: UIButton!
    
    
    let userContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16)
        return label
    }()
    
    let imgContainer: UIView = {
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