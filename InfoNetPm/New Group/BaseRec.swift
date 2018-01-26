//
//  ipm.swift
//  InfoNetPm
//
//  Created by jyv on 1/21/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import Foundation
import RealmSwift

public class BaseRec: Object, Codable {
    @objc dynamic var id = UUID().uuidString
    
    // system fields
    @objc dynamic var order = 0.0
    @objc dynamic var createdBy = ""
    @objc dynamic var createdDate = Date()
    @objc dynamic var updatedBy = ""
    @objc dynamic var updatedDate = Date()
    @objc dynamic var updatedDateOnServer = Date()
    @objc dynamic var updatedByOnServer = ""

    /* the version field is used to resolve conflits */
    @objc dynamic var version = 0
    /* the isSync is used to determine if a synchronization is needed for the record */
    @objc dynamic var isSync = false
    @objc dynamic var isNew = false
    @objc dynamic var isDeleted = false

    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public func encode() -> [String: Any] {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        return [
            #keyPath(BaseRec.id)                    : self.id,
            #keyPath(BaseRec.order)                 : self.order,
            #keyPath(BaseRec.createdBy)             : self.createdBy,
            #keyPath(BaseRec.createdDate)           : self.createdDate.str(),
            #keyPath(BaseRec.updatedBy)             : self.updatedBy,
            #keyPath(BaseRec.updatedDate)           : self.updatedDate.str(),
            #keyPath(BaseRec.updatedDateOnServer)   : self.updatedDateOnServer.str(),
            #keyPath(BaseRec.updatedByOnServer)     : self.updatedByOnServer,
            #keyPath(BaseRec.version)               : self.version,
            #keyPath(BaseRec.isSync)                : self.isSync,
            #keyPath(BaseRec.isNew)                 : self.isNew,
            #keyPath(BaseRec.isDeleted)             : self.isDeleted

        ]
    }
    
    public func decodeString(_ value: Any?)  -> String  {
        return value as? String ?? ""
    }
    
    public func decodeInt(_ value: Any?) -> Int  {
        return Int((value as? String)!) ?? 0
    }
   
    public func decodeBool(_ value: Any?) -> Bool  {
        return (Int((value as? String)!)! == 0 ? false : true) ?? false
    }
    
    public func decode(_ data: [String: Any]) {
        self.id                     = data[#keyPath(BaseRec.id)] as! String
        self.order                  = data[#keyPath(BaseRec.order)] as! Double
        self.createdBy              = data[#keyPath(BaseRec.createdBy)] as! String
        self.createdDate            = data[#keyPath(BaseRec.createdDate)] as! Date
        self.updatedBy              = data[#keyPath(BaseRec.updatedBy)] as! String
        self.updatedDate            = data[#keyPath(BaseRec.updatedDate)] as! Date
        self.updatedDateOnServer    = data[#keyPath(BaseRec.updatedDateOnServer)] as! Date
        self.updatedByOnServer      = data[#keyPath(BaseRec.updatedByOnServer)] as! String
        self.version                = decodeInt(data[#keyPath(BaseRec.version)])
        self.isSync                 = decodeBool(data[#keyPath(BaseRec.isSync)])
        self.isNew                  = data[#keyPath(BaseRec.isNew)] as! Bool
        self.isDeleted              = data[#keyPath(BaseRec.isDeleted)] as! Bool
    }
    
    public static func objectName(_ object : Object.Type) -> String {
        let parts = object.description().splitted(by : ".")
        if (parts.count == 1) {
            return parts[0]
        } else {
            return parts[1]
        }
    }
}

