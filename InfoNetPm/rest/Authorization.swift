//
//  OAuth2RetryHandler.swift
//  OAuth2PodApp
//
//  Created by Pascal Pfiffner on 15.09.16.
//  Copyright © 2016 Ossus. All rights reserved.
//
import Foundation
import Alamofire

class OAuth2RetryHandler: RequestRetrier, RequestAdapter {

    fileprivate var alamofireManager: SessionManager?
    var token : String = ""
    var email = "jyvinet@hotmail.ca"
    var password = "test"
    
    func setManager(_ manager : SessionManager?) {
        alamofireManager = manager
    }
    
    /// Intercept 401
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, 401 == response.statusCode, let req = request.request {
            // get new token
            // continue with current request
        }
        else {
            completion(false, 0.0)   // not a 401, not our problem
        }
    }
    
    /// Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        // add Bearer:token
        var urlRequest = urlRequest
        
        urlRequest.setValue("v1", forHTTPHeaderField: "X-IPM-Key")
        urlRequest.setValue(self.token, forHTTPHeaderField: "Bearer")
        
        return urlRequest
    }
}

