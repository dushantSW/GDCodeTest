//
//  AuthenticationHandler.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-14.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import Foundation
import Alamofire

class AuthenticationHandler: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: AccessToken?) -> Void
    
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(configuration: configuration)
    }()
    
    private let lock = NSLock()
    
    private var username: Username
    private var password: Password
    private var accessToken: AccessToken
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(username: Username, password: Password, accessToken: AccessToken) {
        self.username = username
        self.password = password
        self.accessToken = accessToken
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if urlRequest.url?.absoluteString != Constants.OAUTH_URL {
            var urlRequest = urlRequest
            urlRequest.setValue("Bearer " + accessToken.token, forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens(completion: { [weak self] succeeded, _accessToken in
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if let accessToken = _accessToken {
                        strongSelf.accessToken = accessToken
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                })
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        let parameters: [String: Any] = [
            "grant_type": "password",
            "password": password.value,
            "username": username.name
        ]
        
        sessionManager.request(Constants.OAUTH_URL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .responseJSON { [weak self] response in
                guard let strongSelf = self else { return }
                
                if
                    let json = response.result.value as? [String: Any],
                    let token = json["access_token"] as? String,
                    let expires = json["expires_in"] as? Int
                {
                    do {
                        let at = try AccessToken.ofValues(token: token, expires: expires)
                        completion(true, at)
                    } catch {
                        completion(false, nil)
                    }
                } else {
                    completion(false, nil)
                }
                
                strongSelf.isRefreshing = false
        }
    }
}
