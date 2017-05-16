//
//  ProfileImageView.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-16.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

public class ProfileImageView : UIImageView {
    public func loadImageWithMediaId(mediaId: String) {
        let absURL = Constants.mediaAbsURLWithMediaId(mediaId: mediaId)
        self.sd_setImage(with: URL(string: absURL)) { [weak self] image, error, cacheType, url in
            if error == nil {
                self?.image = image
            }
        }
    }
}

private extension UIImage {
    func filledImage(fillColor: UIColor, alpha: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()!
        fillColor.withAlphaComponent(alpha).setFill()
        
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.setBlendMode(CGBlendMode.colorBurn)
        
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.draw(self.cgImage!, in: rect)
        
        context.setBlendMode(CGBlendMode.sourceIn)
        context.addRect(rect)
        context.drawPath(using: CGPathDrawingMode.fill)
        
        let coloredImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return coloredImg
    }
}
