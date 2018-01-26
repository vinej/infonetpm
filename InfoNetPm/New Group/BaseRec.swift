//
//  ipm.swift
//  InfoNetPm
//
//  Created by jyv on 1/21/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import Foundation
import RealmSwift

public class BaseRec: Object {
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
    
    public func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        self.id                     = BaseRec.decodeString(data[#keyPath(BaseRec.id)])
        self.order                  = BaseRec.decodeDouble([#keyPath(BaseRec.order)])
        self.createdBy              = BaseRec.decodeString(data[#keyPath(BaseRec.createdBy)])
        self.createdDate            = data[#keyPath(BaseRec.createdDate)] as! Date
        self.updatedBy              = BaseRec.decodeString(data[#keyPath(BaseRec.updatedBy)])
        self.updatedDate            = data[#keyPath(BaseRec.updatedDate)] as! Date
        self.updatedDateOnServer    = data[#keyPath(BaseRec.updatedDateOnServer)] as! Date
        self.updatedByOnServer      = BaseRec.decodeString(data[#keyPath(BaseRec.updatedByOnServer)])
        self.version                = BaseRec.decodeInt(data[#keyPath(BaseRec.version)])
        self.isSync                 = BaseRec.decodeBool(data[#keyPath(BaseRec.isSync)])
        self.isNew                  = BaseRec.decodeBool(data[#keyPath(BaseRec.isNew)])
        self.isDeleted              = BaseRec.decodeBool(data[#keyPath(BaseRec.isDeleted)])
    }
    
    public static func decodeString(_ value: Any?)  -> String  {
        return value as? String ?? ""
    }
    
    public static func decodeInt(_ value: Any?) -> Int  {
        return Int((value as? String)!) ?? 0
    }
    
    public static func decodeBool(_ value: Any?) -> Bool  {
        return (Int((value as? String)!)! == 0 ? false : true) ?? false
    }
   
    public static func decodeDouble(_ value: Any?) -> Double  {
        return Double((value as? String)!) ?? 0.0
    }

    public static func decodeObjectId(_ value: Any?) -> String {
        return value as? String ?? ""
    }
    
    public static func decodeDate(_ value: Any?) -> Date {
        return Date()
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

