//
//  TermsandConditionController.swift
//  happ
//
//  Created by TokikawaTeppei on 24/10/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

class TermsandConditionController: UIViewController {
   
    let navbar: UINavigationBar = UINavigationBar()
    let scrollView: UIScrollView = UIScrollView()
    let lblTerm: UILabel = UILabel()
    let lblDescription: UILabel = UILabel()
    let lblArticle1: UILabel = UILabel()
    let lblArticle1Desc: UILabel = UILabel()
    
    let lblArticle2: UILabel = UILabel()
    let lblArticle2Desc1: UILabel = UILabel()
    let lblArticle2Desc2: UILabel = UILabel()
    let lblArticle2SemiDesc1: UILabel = UILabel()
    let lblArticle2SemiDesc2: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hexString: "#272727")
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.navbar)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.lblTerm)
        self.scrollView.addSubview(self.lblDescription)
        self.scrollView.addSubview(self.lblArticle1)
        self.scrollView.addSubview(self.lblArticle1Desc)
        self.scrollView.addSubview(self.lblArticle2)
        self.scrollView.addSubview(self.lblArticle2Desc1)
        self.scrollView.addSubview(self.lblArticle2Desc2)
        self.scrollView.addSubview(self.lblArticle2SemiDesc1)
        self.scrollView.addSubview(self.lblArticle2SemiDesc2)
        self.autoLayout()
    }
    
    func autoLayout(){
        self.navbar.barTintColor = UIColor(hexString: "#272727")
        self.navbar.translatesAutoresizingMaskIntoConstraints = false
        self.navbar.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
        self.navbar.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.navbar.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        self.navbar.heightAnchor.constraintEqualToConstant(66).active = true
       
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraintEqualToAnchor(self.navbar.bottomAnchor).active = true
        self.scrollView.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
        self.scrollView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        self.scrollView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, constant: -66).active = true
        
        self.lblTerm.translatesAutoresizingMaskIntoConstraints = false
        self.lblTerm.topAnchor.constraintEqualToAnchor(self.scrollView.topAnchor, constant: 10).active = true
        self.lblTerm.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblTerm.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
        self.lblTerm.font = UIFont.boldSystemFontOfSize(18)
        
        self.lblDescription.translatesAutoresizingMaskIntoConstraints = false
        self.lblDescription.topAnchor.constraintEqualToAnchor(self.lblTerm.bottomAnchor, constant: 10).active = true
        self.lblDescription.leftAnchor.constraintEqualToAnchor(self.lblTerm.leftAnchor).active = true
        self.lblDescription.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, constant: -20).active = true
        self.lblDescription.font = UIFont.systemFontOfSize(15)
        self.lblDescription.lineBreakMode = .ByWordWrapping
        self.lblDescription.numberOfLines = 0
        self.lblDescription.textAlignment = .Justified
        
        self.lblArticle1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle1.topAnchor.constraintEqualToAnchor(self.lblDescription.bottomAnchor, constant: 10).active = true
        self.lblArticle1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
        self.lblArticle1.font = UIFont.boldSystemFontOfSize(18)
        
        self.lblArticle1Desc.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle1Desc.topAnchor.constraintEqualToAnchor(self.lblArticle1.bottomAnchor, constant: 10).active = true
        self.lblArticle1Desc.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle1Desc.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle1Desc.font = UIFont.systemFontOfSize(15)
        self.lblArticle1Desc.lineBreakMode = .ByWordWrapping
        self.lblArticle1Desc.numberOfLines = 0
        self.lblArticle1Desc.textAlignment = .Justified

        self.lblArticle2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle2.topAnchor.constraintEqualToAnchor(self.lblArticle1Desc.bottomAnchor, constant: 10).active = true
        self.lblArticle2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor).active = true
        self.lblArticle2.font = UIFont.boldSystemFontOfSize(18)

        
        self.lblArticle2Desc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle2Desc1.topAnchor.constraintEqualToAnchor(self.lblArticle2.bottomAnchor, constant: 10).active = true
        self.lblArticle2Desc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle2Desc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle2Desc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle2Desc1.lineBreakMode = .ByWordWrapping
        self.lblArticle2Desc1.numberOfLines = 0
        self.lblArticle2Desc1.textAlignment = .Justified
        
        self.lblArticle2Desc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle2Desc2.topAnchor.constraintEqualToAnchor(self.lblArticle2Desc1.bottomAnchor, constant: 10).active = true
        self.lblArticle2Desc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle2Desc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle2Desc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle2Desc2.lineBreakMode = .ByWordWrapping
        self.lblArticle2Desc2.numberOfLines = 0
        self.lblArticle2Desc2.textAlignment = .Justified
        
        self.lblArticle2SemiDesc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle2SemiDesc1.topAnchor.constraintEqualToAnchor(self.lblArticle2Desc2.bottomAnchor, constant: 10).active = true
        self.lblArticle2SemiDesc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle2SemiDesc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle2SemiDesc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle2SemiDesc1.lineBreakMode = .ByWordWrapping
        self.lblArticle2SemiDesc1.numberOfLines = 0
        self.lblArticle2SemiDesc1.textAlignment = .Justified
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblTerm.text = "Terms of service"
        self.lblDescription.text = "This Terms of Service (\"Terms of Service\") is a service (hereinafter referred to as \"The Service\") provided by 9 GATES Co., Ltd. (hereinafter referred to as \"The Company\") on this smartphone application It defines the terms of use of. For members of Co-work & Share. H (hereinafter referred to as \"users\"), use this service in accordance with these terms."
        self.lblArticle1.text = "Article 1 (applicable)"
        self.lblArticle1Desc.text = "These Terms shall apply to all relationships relating to the use of this Service between users and the Company."
        self.lblArticle2.text = "Article 2 (Use registration)"
        self.lblArticle2Desc1.text = "\u{25CF} Registration applicant applies for registration of use according to the method defined by the company, and approves this, and registration of use will be completed."
        
        self.lblArticle2Desc2.text = "\u{25CF} We may not approve applications for use registration if we determine that the applicant for use registration has the following reasons and we do not under any obligation to disclose the reason."
        
        self.lblArticle2SemiDesc1.text = "\u{25CC} 1）When notifying of false matters at the time of application for use registration"
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
}
