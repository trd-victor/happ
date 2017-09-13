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
