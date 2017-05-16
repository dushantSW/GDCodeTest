//
//  ModelsTest.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-14.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import XCTest

class ModelsTest: XCTestCase {
    private let token = "tHzU5jsrJcKdWmZabc2BLfC0TGxuAb0DtcmFpctHtUxVliLM65Ca2qW1Lu3jyzZ00AOtS_qgS9QtsL1hsLOObg7iuBlpAPzaDgDo2Xof2ZGq0p_wAQSjthXx3DDsOpBj3ufGQuNBgwYDFVU3XtD0UCi2G5PLQbJy-UyervGsj4afTprwEhEDDV0DnWBFQ_GvuWZa2R1v5ulf0X4AQ9-3XeT8KHS_aAfS5ZBg-9sK-wLgbrpjLT4PdOWAkqysjsOIsIJUA6iAtgGrrwUEkp_BexXBjpSMoLxBAbEFU37f2JCFkdluWTyQrhDyoGEU1xTzr6TIQ_BPVVpQwf6YLw4HIgIiTKzQ0H4LtMci66TqvIdJg1S3c5c7EsrRDP5phNAu0XEkDes4oBovNybFptTmh1lPdrj-Dsh938hVtW48C5WQRQ_Tc0SlIKzfPFXis-N9SnRKUmflYXWnkkjJ8aW696F3sRHCoI4OYgZidtI60lmV5Dmi_D4vQMrx1qW-P4P7qBIEoZAQ0KnGeV0czCylf0YA"
    
    func test_invalidTokenAccessToken() {
        XCTAssertThrowsError(try AccessToken.ofValues(token: "", expires: 0)) { (error) in
            XCTAssertEqual(error as? AccessTokenError, AccessTokenError.tokenIsEmpty)
        }
    }
    
    func test_tooShortTokenAccessToken() {
        XCTAssertThrowsError(try AccessToken.ofValues(token: "asdoandoiandosia", expires: 0)) { (error) in
            XCTAssertEqual(error as? AccessTokenError, AccessTokenError.tokenIsTooShort)
        }
    }
    
    func test_noexpiryDateAccessToken() {
        XCTAssertThrowsError(try AccessToken.ofValues(token: token, expires: 0)) { (error) in
            XCTAssertEqual(error as? AccessTokenError, AccessTokenError.expiryDateNotInFuture)
        }
    }
    
    func test_successJSONAccessToken() {
        let expires_in = 24 * 60 * 60
        let json = NSDictionary.init(objects: [token, expires_in], forKeys: ["access_token" as NSCopying, "expires_in" as NSCopying])
        
        let startDate = Date()
        let calendar = Calendar.current;
        let expiryDate = calendar.date(byAdding: .minute, value: expires_in, to: startDate)
        
        do {
            let accessToken = try AccessToken.ofJSON(json: json)
            XCTAssertEqual(accessToken.token, token)
            
            // There will be a difference of few ms
            let order = accessToken.expires.compare(expiryDate!)
            XCTAssertTrue(order == ComparisonResult.orderedDescending)
        } catch {
            XCTFail()
        }
    }
    
    func test_successAccessToken() {
        let expires_in = 24 * 60 * 60
        
        let startDate = Date()
        let calendar = Calendar.current;
        let expiryDate = calendar.date(byAdding: .minute, value: expires_in, to: startDate)
        
        do {
            let accessToken = try AccessToken.ofValues(token: token, expires: expires_in)
            XCTAssertEqual(accessToken.token, token)
            
            // There will be a difference of few ms
            let order = accessToken.expires.compare(expiryDate!)
            XCTAssertTrue(order == ComparisonResult.orderedDescending)
        } catch {
            XCTFail()
        }
    }
    
    func test_invalidUsername() {
        XCTAssertThrowsError(try Username.ofName(name: "")) { (error) in
            XCTAssertEqual(error as? UsernameError, UsernameError.emptyUsername)
        }
    }
    
    func test_usernameSuccess() {
        do {
            let username = try Username.ofName(name: "dushant")
            XCTAssertEqual(username.name, "dushant")
        } catch {
            XCTFail()
        }
    }
    
    func test_invalidPassword() {
        XCTAssertThrowsError(try Password.ofValue(value: "")) { (error) in
            XCTAssertEqual(error as? PasswordError, PasswordError.emptyPassword)
        }
    }
    
    func test_passwordSuccess() {
        do {
            let password = try Password.ofValue(value: "dushant123")
            XCTAssertEqual(password.value, "dushant123")
        } catch {
            XCTFail()
        }
    }
    
    func test_zeroLatLocation() {
        XCTAssertThrowsError(try Location.ofLocation(latitude: Double.nan, longitude: Double.nan)) { (error) in
            XCTAssertEqual(error as? LocationError, LocationError.latIsEmpty)
        }
    }
    
    func test_zeroLongLocation() {
        XCTAssertThrowsError(try Location.ofLocation(latitude: 13.23, longitude: Double.nan)) { (error) in
            XCTAssertEqual(error as? LocationError, LocationError.longIsEmpty)
        }
    }
    
    func test_successLocation() {
        do {
            let location = try Location.ofLocation(latitude: 15.234, longitude: 17.123)
            XCTAssertEqual(location.longitude, 17.123)
            XCTAssertEqual(location.latitude, 15.234)
        } catch {
            XCTFail()
        }
    }
}
