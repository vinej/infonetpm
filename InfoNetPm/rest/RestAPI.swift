//
//  RestAPI.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2018-01-22.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

/*************/
//HTTP Verb    CRUD    Entire Collection (e.g. /customers)    Specific Item (e.g. /customers/{id})
//POST    Create    201 (Created), 'Location' header with link to /customers/{id} containing new ID.    404 (Not Found), 409 /(Conflict) if resource already exists..
//GET    Read    200 (OK), list of customers. Use pagination, sorting and filtering to navigate big lists.    200 (OK), single customer. 404 (Not Found), if ID not found or invalid.
//PUT    Update/Replace    405 (Method Not Allowed), unless you want to update/replace every resource in the entire collection.    200 (OK) or 204 (No Content). 404 (Not Found), if ID not found or invalid.
//PATCH    Update/Modify    405 (Method Not Allowed), unless you want to modify the collection itself.    200 (OK) or 204 (No Content). 404 (Not Found), if ID not found or invalid.
//DELETE    Delete    405 (Method Not Allowed), unless you want to delete the whole collection—not often desirable.    200 (OK). 404 (Not Found), if ID not found or invalid.


//Alamofire.request("https://httpbin.org/xxx") // method defaults to `.get`
//Alamofire.request("https://httpbin.org/xxx", method: .post)
//Alamofire.request("https://httpbin.org/xxx", method: .put)
//Alamofire.request("https://httpbin.org/xxx", method: .delete)

//print("Request: \(String(describing: response.request))")   // original url request
//print("Response: \(String(describing: response.response))") // http url response
//print("Result: \(response.result)")                         // response serialization result

//if let json = response.result.value {
//print("JSON: \(json)") // serialized json response
//}

//if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//    print("Data: \(utf8Text)") // original server data as UTF8 string
//}

//Alamofire.request("http://\(ipAddr)/YamahaRemoteControl/ctrl", method: .post, parameters: [:], encoding: .custom({ (convertible, params) in var mutableRequest = convertible.urlRequest as URLRequest mutableRequest.httpBody = "<YAMAHA_AV cmd=\"PUT\"><Main_Zone><Input><Input_Sel>\(input)</Input_Sel></Input></Main_Zone></YAMAHA_AV>".data(using: String.Encoding.utf8, allowLossyConversion: false) return (mutableRequest, nil) } ))

public let API_URL = "https://127.0.0.1:5000/"

public class RestAPI {

    public static func paramsFromJSON(jsonData: NSData) -> [String : AnyObject]?
    {
        do {
            return try JSONSerialization.jsonObject(with: jsonData as Data, options: .mutableContainers) as? [ String : AnyObject]
        } catch {
            print("JSON serialization failed:  \(error)")
            return nil
        }
    }
    
    public static func SyncBaseRec(_ baseRec : BaseRec, _ objectName: String) {
        
        if (baseRec.isNew) {
            
            
        } else if (baseRec.isDeleted) {
            // DELETE
            // delete the record
        } else {
            // PUT
            // update the record
        }
    }
    
    public static func Get<T>(_ object : T.Type) -> Results<Object>? {
        return nil
    }
    
    public static func Delete(_ baseRec : BaseRec, _ objectName: String) {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(baseRec)
            let parameters: Parameters = paramsFromJSON(jsonData: jsonData as NSData)!
            Alamofire.request("\(API_URL)/\(objectName)", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { response in
                //
            }
        } catch {
                //
        }
    }

    public static func Put(_ baseRec : BaseRec, _ objectName: String)  {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(baseRec)
            let parameters: Parameters = paramsFromJSON(jsonData: jsonData as NSData)!
            Alamofire.request("\(API_URL)/\(objectName)", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { response in
                //
            }
        } catch {
                //
        }
    }

    public static func Post(_ baseRec : BaseRec, _ objectName: String)  {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(baseRec)
            let parameters: Parameters = paramsFromJSON(jsonData: jsonData as NSData)!
            Alamofire.request("\(API_URL)/\(objectName)", method: .post, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { response in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                
                if let json = response.result.value {
                    print("JSON: \(json)") // serialized json response
                }
                
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)") // original server data as UTF8 string
                }
            }
        } catch {
            //
        }

    }

    public static func SyncObject<T>(_ object : T.Type) {
        
        // (1) get the modification from the server
        // for each record
        // (2) if record does not exist on the mobile device
        //      add it on mobile
        //      isSync = true
        // (3) if record exist on mobile and is dirty (isSync == false) and updatedDateFromServer are different
        //      merge both records
        //      update server with the result
        //      update the mobile device with the result
        //      send a email to the manager for a conflit resolution
        //      isSync = true
        // (4) if record exist on mobile and is dirty (isSync == false) and updatedDateFromServer are equal
        //      // do nothing. The record will be treated on step 6
        // (5) if record exist on mobile and isSync = true and updatedDate are different
        //      update mobile with the server version
        //      isSync = true
        // (6) update server with mobile modifications : get dirty records (isSync = false)
        //      set updateDateOnServer = updateDate
        //      set updateByOnServer = updateBy
        //      if isNew == true  do a POST verb
        //      if isDeleted == true, do a DELETED verb
        //      else, do a PUT VERB
        //
        //
        //et list = DB.filter(Company.self, "isSync = %@", false)
        //for obj in list {
        //    SyncBaseRec(obj as! BaseRec)
        //}
    }

    public static func Sync() {
        SyncObject(Activity.self)
        SyncObject(Document.self)
        SyncObject(Role.self)
        SyncObject(Comment.self)
        SyncObject(Company.self)
        SyncObject(Issue.self)
        SyncObject(Plan.self)
        SyncObject(Project.self)
        SyncObject(Resource.self)
        SyncObject(Task.self)
        SyncObject(Audit.self)
        SyncObject(Order.self)
        SyncObject(ActivityHistory.self)
        SyncObject(Status.self)
    }
}
