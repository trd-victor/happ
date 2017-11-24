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
        
        if let imgCache = globalvar.imgforProfileCache.objectForKey(url) as? UIImage {
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
                    globalvar.imgforProfileCache.setObject(downloadImage, forKey: url)
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
    
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: font],
            context: nil).size
    }
    
    public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 200 {
            let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
            var textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset))
            textWidth -= 2.0 * textView.textContainer.lineFragmentPadding;
            
            let boundingRect = sizeOfString(newText, constrainedToWidth: Double(textWidth), font: textView.font!)
            let numberOfLines = boundingRect.height / textView.font!.lineHeight;
            
            return numberOfLines <= 7;
        }else{
            return true;
        }
    }
}

private let characterEntities : [ String : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]


extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(string : String, base : Int32) -> Character? {
            let code = UInt32(strtoul(string, nil, base))
            return Character(UnicodeScalar(code))
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(entity : String) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X"){
                return decodeNumeric(entity.substringFromIndex(entity.startIndex.advancedBy(3)), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.substringFromIndex(entity.startIndex.advancedBy(2)), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self.rangeOfString("&", range: position ..< endIndex) {
            result.appendContentsOf(self[position ..< ampRange.startIndex])
            position = ampRange.startIndex
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            if let semiRange = self.rangeOfString(";", range: position ..< endIndex) {
                let entity = self[position ..< semiRange.endIndex]
                position = semiRange.endIndex
                
                if let decoded = decode(entity) {
                    // Replace by decoded character:
                    result.append(decoded)
                } else {
                    // Invalid entity, copy verbatim:
                    result.appendContentsOf(entity)
                }
            } else {
                // No matching ';'.
                break
            }
        }
        // Copy remaining characters to `result`:
        result.appendContentsOf(self[position ..< endIndex])
        return result
    }
}
