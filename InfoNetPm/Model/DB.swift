//
//  RealmHelper.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public enum AuditAction {
    case Del
    case New
    case Update
}

public class DB {
    
    public static var objectDirtyArray = [String: Bool]()
    public static var lastObject : Object? = nil
    public static var lastObjectName = "not set"
    public static var lastObjectDate = Date()
    public static var isNeedSynchronization = false

    public static let fieldAuditSeperator = "|"
    
    public static func isDirty( _ objectName : String) -> Bool {
        return objectDirtyArray[objectName] != nil ? objectDirtyArray[objectName]! : false
    }
    
    public static func setDirty( _ objectName : String, _ value : Bool) {
        objectDirtyArray[objectName] = value
        DB.isNeedSynchronization = true
    }
    
    public static let cancel = "<CANCEL>"
    public static let empty = "<CLEAR>"
    public static let defaultSelection : [String] = [DB.empty,DB.cancel]
    
    
    public static func getOptions(_ list : Results<Object>, _ code:  String = "code", _ name : String = "name", _ name2 : String = "") -> [String] {
        var listSelection = DB.defaultSelection
        var index = 1
        for rec in list {
            if (name2 == "") {
                listSelection.append( "\(rec[code]  ?? "") | \(rec[name]  ?? "")")
            } else{
                listSelection.append( "\(rec[code]  ?? "") | \(rec[name]  ?? "") | \(rec[name2]  ?? "")")
            }
            index = index + 1
        }
        return listSelection
    }
    
    public static func getObject<T>(_ obj : T.Type, _ field:  String, _ value : String) -> Object {
        let index = value.firstIndex(of: "|")
        let code = value.slicing(from: 0, to: index! - 1)
        return (DB.filter(obj.self, "\(field) = %@", code!).first)!
    }
    
    public static func toSelection(_ list : Results<Object>, _ field : String) -> [String] {
        var listSelection = self.defaultSelection
        var index = 1
        for rec in list {
            listSelection.append( "\(String(format: "%03d",index)): \(rec[field] ?? "")")
            index = index + 1
        }
        return listSelection
    }
    
    public static func getSelectionIndex(_ value : String)  -> Int {
        if (value == self.empty) { return 0 }
        if (value == self.cancel) { return 1 }
        let index = value.index(of: ":") ?? value.endIndex
        return Int(value[..<index])! + 1
    }
    
    public static func getAudit(_ object : Object, _ auditAction: AuditAction, _ date : Date) -> Audit
    {
        // transaction must be created by the caller
        let audit = Audit()
        audit.dateCreated = Date.init(timeIntervalSinceNow: 0)
        audit.userCreated = NSUserName()
        audit.auditAction = "\(auditAction)"
        audit.objectName = "\(type(of: object))"
        audit.objectId = object["id"] as! String
        audit.objectString = object.description.replacingOccurrences(of: "\n\t", with: fieldAuditSeperator)
        return audit
    }

    public static func update<T>(_ objectName : String, _ object : Object, _ field: String, _ value: T!, _ isAllowNil : Bool = false, _ isSetDirty : Bool = true) {
        let stype = "\(type(of: value))"
        let realm = try! Realm()
        try! realm.write {
            if (value == nil) {
                if (!isAllowNil) {
                    switch(stype) {
                        case "Optional<Double>" : object[field] = 0.0
                        case "Optional<String>" : object[field] = ""
                        case "Optional<Bool>" :  object[field] = false
                        case "Optional<Int>" : object[field] = 0
                        case "Optional<Float>" : object[field] = 0.0
                        case "OPtional<Date>" : object[field] = Date()
                        default : object[field] = value
                    }


                }
            } else {
                if ( String(describing: value) == "Optional<#nil#>"  ) {
                    object[field] = nil
                }
                object[field] = value
            }
        }
        
        // need that to add a audit before leaving the app
        DB.lastObject = object
        DB.lastObjectName = "\(type(of: object))"
        DB.lastObjectDate = Date()
        if (isSetDirty) {
            DB.setDirty(objectName, true)
        }
    }
    
    public static func saveChildObject( _ parentObject : Object?,  _ object : Object, _ isSetDirty: Bool = true) {
        let realm = try! Realm()
        try! realm.write {
            let objectName = "\(type(of: object))".lowercased()
            parentObject![objectName] = object
            if (isSetDirty) {
                DB.setDirty("\(type(of: parentObject))", true)
            }
        }
    }
    
    public static func saveEmptyChildObject( _ parentObject : Object, _ objectName : String, _ isSetDirty: Bool = true) {
        let realm = try! Realm()
        try! realm.write {
            parentObject[objectName] = nil
            if (isSetDirty) {
                DB.setDirty("\(type(of: parentObject))", true)
            }
        }
    }
    
    public static func new(_ object: Object, _ isSetDirty: Bool = true) -> Object{
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
            realm.add(DB.getAudit(object, AuditAction.New, Date()))
            if (isSetDirty) {
                DB.setDirty("\(type(of: object))", true)
            }

        }
        return object
    }
    
    public static func del(_ object : Object, _ isSetDirty : Bool = true) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(DB.getAudit(object, AuditAction.Del, Date()))
            realm.delete(object)
            if (isSetDirty) {
                DB.setDirty("\(type(of: object))", true)
            }
        }
    }

    public static func audit(_ object : Object, _ date: Date) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(DB.getAudit(object, AuditAction.Update, date))
        }
    }
    
    public static func all<T>(_ object : T.Type) ->  Results<Object> {
        let realm = try! Realm()
        return realm.objects(object.self as! Object.Type)
    }
    
    public static func count<T>(_ object : T.Type) ->  Int {
        let realm = try! Realm()
        return realm.objects(object.self as! Object.Type).count
    }

    public static func filter<T>(_ object : T.Type, _ field : String, _ filter: String) ->  Results<Object> {
        let realm = try! Realm()
        return realm.objects(object.self as! Object.Type).filter(field, filter )
    }
    
    public static func get<T>(_ object : T.Type, id : String) -> Object {
        return DB.filter(object.self, "id = %@", id).first!
    }
}

