//
//  LocalStorage.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-15.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation

public class LocalStorage {
    private struct Keys {
        static let accessToken = "access-token-dictionary"
    }
    
    private let userDefaults: UserDefaults
    static let sharedStorage = LocalStorage()
    private init() {
        self.userDefaults = UserDefaults.standard
    }
    
    
    /// Converts the given token into dicitionary and stores it.
    ///
    /// - Parameter token: AccessToken
    func storeAccessToken(token: AccessToken) {
        let jsonToken = token.toDictinary()
        self.userDefaults.set(jsonToken, forKey: Keys.accessToken)
    }
    
    
    /// Retrieves the stored access token if exists
    ///
    /// - Returns: AccessToken or nil
    /// - Throws: AccessTokenError
    func getAccessToken() throws -> AccessToken? {
        let json = self.userDefaults.dictionary(forKey: Keys.accessToken)
        if json == nil {
            return nil
        }
        
        return try AccessToken.ofJSON(json: json! as NSDictionary)
    }
}
