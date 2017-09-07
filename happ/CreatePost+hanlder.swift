//
//  CreatePost+hanlder.swift
//  happ
//
//  Created by TimeRiverDesign on 2017/09/04.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit
import DKImagePickerController

struct imageContent {
    var imageCount = [String]()
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handlerGallery() {
        let picker = DKImagePickerController()
        
        switch(imgList.count){
        case 1:
            picker.maxSelectableCount = 2
            break
        case 2:
            picker.maxSelectableCount = 1
            break
        case 3:
            picker.maxSelectableCount = 0
            break
        default:
            picker.maxSelectableCount = 3
            break
        }
        
        picker.sourceType = .Photo
        picker.didSelectAssets = { (assets: [DKAsset]) in
            for each in assets {
                self.imgList.append(each.fullResolutionImage!)
            }
            self.loadTimelineImagePost()
        }
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func handlerCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .Camera
            picker.cameraCaptureMode = .Photo
            picker.allowsEditing = false
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker, animated: true, completion: nil)
        }else{
            print("No Camera")
        }
    }
}

