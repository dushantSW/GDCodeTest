//
//  Username.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-13.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation


/// Enum UsernameError, defining all the errors that Username throws
///
/// - emptyUsername: if the username is empty
enum UsernameError : Error {
    case emptyUsername
}


/// Username, a dto defining the model of Username
public class Username {
    public private(set) var name: String
    
    
    /// Creates a new instance of Username, private access only
    ///
    /// - Parameter name: username
    private init(name: String) {
        self.name = name
    }

    
    /// Creates a new instance if given username passes validation
    ///
    /// - Parameter name: username
    /// - Returns: Username
    /// - Throws: UsernameError
    static func ofName(name: String) throws -> Username {
        guard !name.isEmpty else {
            throw UsernameError.emptyUsername
        }

        return Username.init(name: name)
    }
}
