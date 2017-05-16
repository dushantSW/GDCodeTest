//
//  ViewUtils.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-16.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation
import UIKit

class ViewUtils {
    
    public static func showErrorAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
}
