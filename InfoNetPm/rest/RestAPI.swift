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
    var asyncList : [ (Any.Type, String) ] = [
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
    
    var listToSync : Results<Object>
    var lastSyncDate :  Date
    var currentObjectName = ""
    var currentNextFunc : (Int, RestAPI) -> ()
    var currentNext = 0
    var view : SynchronizeViewController
    
    init() {
        listToSync = DB.all(Status.self)
        lastSyncDate = Date()
        currentObjectName = ""
        currentNextFunc = RestAPI.staticPull
        currentNext = 0
        view = SynchronizeViewController()
    }
    
    public func syncBaseRec(_ baseRec : BaseRec, _ objectName: String,
                            _ nextFunc : @escaping (Int, RestAPI) -> (), _ next : Int, _ restApi : RestAPI) {
        if (baseRec.isNew) {  // could be UpdatedDate == CreatedDate
            // add a new record on the server
            api(baseRec, objectName, HTTPMethod.post, nextFunc, next, restApi)
        } else if (baseRec.isDeleted) {
            // soft delete a record
            api(baseRec, objectName, HTTPMethod.delete, nextFunc, next, restApi)
        } else {
            // update a record
            api(baseRec, objectName, HTTPMethod.put, nextFunc, next, restApi)
        }
    }
    
    public func get<T>(_ objectType : T.Type, _ objectName: String, _ lastUpdated: Date,
                       _ nextFunc : @escaping (Int, RestAPI) -> (), _ next: Int,  _ restApi : RestAPI) {
        Alamofire.request("\(API_URL)\(objectName)/\(lastUpdated.str())").responseJSON { response in
            restApi.asyncPull(objectType, objectName, JSON(response.result.value!), nextFunc, next, restApi)
        }
    }
    
    public func api(_ baseRec : BaseRec, _ objectName: String, _ method : HTTPMethod,
                    _ nextFunc : @escaping (Int, RestAPI) -> (), _ next: Int, _ restApi: RestAPI) {
        let parameters = baseRec.encode()
        
        Alamofire.request("\(API_URL)\(objectName)", method: method, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            let swiftyJsonVar = JSON(response.result.value!)
            if let data = swiftyJsonVar["result"].dictionaryObject {
                baseRec.decode(data)
            }
            nextFunc(next, restApi)
        }
    }

    public func asyncPush<T>(_ objectType : T.Type, _ objectName : String,
                             _ nextFunc : @escaping (Int, RestAPI) -> (), _ next : Int, _ restApi: RestAPI) {
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
        restApi.listToSync = DB.filter(objectType, "isSync = %@", false)
        if (restApi.listToSync.count == 0) {
            // next objecy
            nextFunc(next, restApi)
            return
        }
        restApi.currentObjectName = objectName
        restApi.currentNextFunc = nextFunc
        restApi.currentNext = next
        syncBaseRec(restApi.listToSync[0] as! BaseRec, restApi.currentObjectName, nextToPush, 1, restApi)
    }
    
    public func nextToPush( _ next : Int, _ restApi: RestAPI) {
        if (restApi.listToSync.count == 0) {
           return
        }
        
        if (next == restApi.listToSync.count) {
            restApi.currentNextFunc(restApi.currentNext, restApi)
            return
        }
        syncBaseRec(listToSync[next] as! BaseRec, currentObjectName, nextToPush, next + 1, restApi)
    }

    public func asyncPull<T>(_ objectType : T.Type, _ objectName : String, _ json: JSON, _ nextFunc : (Int, RestAPI) -> (), _ next : Int, _ restApi: RestAPI) {
        if (json.count == 0) {
            nextFunc(next,restApi)
            return
        }
        
        for (_,subJson) : (String, JSON) in json {
            if (subJson.count == 0) {
                nextFunc(next, restApi)
                return
            }
            for serverRec in subJson.array!  {
                let id = serverRec[#keyPath(BaseRec.id)].string
                if let rec = DB.get(objectType, id!) {
                    if (rec.isSync) { // keep the server version, because it's newer
                        // - if record exist on mobile and its not dirty
                        //      update the mobile record
                        //      isSync = true
                        rec.decode(serverRec.dictionaryObject!, true)
                    } else {
                        // merge
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
        
        nextFunc(next,restApi)
    }

    // synchronize the mobile db with the server
    // 1) pull a modifications
    // 2) push the remaining modifications
    public func sync(_ view: SynchronizeViewController) {
        // strats to pull all new records
        self.view = view
        UI({ self.view.setCurrentObject("Starting synchronization") } )

        pull(0, self)
    }

    // dummy
    public static func staticPull(_ next : Int, _ restApi: RestAPI) {
        if (next == restApi.asyncList.count) {
            // push the remainding record not sync yes
            restApi.push(0, restApi)
            return
        }
        UI({ restApi.view.setCurrentObject(restApi.asyncList[next].1) } )
        restApi.get(restApi.asyncList[next].0 as! Object.Type, restApi.asyncList[next].1, restApi.lastSyncDate, restApi.pull,  next + 1, restApi)
    }

    public func pull(_ next : Int, _ restApi: RestAPI) {
        if (next == asyncList.count) {
            // push the remainding record not sync yes
            push(0, restApi)
            return
        }
        UI({ restApi.view.setCurrentObject("Pulling:  \(restApi.asyncList[next].1)") } )
        get(asyncList[next].0 as! Object.Type, asyncList[next].1, lastSyncDate, pull,  next + 1, restApi)
    }
    
    public func push(_ next : Int, _ restApi: RestAPI) {
        if (next == restApi.asyncList.count) {
            return
        }
        UI({ restApi.view.setCurrentObject("Pushing:  \(restApi.asyncList[next].1)") } )
        asyncPush(asyncList[next].0 as! Object.Type, asyncList[next].1, push,  next + 1, restApi)
    }
}
