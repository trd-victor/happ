//
//  Extensions.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/09.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

let profileImgCache = NSCache()
let imgCache = NSCache()

extension UIImageView {

    func profileForCache(urlString: String) {
        let url = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        if let imgCache = profileImgCache.objectForKey(url) as? UIImage {
            self.image = imgCache
            return
        }
        
        let data = NSData(contentsOfURL: NSURL(string: "\(url)")!)
        
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            
            if data == nil {
                self.image = UIImage(named: "noPhoto")
                return
            } else {
                if let downloadImage = UIImage(data: data!) {
                    profileImgCache.setObject(downloadImage, forKey: url)
                    self.image = downloadImage
                    return
                }
            }
        })
    }
    
    func imgForCache(urlString: String) {
        let url = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        if let img = imgCache.objectForKey(url) as? UIImage {
            self.image = img
            return
        }
        
        let data = NSData(contentsOfURL: NSURL(string: "\(url)")!)
        
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            
            if data == nil {
                self.image = nil
                return
            } else {
                if let downloadImage = UIImage(data: data!) {
                    imgCache.setObject(downloadImage, forKey: url)
                    self.image = downloadImage
                    return
                }
            }
        })
    }
    
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
       let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .WhiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        dispatch_async(dispatch_get_main_queue()) {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
          }
  

    class func removeSpinner(spinner :UIView) {
        dispatch_async(dispatch_get_main_queue()) {
            spinner.removeFromSuperview()
        }
    }
    
//    class func  addBanner(onView: UIView) -> UIView{
//        let bannerView = UIView.init(frame: CGRect(x: 0.0, y: 2, width: onView.frame.width, height: 48))
//        bannerView.backgroundColor = UIColor.blackColor()
//        
//        dispatch_async(dispatch_get_main_queue()) {
//            onView.addSubview(bannerView)
//        }
//        
//        return bannerView
//    }
}

extension UITextField {
    func setLeftPaddingPoints(amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .Always
    }
    func setRightPaddingPoints(amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .Always
    }
}
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override public var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.hidden = self.text.characters.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    func addPlaceholder(placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGrayColor()
        placeholderLabel.tag = 100
        
        placeholderLabel.hidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

extension String {
    func convertHtmlSymbols() throws -> String? {
        guard let data = dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
        
        return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil).string
    }
}
