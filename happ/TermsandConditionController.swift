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
    let lblArticle2SemiDesc3: UILabel = UILabel()
    
    let lblArticle3: UILabel = UILabel()
    let lblArticle3Desc1: UILabel = UILabel()
    let lblArticle3Desc2: UILabel = UILabel()
    
    let lblArticle4: UILabel = UILabel()
    let lblArticle4Desc1: UILabel = UILabel()
    
    let lblArticle5: UILabel = UILabel()
    let lblArticle5Desc: UILabel = UILabel()
    let lblArticle5Desc1: UILabel = UILabel()
    let lblArticle5Desc2: UILabel = UILabel()
    let lblArticle5Desc3: UILabel = UILabel()
    let lblArticle5Desc4: UILabel = UILabel()
    let lblArticle5Desc5: UILabel = UILabel()
    let lblArticle5Desc6: UILabel = UILabel()
    let lblArticle5Desc7: UILabel = UILabel()
    let lblArticle5Desc8: UILabel = UILabel()
    
    let lblArticle6: UILabel = UILabel()
    let lblArticle6Desc1: UILabel = UILabel()
    let lblArticle6SemiDesc1: UILabel = UILabel()
    let lblArticle6SemiDesc2: UILabel = UILabel()
    let lblArticle6SemiDesc3: UILabel = UILabel()
    let lblArticle6SemiDesc4: UILabel = UILabel()
    let lblArticle6Desc2: UILabel = UILabel()
    
    let lblArticle7: UILabel = UILabel()
    let lblArticle7Desc1: UILabel = UILabel()
    let lblArticle7SemiDesc1: UILabel = UILabel()
    let lblArticle7SemiDesc2: UILabel = UILabel()
    let lblArticle7SemiDesc3: UILabel = UILabel()
    let lblArticle7Desc2: UILabel = UILabel()
    
    let lblArticle8: UILabel = UILabel()
    let lblArticle8Desc1: UILabel = UILabel()
    let lblArticle8Desc2: UILabel = UILabel()
    let lblArticle8Desc3: UILabel = UILabel()
    
    let lblArticle9: UILabel = UILabel()
    let lblArticle9Desc: UILabel = UILabel()
    
    let lblArticle10: UILabel = UILabel()
    let lblArticle10Desc: UILabel = UILabel()
    
    let lblArticle11: UILabel = UILabel()
    let lblArticle11Desc: UILabel = UILabel()
    
    let lblArticle12: UILabel = UILabel()
    let lblArticle12Desc: UILabel = UILabel()
    
    let lblArticle13: UILabel = UILabel()
    let lblArticle13Desc1: UILabel = UILabel()
    let lblArticle13Desc2: UILabel = UILabel()
    
    var allheight = 0.0
    
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
        self.scrollView.addSubview(self.lblArticle2SemiDesc3)
        self.scrollView.addSubview(self.lblArticle3)
        self.scrollView.addSubview(self.lblArticle3Desc1)
        self.scrollView.addSubview(self.lblArticle3Desc2)
        self.scrollView.addSubview(self.lblArticle4)
        self.scrollView.addSubview(self.lblArticle4Desc1)
        
        self.scrollView.addSubview(self.lblArticle5)
        self.scrollView.addSubview(self.lblArticle5Desc)
        self.scrollView.addSubview(self.lblArticle5Desc1)
        self.scrollView.addSubview(self.lblArticle5Desc2)
        self.scrollView.addSubview(self.lblArticle5Desc3)
        self.scrollView.addSubview(self.lblArticle5Desc4)
        self.scrollView.addSubview(self.lblArticle5Desc5)
        self.scrollView.addSubview(self.lblArticle5Desc6)
        self.scrollView.addSubview(self.lblArticle5Desc7)
        self.scrollView.addSubview(self.lblArticle5Desc8)
        
        self.scrollView.addSubview(self.lblArticle6)
        self.scrollView.addSubview(self.lblArticle6Desc1)
        self.scrollView.addSubview(self.lblArticle6SemiDesc1)
        self.scrollView.addSubview(self.lblArticle6SemiDesc2)
        self.scrollView.addSubview(self.lblArticle6SemiDesc3)
        self.scrollView.addSubview(self.lblArticle6SemiDesc4)
        self.scrollView.addSubview(self.lblArticle6Desc2)
        
        self.scrollView.addSubview(self.lblArticle7)
        self.scrollView.addSubview(self.lblArticle7Desc1)
        self.scrollView.addSubview(self.lblArticle7SemiDesc1)
        self.scrollView.addSubview(self.lblArticle7SemiDesc2)
        self.scrollView.addSubview(self.lblArticle7SemiDesc3)
        self.scrollView.addSubview(self.lblArticle7Desc2)
        
        self.scrollView.addSubview(self.lblArticle8)
        self.scrollView.addSubview(self.lblArticle8Desc1)
        self.scrollView.addSubview(self.lblArticle8Desc2)
        self.scrollView.addSubview(self.lblArticle8Desc3)
        
        self.scrollView.addSubview(self.lblArticle9)
        self.scrollView.addSubview(self.lblArticle9Desc)
        
        self.scrollView.addSubview(self.lblArticle10)
        self.scrollView.addSubview(self.lblArticle10Desc)
        
        self.scrollView.addSubview(self.lblArticle11)
        self.scrollView.addSubview(self.lblArticle11Desc)
        
        self.scrollView.addSubview(self.lblArticle12)
        self.scrollView.addSubview(self.lblArticle12Desc)
        
        self.scrollView.addSubview(self.lblArticle13)
        self.scrollView.addSubview(self.lblArticle13Desc1)
        self.scrollView.addSubview(self.lblArticle13Desc2)
        
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
        self.lblTerm.lineBreakMode = .ByWordWrapping
        self.lblTerm.numberOfLines = 0
        
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
        self.lblArticle1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle1.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle1.lineBreakMode = .ByWordWrapping
        self.lblArticle1.numberOfLines = 0
        
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
        self.lblArticle2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle2.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle2.lineBreakMode = .ByWordWrapping
        self.lblArticle2.numberOfLines = 0
        
        self.lblArticle2Desc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle2Desc1.topAnchor.constraintEqualToAnchor(self.lblArticle2.bottomAnchor, constant: 10).active = true
        self.lblArticle2Desc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle2Desc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle2Desc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle2Desc1.lineBreakMode = .ByWordWrapping
        self.lblArticle2Desc1.numberOfLines = 0
        self.lblArticle2Desc1.textAlignment = .Justified
        
        self.lblArticle2Desc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle2Desc2.topAnchor.constraintEqualToAnchor(self.lblArticle2Desc1.bottomAnchor, constant: 5).active = true
        self.lblArticle2Desc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle2Desc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle2Desc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle2Desc2.lineBreakMode = .ByWordWrapping
        self.lblArticle2Desc2.numberOfLines = 0
        self.lblArticle2Desc2.textAlignment = .Justified
        
        self.lblArticle2SemiDesc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle2SemiDesc1.topAnchor.constraintEqualToAnchor(self.lblArticle2Desc2.bottomAnchor, constant: 5).active = true
        self.lblArticle2SemiDesc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle2SemiDesc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle2SemiDesc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle2SemiDesc1.lineBreakMode = .ByWordWrapping
        self.lblArticle2SemiDesc1.numberOfLines = 0
        self.lblArticle2SemiDesc1.textAlignment = .Justified
        
        self.lblArticle2SemiDesc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle2SemiDesc2.topAnchor.constraintEqualToAnchor(self.lblArticle2SemiDesc1.bottomAnchor, constant: 5).active = true
        self.lblArticle2SemiDesc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle2SemiDesc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle2SemiDesc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle2SemiDesc2.lineBreakMode = .ByWordWrapping
        self.lblArticle2SemiDesc2.numberOfLines = 0
        self.lblArticle2SemiDesc2.textAlignment = .Justified
        
        self.lblArticle2SemiDesc3.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle2SemiDesc3.topAnchor.constraintEqualToAnchor(self.lblArticle2SemiDesc2.bottomAnchor, constant: 5).active = true
        self.lblArticle2SemiDesc3.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle2SemiDesc3.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle2SemiDesc3.font = UIFont.systemFontOfSize(15)
        self.lblArticle2SemiDesc3.lineBreakMode = .ByWordWrapping
        self.lblArticle2SemiDesc3.numberOfLines = 0
        self.lblArticle2SemiDesc3.textAlignment = .Justified
        
        self.lblArticle3.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle3.topAnchor.constraintEqualToAnchor(self.lblArticle2SemiDesc3.bottomAnchor, constant: 10).active = true
        self.lblArticle3.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle3.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle3.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle3.lineBreakMode = .ByWordWrapping
        self.lblArticle3.numberOfLines = 0
        
        self.lblArticle3Desc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle3Desc1.topAnchor.constraintEqualToAnchor(self.lblArticle3.bottomAnchor, constant: 10).active = true
        self.lblArticle3Desc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle3Desc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle3Desc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle3Desc1.lineBreakMode = .ByWordWrapping
        self.lblArticle3Desc1.numberOfLines = 0
        self.lblArticle3Desc1.textAlignment = .Justified
        
        self.lblArticle3Desc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle3Desc2.topAnchor.constraintEqualToAnchor(self.lblArticle3Desc1.bottomAnchor, constant: 5).active = true
        self.lblArticle3Desc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle3Desc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle3Desc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle3Desc2.lineBreakMode = .ByWordWrapping
        self.lblArticle3Desc2.numberOfLines = 0
        self.lblArticle3Desc2.textAlignment = .Justified
        
        self.lblArticle4.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle4.topAnchor.constraintEqualToAnchor(self.lblArticle3Desc2.bottomAnchor, constant: 10).active = true
        self.lblArticle4.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle4.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle4.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle4.lineBreakMode = .ByWordWrapping
        self.lblArticle4.numberOfLines = 0
        
        self.lblArticle4Desc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle4Desc1.topAnchor.constraintEqualToAnchor(self.lblArticle4.bottomAnchor, constant: 10).active = true
        self.lblArticle4Desc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle4Desc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle4Desc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle4Desc1.lineBreakMode = .ByWordWrapping
        self.lblArticle4Desc1.numberOfLines = 0
        self.lblArticle4Desc1.textAlignment = .Justified
        
        self.lblArticle5.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5.topAnchor.constraintEqualToAnchor(self.lblArticle4Desc1.bottomAnchor, constant: 10).active = true
        self.lblArticle5.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle5.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle5.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle5.lineBreakMode = .ByWordWrapping
        self.lblArticle5.numberOfLines = 0
        
        self.lblArticle5Desc.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5Desc.topAnchor.constraintEqualToAnchor(self.lblArticle5.bottomAnchor, constant: 10).active = true
        self.lblArticle5Desc.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle5Desc.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle5Desc.font = UIFont.systemFontOfSize(15)
        self.lblArticle5Desc.lineBreakMode = .ByWordWrapping
        self.lblArticle5Desc.numberOfLines = 0
        self.lblArticle5Desc.textAlignment = .Justified
        
        self.lblArticle5Desc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5Desc1.topAnchor.constraintEqualToAnchor(self.lblArticle5Desc.bottomAnchor, constant: 5).active = true
        self.lblArticle5Desc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle5Desc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle5Desc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle5Desc1.lineBreakMode = .ByWordWrapping
        self.lblArticle5Desc1.numberOfLines = 0
        self.lblArticle5Desc1.textAlignment = .Justified
        
        self.lblArticle5Desc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5Desc2.topAnchor.constraintEqualToAnchor(self.lblArticle5Desc1.bottomAnchor, constant: 5).active = true
        self.lblArticle5Desc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle5Desc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle5Desc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle5Desc2.lineBreakMode = .ByWordWrapping
        self.lblArticle5Desc2.numberOfLines = 0
        self.lblArticle5Desc2.textAlignment = .Justified
        
        self.lblArticle5Desc3.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5Desc3.topAnchor.constraintEqualToAnchor(self.lblArticle5Desc2.bottomAnchor, constant: 5).active = true
        self.lblArticle5Desc3.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle5Desc3.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle5Desc3.font = UIFont.systemFontOfSize(15)
        self.lblArticle5Desc3.lineBreakMode = .ByWordWrapping
        self.lblArticle5Desc3.numberOfLines = 0
        self.lblArticle5Desc3.textAlignment = .Justified
        
        self.lblArticle5Desc4.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5Desc4.topAnchor.constraintEqualToAnchor(self.lblArticle5Desc3.bottomAnchor, constant: 5).active = true
        self.lblArticle5Desc4.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle5Desc4.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle5Desc4.font = UIFont.systemFontOfSize(15)
        self.lblArticle5Desc4.lineBreakMode = .ByWordWrapping
        self.lblArticle5Desc4.numberOfLines = 0
        self.lblArticle5Desc4.textAlignment = .Justified
        
        self.lblArticle5Desc5.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5Desc5.topAnchor.constraintEqualToAnchor(self.lblArticle5Desc4.bottomAnchor, constant: 5).active = true
        self.lblArticle5Desc5.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle5Desc5.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle5Desc5.font = UIFont.systemFontOfSize(15)
        self.lblArticle5Desc5.lineBreakMode = .ByWordWrapping
        self.lblArticle5Desc5.numberOfLines = 0
        self.lblArticle5Desc5.textAlignment = .Justified
        
        self.lblArticle5Desc6.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5Desc6.topAnchor.constraintEqualToAnchor(self.lblArticle5Desc5.bottomAnchor, constant: 5).active = true
        self.lblArticle5Desc6.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle5Desc6.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle5Desc6.font = UIFont.systemFontOfSize(15)
        self.lblArticle5Desc6.lineBreakMode = .ByWordWrapping
        self.lblArticle5Desc6.numberOfLines = 0
        self.lblArticle5Desc6.textAlignment = .Justified
        
        self.lblArticle5Desc7.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5Desc7.topAnchor.constraintEqualToAnchor(self.lblArticle5Desc6.bottomAnchor, constant: 5).active = true
        self.lblArticle5Desc7.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle5Desc7.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle5Desc7.font = UIFont.systemFontOfSize(15)
        self.lblArticle5Desc7.lineBreakMode = .ByWordWrapping
        self.lblArticle5Desc7.numberOfLines = 0
        self.lblArticle5Desc7.textAlignment = .Justified
        
        self.lblArticle5Desc8.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle5Desc8.topAnchor.constraintEqualToAnchor(self.lblArticle5Desc7.bottomAnchor, constant: 5).active = true
        self.lblArticle5Desc8.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle5Desc8.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle5Desc8.font = UIFont.systemFontOfSize(15)
        self.lblArticle5Desc8.lineBreakMode = .ByWordWrapping
        self.lblArticle5Desc8.numberOfLines = 0
        self.lblArticle5Desc8.textAlignment = .Justified
        
        self.lblArticle6.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle6.topAnchor.constraintEqualToAnchor(self.lblArticle5Desc8.bottomAnchor, constant: 10).active = true
        self.lblArticle6.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle6.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle6.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle6.lineBreakMode = .ByWordWrapping
        self.lblArticle6.numberOfLines = 0
        
        self.lblArticle6Desc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle6Desc1.topAnchor.constraintEqualToAnchor(self.lblArticle6.bottomAnchor, constant: 10).active = true
        self.lblArticle6Desc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle6Desc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle6Desc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle6Desc1.lineBreakMode = .ByWordWrapping
        self.lblArticle6Desc1.numberOfLines = 0
        self.lblArticle6Desc1.textAlignment = .Justified
        
        self.lblArticle6SemiDesc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle6SemiDesc1.topAnchor.constraintEqualToAnchor(self.lblArticle6Desc1.bottomAnchor, constant: 5).active = true
        self.lblArticle6SemiDesc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle6SemiDesc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle6SemiDesc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle6SemiDesc1.lineBreakMode = .ByWordWrapping
        self.lblArticle6SemiDesc1.numberOfLines = 0
        self.lblArticle6SemiDesc1.textAlignment = .Justified
        
        self.lblArticle6SemiDesc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle6SemiDesc2.topAnchor.constraintEqualToAnchor(self.lblArticle6SemiDesc1.bottomAnchor, constant: 5).active = true
        self.lblArticle6SemiDesc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle6SemiDesc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle6SemiDesc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle6SemiDesc2.lineBreakMode = .ByWordWrapping
        self.lblArticle6SemiDesc2.numberOfLines = 0
        self.lblArticle6SemiDesc2.textAlignment = .Justified
        
        self.lblArticle6SemiDesc3.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle6SemiDesc3.topAnchor.constraintEqualToAnchor(self.lblArticle6SemiDesc2.bottomAnchor, constant: 5).active = true
        self.lblArticle6SemiDesc3.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle6SemiDesc3.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle6SemiDesc3.font = UIFont.systemFontOfSize(15)
        self.lblArticle6SemiDesc3.lineBreakMode = .ByWordWrapping
        self.lblArticle6SemiDesc3.numberOfLines = 0
        self.lblArticle6SemiDesc3.textAlignment = .Justified
        
        self.lblArticle6SemiDesc4.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle6SemiDesc4.topAnchor.constraintEqualToAnchor(self.lblArticle6SemiDesc3.bottomAnchor, constant: 5).active = true
        self.lblArticle6SemiDesc4.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle6SemiDesc4.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle6SemiDesc4.font = UIFont.systemFontOfSize(15)
        self.lblArticle6SemiDesc4.lineBreakMode = .ByWordWrapping
        self.lblArticle6SemiDesc4.numberOfLines = 0
        self.lblArticle6SemiDesc4.textAlignment = .Justified
        
        self.lblArticle6Desc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle6Desc2.topAnchor.constraintEqualToAnchor(self.lblArticle6SemiDesc4.bottomAnchor, constant: 5).active = true
        self.lblArticle6Desc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle6Desc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle6Desc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle6Desc2.lineBreakMode = .ByWordWrapping
        self.lblArticle6Desc2.numberOfLines = 0
        self.lblArticle6Desc2.textAlignment = .Justified
        
        self.lblArticle7.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle7.topAnchor.constraintEqualToAnchor(self.lblArticle6Desc2.bottomAnchor, constant: 10).active = true
        self.lblArticle7.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle7.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle7.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle7.lineBreakMode = .ByWordWrapping
        self.lblArticle7.numberOfLines = 0
        
        self.lblArticle7Desc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle7Desc1.topAnchor.constraintEqualToAnchor(self.lblArticle7.bottomAnchor, constant: 10).active = true
        self.lblArticle7Desc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle7Desc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle7Desc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle7Desc1.lineBreakMode = .ByWordWrapping
        self.lblArticle7Desc1.numberOfLines = 0
        self.lblArticle7Desc1.textAlignment = .Justified
        
        self.lblArticle7SemiDesc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle7SemiDesc1.topAnchor.constraintEqualToAnchor(self.lblArticle7Desc1.bottomAnchor, constant: 5).active = true
        self.lblArticle7SemiDesc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle7SemiDesc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle7SemiDesc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle7SemiDesc1.lineBreakMode = .ByWordWrapping
        self.lblArticle7SemiDesc1.numberOfLines = 0
        self.lblArticle7SemiDesc1.textAlignment = .Justified
        
        self.lblArticle7SemiDesc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle7SemiDesc2.topAnchor.constraintEqualToAnchor(self.lblArticle7SemiDesc1.bottomAnchor, constant: 5).active = true
        self.lblArticle7SemiDesc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle7SemiDesc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle7SemiDesc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle7SemiDesc2.lineBreakMode = .ByWordWrapping
        self.lblArticle7SemiDesc2.numberOfLines = 0
        self.lblArticle7SemiDesc2.textAlignment = .Justified
        
        self.lblArticle7SemiDesc3.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle7SemiDesc3.topAnchor.constraintEqualToAnchor(self.lblArticle7SemiDesc2.bottomAnchor, constant: 5).active = true
        self.lblArticle7SemiDesc3.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 30).active = true
        self.lblArticle7SemiDesc3.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -40).active = true
        self.lblArticle7SemiDesc3.font = UIFont.systemFontOfSize(15)
        self.lblArticle7SemiDesc3.lineBreakMode = .ByWordWrapping
        self.lblArticle7SemiDesc3.numberOfLines = 0
        self.lblArticle7SemiDesc3.textAlignment = .Justified
        
        self.lblArticle7Desc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle7Desc2.topAnchor.constraintEqualToAnchor(self.lblArticle7SemiDesc3.bottomAnchor, constant: 5).active = true
        self.lblArticle7Desc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle7Desc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle7Desc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle7Desc2.lineBreakMode = .ByWordWrapping
        self.lblArticle7Desc2.numberOfLines = 0
        self.lblArticle7Desc2.textAlignment = .Justified
        
        self.lblArticle8.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle8.topAnchor.constraintEqualToAnchor(self.lblArticle7Desc2.bottomAnchor, constant: 10).active = true
        self.lblArticle8.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle8.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle8.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle8.lineBreakMode = .ByWordWrapping
        self.lblArticle8.numberOfLines = 0
        
        self.lblArticle8Desc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle8Desc1.topAnchor.constraintEqualToAnchor(self.lblArticle8.bottomAnchor, constant: 10).active = true
        self.lblArticle8Desc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle8Desc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle8Desc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle8Desc1.lineBreakMode = .ByWordWrapping
        self.lblArticle8Desc1.numberOfLines = 0
        self.lblArticle8Desc1.textAlignment = .Justified
        
        self.lblArticle8Desc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle8Desc2.topAnchor.constraintEqualToAnchor(self.lblArticle8Desc1.bottomAnchor, constant: 5).active = true
        self.lblArticle8Desc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle8Desc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle8Desc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle8Desc2.lineBreakMode = .ByWordWrapping
        self.lblArticle8Desc2.numberOfLines = 0
        self.lblArticle8Desc2.textAlignment = .Justified
        
        self.lblArticle8Desc3.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle8Desc3.topAnchor.constraintEqualToAnchor(self.lblArticle8Desc2.bottomAnchor, constant: 5).active = true
        self.lblArticle8Desc3.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle8Desc3.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle8Desc3.font = UIFont.systemFontOfSize(15)
        self.lblArticle8Desc3.lineBreakMode = .ByWordWrapping
        self.lblArticle8Desc3.numberOfLines = 0
        self.lblArticle8Desc3.textAlignment = .Justified

        self.lblArticle9.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle9.topAnchor.constraintEqualToAnchor(self.lblArticle8Desc3.bottomAnchor, constant: 10).active = true
        self.lblArticle9.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle9.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle9.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle9.lineBreakMode = .ByWordWrapping
        self.lblArticle9.numberOfLines = 0
        
        self.lblArticle9Desc.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle9Desc.topAnchor.constraintEqualToAnchor(self.lblArticle9.bottomAnchor, constant: 10).active = true
        self.lblArticle9Desc.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle9Desc.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle9Desc.font = UIFont.systemFontOfSize(15)
        self.lblArticle9Desc.lineBreakMode = .ByWordWrapping
        self.lblArticle9Desc.numberOfLines = 0
        self.lblArticle9Desc.textAlignment = .Justified
        
        self.lblArticle10.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle10.topAnchor.constraintEqualToAnchor(self.lblArticle9Desc.bottomAnchor, constant: 10).active = true
        self.lblArticle10.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle10.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle10.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle10.lineBreakMode = .ByWordWrapping
        self.lblArticle10.numberOfLines = 0
        
        self.lblArticle10Desc.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle10Desc.topAnchor.constraintEqualToAnchor(self.lblArticle10.bottomAnchor, constant: 10).active = true
        self.lblArticle10Desc.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle10Desc.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle10Desc.font = UIFont.systemFontOfSize(15)
        self.lblArticle10Desc.lineBreakMode = .ByWordWrapping
        self.lblArticle10Desc.numberOfLines = 0
        
        self.lblArticle11.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle11.topAnchor.constraintEqualToAnchor(self.lblArticle10Desc.bottomAnchor, constant: 10).active = true
        self.lblArticle11.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle11.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle11.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle11.lineBreakMode = .ByWordWrapping
        self.lblArticle11.numberOfLines = 0
        
        self.lblArticle11Desc.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle11Desc.topAnchor.constraintEqualToAnchor(self.lblArticle11.bottomAnchor, constant: 10).active = true
        self.lblArticle11Desc.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle11Desc.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle11Desc.font = UIFont.systemFontOfSize(15)
        self.lblArticle11Desc.lineBreakMode = .ByWordWrapping
        self.lblArticle11Desc.numberOfLines = 0
        self.lblArticle11Desc.textAlignment = .Justified
        
        self.lblArticle12.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle12.topAnchor.constraintEqualToAnchor(self.lblArticle11Desc.bottomAnchor, constant: 10).active = true
        self.lblArticle12.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle12.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle12.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle12.lineBreakMode = .ByWordWrapping
        self.lblArticle12.numberOfLines = 0
        
        self.lblArticle12Desc.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle12Desc.topAnchor.constraintEqualToAnchor(self.lblArticle12.bottomAnchor, constant: 10).active = true
        self.lblArticle12Desc.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle12Desc.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle12Desc.font = UIFont.systemFontOfSize(15)
        self.lblArticle12Desc.lineBreakMode = .ByWordWrapping
        self.lblArticle12Desc.numberOfLines = 0
        self.lblArticle12Desc.textAlignment = .Justified
        
        self.lblArticle13.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle13.topAnchor.constraintEqualToAnchor(self.lblArticle12Desc.bottomAnchor, constant: 10).active = true
        self.lblArticle13.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 10).active = true
        self.lblArticle13.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -20).active = true
        self.lblArticle13.font = UIFont.boldSystemFontOfSize(18)
        self.lblArticle13.lineBreakMode = .ByWordWrapping
        self.lblArticle13.numberOfLines = 0
        
        self.lblArticle13Desc1.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle13Desc1.topAnchor.constraintEqualToAnchor(self.lblArticle13.bottomAnchor, constant: 10).active = true
        self.lblArticle13Desc1.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle13Desc1.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle13Desc1.font = UIFont.systemFontOfSize(15)
        self.lblArticle13Desc1.lineBreakMode = .ByWordWrapping
        self.lblArticle13Desc1.numberOfLines = 0
        self.lblArticle13Desc1.textAlignment = .Justified
        
        self.lblArticle13Desc2.translatesAutoresizingMaskIntoConstraints = false
        self.lblArticle13Desc2.topAnchor.constraintEqualToAnchor(self.lblArticle13Desc1.bottomAnchor, constant: 5).active = true
        self.lblArticle13Desc2.leftAnchor.constraintEqualToAnchor(self.scrollView.leftAnchor, constant: 20).active = true
        self.lblArticle13Desc2.widthAnchor.constraintEqualToAnchor(self.scrollView.widthAnchor, constant: -30).active = true
        self.lblArticle13Desc2.font = UIFont.systemFontOfSize(15)
        self.lblArticle13Desc2.lineBreakMode = .ByWordWrapping
        self.lblArticle13Desc2.numberOfLines = 0
        self.lblArticle13Desc2.textAlignment = .Justified
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let config = SYSTEM_CONFIG()
        var lang =  ""
        let titlestr = config.translate("license_agreement")
        let agreeStr = config.translate("button_accept")
        
        let navItem = UINavigationItem(title: titlestr)
        let btnBack = UIBarButtonItem(image: UIImage(named: "Image"), style: .Plain, target: self, action: Selector("backToMenu:"))
        btnBack.tintColor = UIColor.whiteColor()
        
        let btnAccept = UIBarButtonItem(title: agreeStr, style: .Plain, target: self, action: Selector("goToRegist"))
        btnAccept.tintColor = UIColor.whiteColor()
        
        //closer to left anchor nav
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSpacer.tintColor = UIColor(hexString: "#272727")
        negativeSpacer.width = -15
        
        navItem.setRightBarButtonItem(btnAccept, animated: false)
        navItem.setLeftBarButtonItems([negativeSpacer, btnBack], animated: false)
        
        self.navbar.setItems([navItem], animated: false)
        self.navbar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        if let language = config.getSYS_VAL("AppLanguage") {
            lang = language as! String
        }
        
        if lang == "en" || lang == "" {
            self.lblTerm.text = "Terms of service"
            self.lblDescription.text = "This Terms of Service (\"Terms of Service\") is a service (hereinafter referred to as \"The Service\") provided by 9 GATES Co., Ltd. (hereinafter referred to as \"The Company\") on this smartphone application It defines the terms of use of. For members of Co-work & Share. H (hereinafter referred to as \"users\"), use this service in accordance with these terms."
            self.lblArticle1.text = "Article 1 (Applicable)"
            self.lblArticle1Desc.text = "These Terms shall apply to all relationships relating to the use of this Service between users and the Company."
            self.lblArticle2.text = "Article 2 (Use registration)"
            self.lblArticle2Desc1.text = "\u{25CF} Registration applicant applies for registration of use according to the method defined by the company, and approves this, and registration of use will be completed."
            
            self.lblArticle2Desc2.text = "\u{25CF} We may not approve applications for use registration if we determine that the applicant for use registration has the following reasons and we do not under any obligation to disclose the reason."
            
            self.lblArticle2SemiDesc1.text = "\u{25CC} (1）When notifying of false matters at the time of application for use registration"
            self.lblArticle2SemiDesc2.text = "\u{25CC} (2）In the case of an application from a person who has violated this agreement"
            self.lblArticle2SemiDesc3.text = "\u{25CC} (3）In addition, when we judge that usage registration is not appropriate"
            
            self.lblArticle3.text = "Article 3 (User ID and Password Management)"
            self.lblArticle3Desc1.text = "\u{25CF} The user shall manage the user ID and password of this service at its own risk"
            self.lblArticle3Desc2.text = "\u{25CF} In any case, the user can not assign or lend the user ID and password to a third party. If the combination of user ID and password is logged in consistent with the registration information, we regard it as use by the user who registered the user ID."
            
            self.lblArticle4.text = "Article 4 (Usage fee and payment method)"
            self.lblArticle4Desc1.text = "\u{25CF} The user shall be able to use this service free of charge"
            
            self.lblArticle5.text = "Article 5 (Prohibited Matters)"
            self.lblArticle5Desc.text = "In using the service, the user should not do the following actions."
            self.lblArticle5Desc1.text = "\u{25CF} (1）Acts that violate laws or public order and morals"
            self.lblArticle5Desc2.text = "\u{25CF} (2）Acts related to criminal acts"
            self.lblArticle5Desc3.text = "\u{25CF} (3）Acts of destroying or obstructing the function of our server or network"
            self.lblArticle5Desc4.text = "\u{25CF} (4）Acts that may interfere with the operation of our services"
            self.lblArticle5Desc5.text = "\u{25CF} (5）Acts of collecting or accumulating personal information etc. concerning other users"
            self.lblArticle5Desc6.text = "\u{25CF} (6）Act impersonating other users"
            self.lblArticle5Desc7.text = "\u{25CF} (7）Acts of providing profit directly or indirectly to antisocial forces in connection with our services"
            self.lblArticle5Desc8.text = "\u{25CF} (8）Other acts that we deem inappropriate"
            
            self.lblArticle6.text = "Article 6 (Suspension of provision of this service etc.)"
            self.lblArticle6Desc1.text = "\u{25CF} The Company shall be able to suspend or suspend the provision of all or part of the Service without notifying the user in advance if judging that there is any of the following reasons."
            self.lblArticle6SemiDesc1.text = "\u{25CC} (1）When performing maintenance, inspection, or updating of the computer system related to this service"
            self.lblArticle6SemiDesc2.text = "\u{25CC} (2）When it becomes difficult to provide this service due to force majeure such as earthquake, lightning strike, fire, blackout or natural disaster"
            self.lblArticle6SemiDesc3.text = "\u{25CC} (3）When a computer or a communication line stops due to an accident"
            self.lblArticle6SemiDesc4.text = "\u{25CC} (4）In addition, if we determine that it is difficult to provide this service"
            self.lblArticle6Desc2.text = "\u{25CF} We shall not bear any responsibility for any disadvantage or damage suffered by users or third parties due to suspension or interruption of the provision of this service, regardless of reason."
            
            self.lblArticle7.text = "Article 7 (Limitation on use and deletion of registration)"
            self.lblArticle7Desc1.text = "\u{25CF} In the following cases, we may restrict the use of all or part of this service to the user without prior notice, or may cancel the registration as a user."
            self.lblArticle7SemiDesc1.text = "\u{25CC} (1）In the event of violating any provision of these Terms"
            self.lblArticle7SemiDesc2.text = "\u{25CC} (2）When it turns out that there is a false fact in the registration matter"
            self.lblArticle7SemiDesc3.text = "\u{25CC} (3）In the event that we judge that the use of this service is not appropriate"
            self.lblArticle7Desc2.text = "\u{25CF} We are not responsible for any damage caused to the user by the actions our company did under this section."
            
            self.lblArticle8.text = "Article 8 (Exemption)"
            self.lblArticle8Desc1.text = "\u{25CF} The Company's obligation defaults shall be exempted from liability if it is not based on our intention or gross negligence."
            self.lblArticle8Desc2.text = "\u{25CF} We are liable for compensation only within the range of damage that is normally incurred even if we take responsibility for some reason and within the range of payment amount (equivalent to one month in case of continuous service) for paid services Shall be assumed."
            self.lblArticle8Desc3.text = "\u{25CF} We are not responsible for any transactions, communications or disputes, etc. arising between you and other users or third parties regarding this service."
            
            self.lblArticle9.text = "Article 9 (Changes in service content etc.)"
            self.lblArticle9Desc.text = "The Company shall be able to change the content of this service or cancel the provision of this service without notifying the user and will not bear any responsibility for damage caused to the user by this."
            
            self.lblArticle10.text = "Article 10 (Change of Terms of Service)"
            self.lblArticle10Desc.text = "We can change this agreement at any time without notifying the user if we deem it necessary."
            
            self.lblArticle11.text = "Article 11 (Notification or contact)"
            self.lblArticle11Desc.text = "The notice or contact between the user and the Company shall be made according to the method specified by the Company."
            
            self.lblArticle12.text = "Article 12 (Prohibition of Transfer of Rights and Obligations)"
            self.lblArticle12Desc.text = "The user can not transfer the rights or obligations under the terms of use or third agreement to third parties without prior consent of the Company in writing and can not be used as collateral."
            
            self.lblArticle13.text = "Article 13 (Governing Law and Jurisdiction)"
            self.lblArticle13Desc1.text = "\u{25CF} In interpreting these Terms, the Japanese law shall be the governing law."
            self.lblArticle13Desc2.text = "\u{25CF} In the event of a dispute with respect to this Service, the court having jurisdiction over the head office location of the Company shall be subject to exclusive agreement jurisdiction."

        }else{
            self.lblTerm.text = "利用規約"
            self.lblDescription.text = "この利用規約（以下，「本規約」といいます。）は，株式会社9GATES（以下，「当社」といいます。）がこのスマートフォンアプリ上で提供するサービス（以下，「本サービス」といいます。）の利用条件を定めるものです。Co-work & Share. Hの会員の皆さま（以下，「ユーザー」といいます。）には，本規約に従って，本サービスをご利用いただきます。"
            
            self.lblArticle1.text = "第1条（適用）"
            self.lblArticle1Desc.text = "本規約は，ユーザーと当社との間の本サービスの利用に関わる一切の関係に適用されるものとします。"
            
            self.lblArticle2.text = "第2条（利用登録）"
            self.lblArticle2Desc1.text = "\u{25CF} 登録希望者が当社の定める方法によって利用登録を申請し，当社がこれを承認することによって，利用登録が完了するものとします。"
            
            self.lblArticle2Desc2.text = "\u{25CF} 当社は，利用登録の申請者に以下の事由があると判断した場合，利用登録の申請を承認しないことがあり，その理由については一切の開示義務を負わないものとします。"
            
            self.lblArticle2SemiDesc1.text = "\u{25CC} (1）利用登録の申請に際して虚偽の事項を届け出た場合"
            self.lblArticle2SemiDesc2.text = "\u{25CC} (2）本規約に違反したことがある者からの申請である場合"
            self.lblArticle2SemiDesc3.text = "\u{25CC} (3）その他，当社が利用登録を相当でないと判断した場合"
            
            self.lblArticle3.text = "第3条（ユーザーIDおよびパスワードの管理）"
            self.lblArticle3Desc1.text = "\u{25CF} ユーザーは，自己の責任において，本サービスのユーザーIDおよびパスワードを管理するものとします。"
            self.lblArticle3Desc2.text = "\u{25CF} ユーザーは，いかなる場合にも，ユーザーIDおよびパスワードを第三者に譲渡または貸与することはできません。当社は，ユーザーIDとパスワードの組み合わせが登録情報と一致してログインされた場合には，そのユーザーIDを登録しているユーザー自身による利用とみなします。"
            
            self.lblArticle4.text = "第4条（利用料金および支払方法）"
            self.lblArticle4Desc1.text = "\u{25CF} ユーザーは，本サービスを無償で利用できるものとする"
            
            self.lblArticle5.text = "第5条（禁止事項）"
            self.lblArticle5Desc.text = "ユーザーは，本サービスの利用にあたり，以下の行為をしてはなりません。"
            self.lblArticle5Desc1.text = "\u{25CF} (1）法令または公序良俗に違反する行為"
            self.lblArticle5Desc2.text = "\u{25CF} (2）犯罪行為に関連する行為"
            self.lblArticle5Desc3.text = "\u{25CF} (3）当社のサーバーまたはネットワークの機能を破壊したり，妨害したりする行為"
            self.lblArticle5Desc4.text = "\u{25CF} (4）当社のサービスの運営を妨害するおそれのある行為"
            self.lblArticle5Desc5.text = "\u{25CF} (5）他のユーザーに関する個人情報等を収集または蓄積する行為"
            self.lblArticle5Desc6.text = "\u{25CF} (6）他のユーザーに成りすます行為"
            self.lblArticle5Desc7.text = "\u{25CF} (7）当社のサービスに関連して，反社会的勢力に対して直接または間接に利益を供与する行為"
            self.lblArticle5Desc8.text = "\u{25CF} (8）その他，当社が不適切と判断する行為"
            
            self.lblArticle6.text = "第6条（本サービスの提供の停止等）"
            self.lblArticle6Desc1.text = "\u{25CF} 当社は，以下のいずれかの事由があると判断した場合，ユーザーに事前に通知することなく本サービスの全部または一部の提供を停止または中断することができるものとします。"
            self.lblArticle6SemiDesc1.text = "\u{25CC} (1）本サービスにかかるコンピュータシステムの保守点検または更新を行う場合"
            self.lblArticle6SemiDesc2.text = "\u{25CC} (2）地震，落雷，火災，停電または天災などの不可抗力により，本サービスの提供が困難となった場合"
            self.lblArticle6SemiDesc3.text = "\u{25CC} (3）コンピュータまたは通信回線等が事故により停止した場合"
            self.lblArticle6SemiDesc4.text = "\u{25CC} (4）その他，当社が本サービスの提供が困難と判断した場合"
            self.lblArticle6Desc2.text = "\u{25CF} 当社は，本サービスの提供の停止または中断により，ユーザーまたは第三者が被ったいかなる不利益または損害について，理由を問わず一切の責任を負わないものとします。"
            
            self.lblArticle7.text = "第7条（利用制限および登録抹消）"
            self.lblArticle7Desc1.text = "\u{25CF} 当社は，以下の場合には，事前の通知なく，ユーザーに対して，本サービスの全部もしくは一部の利用を制限し，またはユーザーとしての登録を抹消することができるものとします。"
            self.lblArticle7SemiDesc1.text = "\u{25CC} (1）本規約のいずれかの条項に違反した場合"
            self.lblArticle7SemiDesc2.text = "\u{25CC} (2）登録事項に虚偽の事実があることが判明した場合"
            self.lblArticle7SemiDesc3.text = "\u{25CC} (3）その他，当社が本サービスの利用を適当でないと判断した場合"
            self.lblArticle7Desc2.text = "\u{25CF} 当社は，本条に基づき当社が行った行為によりユーザーに生じた損害について，一切の責任を負いません。"
            
            self.lblArticle8.text = "第8条（免責事項）"
            self.lblArticle8Desc1.text = "\u{25CF} 当社の債務不履行責任は，当社の故意または重過失によらない場合には免責されるものとします。"
            self.lblArticle8Desc2.text = "\u{25CF} 当社は，何らかの理由によって責任を負う場合にも，通常生じうる損害の範囲内かつ有料サービスにおいては代金額（継続的サービスの場合には1か月分相当額）の範囲内においてのみ賠償の責任を負うものとします。"
            self.lblArticle8Desc3.text = "\u{25CF} 当社は，本サービスに関して，ユーザーと他のユーザーまたは第三者との間において生じた取引，連絡または紛争等について一切責任を負いません。"
            
            self.lblArticle9.text = "第9条（サービス内容の変更等）"
            self.lblArticle9Desc.text = "当社は，ユーザーに通知することなく，本サービスの内容を変更しまたは本サービスの提供を中止することができるものとし，これによってユーザーに生じた損害について一切の責任を負いません。"
            
            self.lblArticle10.text = "第10条（利用規約の変更）"
            self.lblArticle10Desc.text = "当社は，必要と判断した場合には，ユーザーに通知することなくいつでも本規約を変更することができるものとします。"
            
            self.lblArticle11.text = "第11条（通知または連絡）"
            self.lblArticle11Desc.text = "ユーザーと当社との間の通知または連絡は，当社の定める方法によって行うものとします。"
            
            self.lblArticle12.text = "第12条（権利義務の譲渡の禁止）"
            self.lblArticle12Desc.text = "ユーザーは，当社の書面による事前の承諾なく，利用契約上の地位または本規約に基づく権利もしくは義務を第三者に譲渡し，または担保に供することはできません。"
            
            self.lblArticle13.text = "第13条（準拠法・裁判管轄）"
            self.lblArticle13Desc1.text = "\u{25CF} 本規約の解釈にあたっては，日本法を準拠法とします。"
            self.lblArticle13Desc2.text = "\u{25CF} 本サービスに関して紛争が生じた場合には，当社の本店所在地を管轄する裁判所を専属的合意管轄とします。"
        }
        
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
        
        let last_origin_y: CGFloat = lblArticle13Desc2.frame.origin.y
        let last_height: CGFloat = lblArticle13Desc2.frame.size.height
        
        let contentSize = last_origin_y + last_height
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, contentSize + 40)
    }
    
    override func  preferredStatusBarStyle()-> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func backToMenu(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goToRegist(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewControllerWithIdentifier("RegistController") as! RegistController
            
        self.presentViewController(vc, animated: true, completion: nil)
    }
}
