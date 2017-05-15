//
//  LocalStorageTest.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-15.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import XCTest
@testable import GDCodeTest

class LocalStorageTest: XCTestCase {
    private var accessToken: AccessToken?
    
    override func setUp() {
        super.setUp()
        
        do {
            accessToken = try AccessToken.ofValues(
                token: "tHzU5jsrJcKdWmZabc2BLfC0TGxuAb0DtcmFpctHtUxVliLM65Ca2qW1Lu3jyzZ00AOtS_qgS9QtsL1hsLOObg7iuBlpAPza",
                expires: 24*60*60)
        } catch {
            print("error occured local storage test")
        }
    }
    
    func test_storingAccessToken() {
        LocalStorage.sharedStorage.storeAccessToken(token: accessToken!)
        do {
            let retrievedToken = try LocalStorage.sharedStorage.getAccessToken()
            XCTAssertEqual(retrievedToken?.token, accessToken?.token)
            
            // There will be a difference of few ms
            let order = retrievedToken?.expires.compare((accessToken?.expires)!)
            XCTAssertTrue(order == ComparisonResult.orderedDescending)
        } catch {
            XCTFail()
        }
    }
}
