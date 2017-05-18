//
//  ViewUtils.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-16.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation
import UIKit


/// ViewUtils, an utility class which implements common functions
/// used throught the application
class ViewUtils {
    
    
    /// Creates an UIAlertController with the given title and message
    ///
    /// - Parameters:
    ///   - title: key to localized title
    ///   - message: key to localized message
    /// - Returns: UIAlertController for presenting
    public static func showErrorAlert(title: String, message: String) -> UIAlertController {
        let localizedTitle = NSLocalizedString(title, comment: "")
        let localizedMessage = NSLocalizedString(message, comment: "")
        let alert = UIAlertController(title: localizedTitle,
                                      message: localizedMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
}
