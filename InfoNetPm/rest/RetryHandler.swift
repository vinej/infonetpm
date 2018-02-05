//
//  RetryHandler.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2018-02-05.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire

class RetryHandler: RequestRetrier, RequestAdapter {
    
    fileprivate var alamofireManager: SessionManager?
    
    init(manager : SessionManager) {
        self.alamofireManager = manager)
    }
    
    /// Intercept 401 and do an OAuth2 authorization.
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse, 401 == response.statusCode, let req = request.request {
            
            let tokenRequest : Request  = Request()
            
            var dataRequest = OAuth2DataRequest(request: req, callback: { _ in })
            
            
            dataRequest.context = completion
            loader.enqueue(request: dataRequest)
            loader.attemptToAuthorize() { authParams, error in
                self.loader.dequeueAndApply() { req in
                    if let comp = req.context as? RequestRetryCompletion {
                        comp(nil != authParams, 0.0)
                    }
                }
            }
        }
        else {
            completion(false, 0.0)   // not a 401, not our problem
        }
    }
    
    /// Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard nil != loader.oauth2.accessToken else {
            // here add others headers info
            return urlRequest
        }
        return try urlRequest.signed(with: loader.oauth2)
    }
}

