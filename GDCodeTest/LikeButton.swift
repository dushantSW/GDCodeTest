//
//  LikeButton.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-16.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation
import UIKit

/// LikeButton extended UIButton with custom style for like button.
public class LikeButton : UIButton {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.adjustsImageWhenDisabled = false
        self.layer.cornerRadius = (self.frame.size.height / 2)
        self.layer.borderWidth = 6.0
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
    }
}
