//
//  ApiServiceTest.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-13.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import XCTest
@testable import GDCodeTest

class ApiServiceTest: XCTestCase {
    private let token = "tHzU5jsrJcKdWmZabc2BLfC0TGxuAb0DtcmFpctHtUxVliLM65Ca2qW1Lu3jyzZ00AOtS_qgS9QtsL1hsLOObg7iuBlpAPzaDgDo2Xof2ZGq0p_wAQSjthXx3DDsOpBj3ufGQuNBgwYDFVU3XtD0UCi2G5PLQbJy-UyervGsj4afTprwEhEDDV0DnWBFQ_GvuWZa2R1v5ulf0X4AQ9-3XeT8KHS_aAfS5ZBg-9sK-wLgbrpjLT4PdOWAkqysjsOIsIJUA6iAtgGrrwUEkp_BexXBjpSMoLxBAbEFU37f2JCFkdluWTyQrhDyoGEU1xTzr6TIQ_BPVVpQwf6YLw4HIgIiTKzQ0H4LtMci66TqvIdJg1S3c5c7EsrRDP5phNAu0XEkDes4oBovNybFptTmh1lPdrj-Dsh938hVtW48C5WQRQ_Tc0SlIKzfPFXis-N9SnRKUmflYXWnkkjJ8aW696F3sRHCoI4OYgZidtI60lmV5Dmi_D4vQMrx1qW-P4P7qBIEoZAQ0KnGeV0czCylf0YA"
    
    private var username: Username?
    private var password: Password?
    private var location: Location?
    private var searchRequest: SearchRequest?
    
    override func setUp() {
        super.setUp()
        
        do {
            username = try Username.ofName(name: "oojamaflip2008")
            password = try Password.ofValue(value: "TestPassword123!")
            location = try Location.ofLocation(latitude: 51.4775288, longitude: -0.3778464)
            
            self.searchRequest = SearchRequest.init()
            try searchRequest?.setMinAge(age: 18)
            try searchRequest?.setMinAge(age: 55)
            searchRequest?.location = location
            
            let accessToken = try AccessToken.ofValues(token: token, expires: 24 * 60 * 60)
            let authHandler = AuthenticationHandler.init(username: username!, password: password!, accessToken: accessToken)
            
            ApiService.sharedService.session.adapter = authHandler
            ApiService.sharedService.session.retrier = authHandler
        } catch {
            print("Error occured while creating username & password")
        }
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // In order to run this test turn wifi-off on your macbook.
    func test_authenicationDeviceNotConnected() {
        ApiService.sharedService.authenticate(username: username!, password: password!, success: { (token, jsonObject) in
            XCTFail()
        }) { (code, response, error) in
            XCTAssertEqual(code, 503)
        }
    }
    
    func test_authenticationSuccess() {
        let except = expectation(description: "Expectating to authenticate")
        ApiService.sharedService.authenticate(username: username!, password: password!, success: { (token, json) in
            XCTAssertNotNil(token)
            XCTAssertNotNil(json)
            XCTAssertNotNil((token as! AccessToken).token)
            except.fulfill()
        }) { (code, response, json) in
            XCTFail()
            except.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    /// Performs two tests simultaneously, refreshing access token in-case of 401
    /// and retrieving profiles
    func test_retrieveProfilesAfter401() {
        let except = expectation(description: "Download profiles")
        
        ApiService.sharedService.getProfiles(searchRequest: searchRequest!, success: { (profiles, json) in
            XCTAssertTrue(profiles is NSArray)
            
            if let profilesArray = profiles as? [Profile] {
                XCTAssertEqual(profilesArray.count, self.searchRequest?.pageSize)
            }
            
            except.fulfill()
        }) { (statusCode, response, error) in
            XCTFail()
            except.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
