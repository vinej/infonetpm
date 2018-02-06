//
//  OAuth2RetryHandler.swift
//  OAuth2PodApp
//
//  Created by Pascal Pfiffner on 15.09.16.
//  Copyright © 2016 Ossus. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

public let AUTH_URL = "http://192.168.242.1:80/auth/login"

class OAuth2RetryHandler: RequestRetrier, RequestAdapter {

    fileprivate var alamofireManager: SessionManager?
    var accessToken : String = "EMPTY_TOKEN"
    var email = "joe@gmail.com"
    var password = "123456"
    
    func setManager(_ manager : SessionManager?) {
        alamofireManager = manager
    }
    
    /// Intercept 401
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        let parameters = [
            "email": email,
            "password": password
        ]
    
        //let headers = [
        //    "content_type" : "application/json"
        //]
        //guard let refreshToken = keychain["refresh_token"] else {
        //    print("refresh token is nil!")
        //    return completion(false, 0.0)
        //}
        print("token has expired, request new token!")
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            Alamofire.request(AUTH_URL,
                    method: HTTPMethod.post,
                    parameters: parameters,
                    encoding: JSONEncoding.default).responseJSON { response in
                let swiftyJsonVar = JSON(response.result.value!)
                
                if let auth_token = swiftyJsonVar["auth_token"].string {
                    self.accessToken = auth_token
                    completion(true, 0.0)
                } else {
                    completion(false, 0.0)
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    /// Sign the request with the access token.
    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        //guard let accessToken = self.accessToken else {
        //    print("access token is nil!")
        //    return urlRequest
        //}
        var urlRequest = urlRequest
        print("acces token to be used: \(accessToken)\n")
        urlRequest.setValue("bearer " + accessToken, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

