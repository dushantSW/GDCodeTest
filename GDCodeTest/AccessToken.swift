//
// Created by dushantsw on 2017-05-13.
// Copyright (c) 2017 dushantsw. All rights reserved.
//

import Foundation


/// Error enum defining all the errors that access token
/// can produce
///
/// - tokenIsEmpty: If the sent token is empty
/// - tokenIsTooShort: If the sent token size is lower than min.
/// - expiryDateNotInFuture: If the expires_in date is less than or eq to 0
/// - invalidJSON: If the provided json is in invalid format.
enum AccessTokenError : Error {
    case tokenIsEmpty
    case tokenIsTooShort
    case expiryDateNotInFuture
    case invalidJSON
}


/// AccessToken is an data transfer object describing an authentication toen
class AccessToken {
    private struct JSONFieldKey {
        static let token = "access_token"
        static let expiresIn = "expires_in"
    }
    
    public private(set) var token: String
    public private(set) var expires: Date
    
    
    /// Creates a new instance of Accesstoken. Method is accessible private only
    ///
    /// - Parameters:
    ///   - token: authentication token
    ///   - expires: time in seconds when token expires
    private init(token: String, expires: Int) {
        self.token = token
        
        let startDate = Date()
        let calendar = Calendar.current;
        let expiryDate = calendar.date(byAdding: .minute, value: expires, to: startDate)
        self.expires = expiryDate!
    }
    
    
    /// Creates an new instance of AccessToken if parameters passes validation
    ///
    /// - Parameters:
    ///   - token: The access-token
    ///   - expires: Time in seconds when token expires
    /// - Returns: a new instance of AccessToken
    /// - Throws: AccessTokenError
    public static func ofValues(token: String, expires: Int) throws -> AccessToken {
        if token.isEmpty {
            throw AccessTokenError.tokenIsEmpty
        }
        
        if token.characters.count < 25 {
            throw AccessTokenError.tokenIsTooShort
        }
        
        if expires <= 0 {
            throw AccessTokenError.expiryDateNotInFuture
        }
        
        return AccessToken.init(token: token, expires: expires)
    }
    
    /// Creates a new instance from JSON
    ///
    /// - Parameter json: NSDictionary
    /// - Returns: AccessToken
    /// - Throws: AccessTokenError
    public static func ofJSON(json: NSDictionary) throws -> AccessToken {
        let token = json[JSONFieldKey.token] as! String
        let expires = json[JSONFieldKey.expiresIn] as! Int
        
        return try AccessToken.ofValues(token: token, expires: expires)
    }
    
    /// Converts self into NSDictionary which is json ready.
    ///
    /// - Returns: NSDictionary
    func toDictinary() -> NSDictionary {
        let components = Calendar.current.dateComponents([.second], from: Date(), to: self.expires)
        
        return NSDictionary.init(
            objects: [self.token, components.second ?? 0],
            forKeys: [JSONFieldKey.token as NSCopying, JSONFieldKey.expiresIn as NSCopying])
    }
}
