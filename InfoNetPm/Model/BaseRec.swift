//
//  ipm.swift
//  InfoNetPm
//
//  Created by jyv on 1/21/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//  
import Foundation
import RealmSwift

public class Base : Object {
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
    
    
    public func encode() -> [String: Any] {
        return [
            #keyPath(Base.order)                 : self.order,
            #keyPath(Base.createdBy)             : self.createdBy,
            #keyPath(Base.createdDate)           : self.createdDate.str(),
            #keyPath(Base.updatedBy)             : self.updatedBy,
            #keyPath(Base.updatedDate)           : self.updatedDate.str(),
            #keyPath(Base.updatedDateOnServer)   : self.updatedDateOnServer.str(),
            #keyPath(Base.updatedByOnServer)     : self.updatedByOnServer,
            #keyPath(Base.version)               : self.version,
            #keyPath(Base.isSync)                : self.isSync,
            #keyPath(Base.isNew)                 : self.isNew,
            #keyPath(Base.isDeleted)             : self.isDeleted
        ]
    }
    
    public func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        self.order                  = data[#keyPath(Base.order)] as! Double
        self.createdBy              = data[#keyPath(Base.createdBy)] as! String
        self.createdDate            = toDate(data[#keyPath(Base.createdDate)])
        self.updatedBy              = data[#keyPath(Base.updatedBy)] as! String
        self.updatedDate            = toDate(data[#keyPath(Base.updatedDate)])
        self.updatedDateOnServer    = toDate(data[#keyPath(Base.updatedDateOnServer)])
        self.updatedByOnServer      = data[#keyPath(Base.updatedByOnServer)] as! String
        self.version                = data[#keyPath(Base.version)] as! Int
        self.isSync                 = data[#keyPath(Base.isSync)] as! Bool
        self.isNew                  = data[#keyPath(Base.isNew)] as! Bool
        self.isDeleted              = data[#keyPath(Base.isDeleted)] as! Bool
    }
}

public class BaseRec: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var system: Base? = Base()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public func encode() -> [String: Any] {
        let system = self.system?.encode()
        return [
            #keyPath(BaseRec.id)                    : self.id,
            #keyPath(BaseRec.system)                : system!
        ]
    }
    
    public func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        self.system?.decode(data[#keyPath(BaseRec.system)] as! [String : Any] )
    }
    
    public static func objectName(_ object : Object.Type) -> String {
        let parts = object.description().splitted(by : ".")
        if (parts.count == 1) {
            return parts[0]
        } else {
            return parts[1]
        }
    }
    
    public static func objectNameLower(_ object : Object.Type) -> String {
        return objectName(object).lowercased()
    }
}

