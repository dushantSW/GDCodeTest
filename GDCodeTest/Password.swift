//
// Created by dushantsw on 2017-05-13.
// Copyright (c) 2017 dushantsw. All rights reserved.
//

import Foundation


/// Enum PasswordError, defining type of errors that Password throws
///
/// - emptyPassword: if the password is empty
enum PasswordError : Error {
    case emptyPassword
}


/// Password, an DTO defining model of password
public class Password {
    public private(set) var value: String
    
    
    /// Creates a new instance. Private access only
    ///
    /// - Parameter value: password
    private init(value: String) {
        self.value = value
    }

    
    /// Creates a new instance statically from the given value, if values passes validation
    ///
    /// - Parameter value: password
    /// - Returns: Password
    /// - Throws: PasswordError
    public static func ofValue(value: String) throws -> Password {
        guard !value.isEmpty else {
            throw PasswordError.emptyPassword
        }

        return Password.init(value: value)
    }
}
