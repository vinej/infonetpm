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
    
    public static func syncBaseRec(_ baseRec : BaseRec, _ objectName: String) {
        if (baseRec.isNew) {  // could be UpdatedDate == CreatedDate
            // add a new record on the server
            api(baseRec, objectName, HTTPMethod.post)
        } else if (baseRec.isDeleted) {
            // soft delete a record
            api(baseRec, objectName, HTTPMethod.delete)
        } else {
            // update a record
            api(baseRec, objectName, HTTPMethod.put)
        }
    }
    
    public static func get<T>(_ object : T.Type) -> Results<Object>? {
        return nil
    }
    
    public static func api(_ baseRec : BaseRec, _ objectName: String, _ method : HTTPMethod) {
        Alamofire.request("\(API_URL)\(objectName)", method: method, parameters: baseRec.encode(), encoding: JSONEncoding.default).responseJSON { response in
            let swiftyJsonVar = JSON(response.result.value!)
    
            if let data = swiftyJsonVar["result"].dictionaryObject {
                baseRec.decode(data)
            }
        }
    }

    public static func syncObject<T>(_ objectType : T.Type, _ objectName : String) {
        
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
        let list = DB.filter(objectType, "isSync = %@", false)
        for obj in list {
            syncBaseRec(obj as! BaseRec, objectName)
        }
    }

    public static func sync() {
        syncObject(Company.self,            BaseRec.objectName(Company.self))
        syncObject(Activity.self,           BaseRec.objectName(Activity.self))
        syncObject(Document.self,           BaseRec.objectName(Document.self))
        syncObject(Role.self,               BaseRec.objectName(Role.self))
        syncObject(Comment.self,            BaseRec.objectName(Comment.self))
        syncObject(Company.self,            BaseRec.objectName(Company.self))
        syncObject(Issue.self,              BaseRec.objectName(Issue.self))
        syncObject(Plan.self,               BaseRec.objectName(Plan.self))
        syncObject(Project.self,            BaseRec.objectName(Project.self))
        syncObject(Resource.self,           BaseRec.objectName(Resource.self))
        syncObject(Task.self,               BaseRec.objectName(Task.self))
        syncObject(Audit.self,              BaseRec.objectName(Audit.self))
        syncObject(Order.self,              BaseRec.objectName(Order.self))
        syncObject(ActivityHistory.self,    BaseRec.objectName(ActivityHistory.self))
        syncObject(Status.self,             BaseRec.objectName(Status.self))
    }
}
