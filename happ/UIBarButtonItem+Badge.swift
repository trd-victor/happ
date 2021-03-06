//
//  UIBarButtonItem+Badge.swift
//  happ
//
//  Created by TokikawaTeppei on 25/09/2017.
//  Copyright © 2017 H-FUKUOKA. All rights reserved.
//

import UIKit

extension CAShapeLayer {
    private func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.CGColor : UIColor.whiteColor().CGColor
        strokeColor = color.CGColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalInRect: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).CGPath
    }
}

private var handle: UInt8 = 0;

extension UIBarButtonItem {
    
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.redColor(), andFilled filled: Bool = true) {
        guard let view = self.valueForKey("view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        let txtwidth = CGFloat(26)
        
        // Initialize Badge
        let badge = CAShapeLayer()
        badge.lineWidth = 15
        let radius = CGFloat(5)
        
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = kCAAlignmentCenter
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - 13.5, y: offset.y - 2), size: CGSize(width: txtwidth, height: txtwidth))
        label.foregroundColor = filled ? UIColor.whiteColor().CGColor : color.CGColor
        label.contentsScale = UIScreen.mainScreen().scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(16)], context: nil)
    }
    
}