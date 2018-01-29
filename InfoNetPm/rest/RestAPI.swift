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
import SwiftyJSON

/*************/
//HTTP Verb    CRUD    Entire Collection (e.g. /customers)    Specific Item (e.g. /customers/{id})
//POST    Create    201 (Created), 'Location' header with link to /customers/{id} containing new ID.    404 (Not Found), 409 /(Conflict) if resource already exists..
//GET    Read    200 (OK), list of customers. Use pagination, sorting and filtering to navigate big lists.    200 (OK), single customer. 404 (Not Found), if ID not found or invalid.
//PUT    Update/Replace    405 (Method Not Allowed), unless you want to update/replace every resource in the entire collection.    200 (OK) or 204 (No Content). 404 (Not Found), if ID not found or invalid.
//PATCH    Update/Modify    405 (Method Not Allowed), unless you want to modify the collection itself.    200 (OK) or 204 (No Content). 404 (Not Found), if ID not found or invalid.
//DELETE    Delete    405 (Method Not Allowed), unless you want to delete the whole collection—not often desirable.    200 (OK). 404 (Not Found), if ID not found or invalid.

//Alamofire.request("\(API_URL)\(objectName)", method: method, parameters: baseRec.encode(), encoding: JSONEncoding.default).responseJSON { response in
//  print("Request: \(String(describing: response.request))")   // original url request
//  print("Response: \(String(describing: response.response))") // http url response
//  print("Result: \(response.result)")                         // response serialization result
//  if let json = response.result.value {
//    print("JSON: \(json)") // serialized json response
//  }
//  if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//    print("Data: \(utf8Text)") // original server data as UTF8 string
//  }
//}

public let API_URL = "http://192.168.242.1:80/"

public class RestAPI {
    
    static var asynlist : [ (Any.Type, String) ] = [
        (Company.self,            BaseRec.objectNameLower(Company.self)),
        (Resource.self,           BaseRec.objectNameLower(Resource.self)),
        (Status.self,             BaseRec.objectNameLower(Status.self)),
        (Order.self,              BaseRec.objectNameLower(Order.self)),
        //syncObject(Document.self,           BaseRec.objectName(Document.self))
        //syncObject(Comment.self,            BaseRec.objectName(Comment.self))
        (Role.self,               BaseRec.objectNameLower(Role.self)),
        (Plan.self,               BaseRec.objectNameLower(Plan.self)),
        (Project.self,            BaseRec.objectNameLower(Project.self)),
        (Activity.self,           BaseRec.objectNameLower(Activity.self)),
        //syncObject(Task.self,               BaseRec.objectName(Task.self))
        //syncObject(Issue.self,              BaseRec.objectNameLower(Issue.self))
        (Audit.self,              BaseRec.objectNameLower(Audit.self)),
        (ActivityHistory.self,    BaseRec.objectNameLower(ActivityHistory.self))
    ]
    
    static var listToSync : Results<Object> = DB.all(Status.self)
    static var currentObjectName = ""
    static var currentNextFunc = doNext
    static var currentNext = 0
    
    public static func syncBaseRec(_ baseRec : BaseRec, _ objectName: String,
                                   _ nextFunc : @escaping (Int) -> (), _ next : Int) {
        if (baseRec.isNew) {  // could be UpdatedDate == CreatedDate
            // add a new record on the server
            api(baseRec, objectName, HTTPMethod.post, nextFunc, next)
        } else if (baseRec.isDeleted) {
            // soft delete a record
            api(baseRec, objectName, HTTPMethod.delete, nextFunc, next)
        } else {
            // update a record
            api(baseRec, objectName, HTTPMethod.put, nextFunc, next)
        }
    }
    
    public static func get<T>(_ objectType : T.Type, _ objectName: String, _ lastUpdated: Date,
                              _ nextFunc : @escaping (Int) -> (), _ next: Int) {
        Alamofire.request("\(API_URL)\(objectName)/\(lastUpdated.str())").responseJSON { response in
            pull(objectType, objectName, JSON(response.result.value!))
            nextFunc(next)
        }
    }
    
    public static func api(_ baseRec : BaseRec, _ objectName: String, _ method : HTTPMethod,
                           _ nextFunc : @escaping (Int) -> (), _ next: Int) {
        let parameters = baseRec.encode()
        
        Alamofire.request("\(API_URL)\(objectName)", method: method, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            //let swiftyJsonVar = JSON(response.result.value!)
            //if let data = swiftyJsonVar["result"].dictionaryObject {
            //    baseRec.decode(data)
            //}
            nextFunc(next)
        }
    }

    public static func asyncPush<T>(_ objectType : T.Type, _ objectName : String,
                                    _ nextFunc : @escaping (Int) -> (), _ next : Int) {
        //-------------
        // Algorithme used to synchronized the mobile device with the server
        // pull latest modification from the server first. Only records with no conflit will be managed by the pull.
        // if there is a conflic, the resolution will be done by the server during the push.
        //-------------
        
        // note: the pull function will be caled by the get function
        //let status = DB.all(Status.self).first as! Status
        //get(objectType, objectName, status.lastSyncDate)
        //
        // push the dirty field to the server
        listToSync = DB.filter(objectType, "isSync = %@", false)
        if (listToSync.count == 0) {
            // next objecy
            nextFunc(next)
            return
        }
        currentObjectName = objectName
        currentNextFunc = nextFunc
        currentNext = next
        syncBaseRec(listToSync[0] as! BaseRec, currentObjectName, nextToPush, 1)
    }
    
    public static func nextToPush( _ next : Int) {
        if (next == listToSync.count) {
            currentNextFunc(currentNext)
            return
        }
        syncBaseRec(listToSync[next] as! BaseRec, currentObjectName, nextToPush, next + 1)
    }

    public static func pull<T>(_ objectType : T.Type, _ objectName : String, _ json: JSON) {
        if (json.count == 0) {
            return
        }
        
        for (_,subJson) : (String, JSON) in json {
            let serverRec = subJson[0]
            let id = serverRec[#keyPath(BaseRec.id)].string
            if let rec = DB.get(objectType, id!) {
                if (rec.isSync) { // keep the server version, because it<s newer
                    // - if record exist on mobile and its not dirty
                    //      update the mobile record
                    //      isSync = true
                    rec.decode(serverRec.dictionaryObject!, true)
                }
                // if the record is dirty, do nothing, because the merge/override will be done during the push
            } else {
                // -  if record does not exist on the mobile device
                //      add it on mobile
                //      isSync = true
                let newRec = DB.new(objectName)
                newRec.decode(serverRec.dictionaryObject!)
                _ = DB.new(objectType, newRec)
            }
        }
    }
    
    


    public static func push<T>(_ objectType : T.Type, _ objectName : String, _ nextFunc : @escaping (Int, @escaping (Int) -> ()) -> (), _ next : Int) {
        // PUSH modifications to server
        // - get all dirty record from mobile and call post, put or delete
    }

    public static func sync() {
        doNext(0)
    }
    
    public static func doNext(_ next : Int) {
        if (next == asynlist.count) {
            return
        }
        asyncPush(asynlist[next].0 as! Object.Type, asynlist[next].1, doNext,  next + 1)
    }
}
