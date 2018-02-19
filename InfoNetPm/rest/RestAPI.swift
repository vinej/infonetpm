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
import p2_OAuth2
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
//https://salesforce.stackexchange.com/questions/42445/whats-the-difference-between-these-authentication-endpoints


public let API_URL = "http://192.168.242.1:80/"

public let TOKEN_URL = "http://192.168.242.1:80/auth/user"
public let CLIENT_ID = "vinej"
public let CLIENT_SECRET = "test"


public class RestAPI {
    var asyncList : [ (Any.Type, String) ] = [
        (Company.self,            BaseRec.objectNameLower(Company.self)),
        (Resource.self,           BaseRec.objectNameLower(Resource.self)),
        //(Status.self,             BaseRec.objectNameLower(Status.self)),
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
    var currentNextFunc : (Int) -> ()
    var currentNext = 0
    var view : SynchronizeViewController
    fileprivate var alamofireManager: SessionManager?
    
    init() {
        
        let sessionManager = SessionManager.default
        let retrier = OAuth2RetryHandler()
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
        self.alamofireManager = sessionManager   // you must hold on to this somewhere
        retrier.setManager(alamofireManager)

        
        listToSync = DB.all(Status.self)
        lastSyncDate = (listToSync[0] as! Status).lastSyncDate
        currentObjectName = ""
        currentNextFunc = RestAPI.staticPull
        currentNext = 0
        view = SynchronizeViewController()
    }
    
    public func syncBaseRec(_ baseRec : BaseRec, _ objectName: String,
                            _ nextFunc : @escaping (Int) -> (), _ next : Int) {
        if (baseRec.system?.isNew)! {  // could be UpdatedDate == CreatedDate
            // add a new record on the server
            api(baseRec, objectName, HTTPMethod.post, nextFunc, next)
        } else if (baseRec.system?.isDeleted)! {
            // soft delete a record
            api(baseRec, objectName, HTTPMethod.delete, nextFunc, next)
        } else {
            // update a record
            api(baseRec, objectName, HTTPMethod.put, nextFunc, next)
        }
    }
    
    public func get<T>(_ objectType : T.Type, _ objectName: String, _ lastUpdated: Date,
                       _ nextFunc : @escaping (Int) -> (), _ next: Int) {
        alamofireManager?.request("\(API_URL)\(objectName)/\(lastUpdated.str())").validate().responseJSON { response in
            self.asyncPull(objectType, objectName, JSON(response.result.value!), nextFunc, next)
        }
    }
    
    public func api(_ baseRec : BaseRec, _ objectName: String, _ method : HTTPMethod,
                    _ nextFunc : @escaping (Int) -> (), _ next: Int) {
        let parameters = baseRec.encode()
        
        alamofireManager?.request("\(API_URL)\(objectName)", method: method, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            // the current context is lost, reset the current values
            if (response.result.value != nil) {
                let swiftyJsonVar = JSON(response.result.value!)
                if let data = swiftyJsonVar["result"].dictionaryObject {
                    // listToSync will decrease by one, because now isSync = true for this record
                    baseRec.decode(data)
                }
            }
            nextFunc(next)
        }
    }

    public func asyncPush<T>(_ objectType : T.Type, _ objectName : String,
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
        // note : listToSync will decrease themself when we decode the data and the field isSync = true
        listToSync = DB.filter(objectType, "isSync = %@", false)
        
        if (listToSync.count == 0) {
            // next objecy
            nextFunc(next)
            return
        }
        currentObjectName = objectName
        currentNextFunc = nextFunc
        currentNext = next
        // push in the reverse order, because Real will remove the push record from
        // the listtoSync, becasue a filter is dynamic and change when record fields changes
        syncBaseRec(listToSync[listToSync.count - 1] as! BaseRec, currentObjectName, nextToPush, listToSync.count - 2)
    }
    
    public func nextToPush( _ next : Int) {
        if (listToSync.count == 0 || next == -1) {
            currentNextFunc(currentNext)
            return
        }
        syncBaseRec(listToSync[next] as! BaseRec, currentObjectName, nextToPush, next - 1)
    }

    public func asyncPull<T>(_ objectType : T.Type, _ objectName : String, _ json: JSON, _ nextFunc : (Int) -> (), _ next : Int) {
        if (json.count == 0) {
            nextFunc(next)
            return
        }
        
        for (_,subJson) : (String, JSON) in json {
            if (subJson.count == 0) {
                nextFunc(next)
                return
            }
            for serverRec in subJson.array!  {
                let id = serverRec[#keyPath(BaseRec.id)].string
                if let rec = DB.get(objectType, id!) {
                    if (rec.system?.isSync)! { // keep the server version, because it's newer
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
        nextFunc(next)
    }

    // synchronize the mobile db with the server
    // 1) pull a modifications
    // 2) push the remaining modifications
    public func sync(_ view: SynchronizeViewController) {
        // strats to pull all new records
        self.view = view
        UI({ self.view.setCurrentObject("Starting synchronization") } )
        pull(0)
    }

    // dummy to init the var
    public static func staticPull(_ next : Int) {
    }

    public func pull(_ next : Int) {
        if (next == asyncList.count) {
            // push the remainding record not sync yes
            push(0)
            return
        }
        UI({ self.view.setCurrentObject("Pulling:  \(self.asyncList[next].1)") } )
        get(asyncList[next].0 as! Object.Type, asyncList[next].1, lastSyncDate, pull,  next + 1)
    }
    
    public func push(_ next : Int) {
        if (next == asyncList.count) {
            DB.update(DB.all(Status.self)[0], "lastSyncDate", Date())
            UI({ self.view.stop() })
            return
        }
        UI({ self.view.setCurrentObject("Pushing:  \(self.asyncList[next].1)") } )
        asyncPush(asyncList[next].0 as! Object.Type, asyncList[next].1, push,  next + 1)
    }
}
