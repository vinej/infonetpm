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

public class RealmHelper {
    
    public static var objectDirtyArray = [String: Bool]()
    public static var lastObject : Object? = nil
    public static var lastObjectName = "not set"
    public static var lastObjectDate = Date()

    public static let fieldAuditSeperator = "|"
    
    public static func isDirty( _ objectName : String) -> Bool {
        return objectDirtyArray[objectName] != nil ? objectDirtyArray[objectName]! : false
    }
    
    public static func setDirty( _ objectName : String, _ value : Bool) {
        objectDirtyArray[objectName] = value
    }
    
    public static let cancel = "* cancel *"
    public static let empty = "* empty *"
    public static let defaultSelection : [String] = [RealmHelper.empty,RealmHelper.cancel]
    
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

    public static func update<T>(_ object : Object, _ field: String, _ value: T!, _ allowNil : Bool = false) {
        let stype = "\(type(of: value))"
        let realm = try! Realm()
        try! realm.write {
            if (value == nil) {
                if (!allowNil) {
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
        RealmHelper.lastObject = object
        RealmHelper.lastObjectName = "\(type(of: object))"
        RealmHelper.lastObjectDate = Date()
    }
    
    public static func saveChildObject(_ parentObject : Object?,  _ object : Object) {
        let realm = try! Realm()
        try! realm.write {
            let objectName = "\(type(of: object))".lowercased()
            parentObject![objectName] = object
        }
    }
    
    public static func saveEmptyChildObject(_ parentObject : Object, _ objectName: String) {
        let realm = try! Realm()
        try! realm.write {
            parentObject[objectName] = nil
        }
    }
    
    /*
    public static func saveCompany(_ object : Object?, _ company : Company) {
        let realm = try! Realm()
        try! realm.write {
            var obj = object as! BaseCompany
            obj.company = company
        }
    }
    
    public static func saveEmptyCompany(_ object : Object) {
        let realm = try! Realm()
        try! realm.write {
            var obj = object as! BaseCompany
            obj.company = nil
        }
    }
    
    public static func saveProject(_ object : Object?, _ project : Project) {
        let realm = try! Realm()
        try! realm.write {
            var obj = object as! BaseProject
            obj.project = project
        }
    }
    
    public static func saveEmptyProject(_ object : Object) {
        let realm = try! Realm()
        try! realm.write {
            var obj = object as! BaseProject
            obj.project = nil
        }
    }
    */
    
    public static func new(_ object: Object) -> Object{
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
            realm.add(RealmHelper.getAudit(object, AuditAction.New, Date()))

        }
        return object
    }
    
    public static func del(_ object : Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(RealmHelper.getAudit(object, AuditAction.Del, Date()))
            realm.delete(object)
        }
    }

    public static func audit(_ object : Object, _ date: Date) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(RealmHelper.getAudit(object, AuditAction.Update, date))
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
        return RealmHelper.filter(object.self, "id = %@", id).first!
    }
}

