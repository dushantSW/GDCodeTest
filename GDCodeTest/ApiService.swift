//
//  ApiService.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-13.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation
import Alamofire


/**
 *  Block handler for successfull network calls
 *
 *  @param response           The parse response from the received data
 *  @param responseJSONObject The un-parse received response.
 */
public typealias HttpSuccessHandler = (_ response: Any?, _ responseJSONObject: Any?) -> Void

/**
 *  Block handler for failed network calls
 *
 *  @param operation NSURLSessionTask and error information
 *  @param error     NSError containing complete error information
 */
public typealias HttpFailureHandler = (_ statusCode: Int, _ responseObject: Any?, _ error: NSError?) -> Void

private struct ParametersKey {
    static let grantType = "grant_type"
    static let username = "username"
    static let password = "password"
    static let minAge = "minAge"
    static let maxAge = "maxAge"
    static let latitude = "lat"
    static let long = "lon"
    static let pageSize = "pageSize"
    static let rowOffset = "rowOffset"
}

private struct Headers {
    static let contentType = "Content-Type"
    static let formEncoded = "application/x-www-form-urlencoded"
}

public class ApiService {
    static let sharedService = ApiService()
    public private(set) var session: SessionManager
    private init() {
        session = SessionManager()
    }
    
    /// Authenticates the user with given username and password
    ///
    /// - Parameters:
    ///   - username: Valid {Username} of the user
    ///   - password: Valid Password of the user
    ///   - success: Success block which is called upon successfull authentication
    ///   - failure: Failure block called on either response failure, device connection failure or serialization failure.
    func authenticate(username: Username, password: Password,
                      success: @escaping HttpSuccessHandler,
                      failure: @escaping HttpFailureHandler) -> Void {
        if !isDeviceConnectedToInternet() {
            failure(503, nil, nil)
            return
        }
        
        let headers = [
            Headers.contentType: Headers.formEncoded
        ]
        
        let parameters: Parameters = [
            ParametersKey.grantType: "password",
            ParametersKey.username: username.name,
            ParametersKey.password: password.value
        ];
        
        Alamofire.request(Constants.OAUTH_URL, method: .post, parameters: parameters, headers: headers).responseJSON { [weak self] response in
            guard let strongSelf = self else { return }
            
            switch response.result {
            case .success:
                let json = response.result.value as? NSDictionary
                if json != nil {
                    do {
                        let token = try AccessToken.ofJSON(json: json!)
                        let authHandler = AuthenticationHandler.init(username: username, password: password, accessToken: token)
                        strongSelf.session.adapter = authHandler
                        strongSelf.session.retrier = authHandler
                        
                        success(token, json)
                    } catch {
                        failure(422, nil, nil)
                    }
                } else {
                    failure(422, nil, nil)
                }
            case .failure:
                failure((response.response?.statusCode)!, response, response.result.error! as NSError)
            }
        }
    }
    
    public func getProfiles(searchRequest: SearchRequest,
                            success: @escaping HttpSuccessHandler,
                            failure: @escaping HttpFailureHandler) {
        if !isDeviceConnectedToInternet() {
            failure(503, nil, nil)
            return
        }
        
        let parameters: Parameters = [
            ParametersKey.maxAge: searchRequest.maxAge!,
            ParametersKey.minAge: searchRequest.minAge!,
            ParametersKey.latitude: searchRequest.location?.latitude as Any,
            ParametersKey.long: searchRequest.location?.longitude as Any,
            ParametersKey.pageSize: searchRequest.pageSize,
            ParametersKey.rowOffset: searchRequest.currentRow
        ]

        session.request(Constants.PROFILE_URL, method: .get, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .success:
                let json = response.result.value as? NSDictionary
                let profiles: NSMutableArray = NSMutableArray.init();
                
                if (json != nil) {
                    let jsonProfiles = json?["Profiles"] as! NSArray
                    
                    for jsonProfile in jsonProfiles {
                        let profile = Profile.init(json: jsonProfile as? NSDictionary)
                        profiles.add(profile)
                    }
                    
                    success(profiles, json)
                    break
                }
            case .failure(let error):
                failure((response.response?.statusCode)!, response.response, error as NSError)
            }
        }
    }

    private func isDeviceConnectedToInternet() -> Bool {
        return Alamofire.NetworkReachabilityManager.init()!.isReachable;
    }
    
    private func errorForMultipleTrialsForUrl(url: String) -> NSError {
        let errorDetail = NSDictionary();
        errorDetail.setValue("Has tried 3 times to retrieve url: \(url)", forKey: NSLocalizedDescriptionKey)
        return NSError.init(domain: "authorization", code: 404, userInfo: errorDetail as? [AnyHashable : Any])
    }
}
