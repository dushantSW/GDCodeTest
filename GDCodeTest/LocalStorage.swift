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
    
    /// Retreives the tokens from the local storage if exists.
    ///
    /// - Returns: AccessToken if exists
    func getAccessToken() throws -> AccessToken? {
        let jsonToken = self.userDefaults.dictionary(forKey: Keys.accessToken)
        if jsonToken == nil {
            return nil
        }
        
        return try AccessToken.ofJSON(json: jsonToken! as NSDictionary)
    }
}
