//
//  RealmHelper.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmHelper {
    
    public static var isObjectDirty = [String: Bool]()
    
    public static func isDirty( _ objectName : String) -> Bool {
        return isObjectDirty[objectName] != nil ? isObjectDirty[objectName]! : false
    }
    
    public static func setDirty( _ objectName : String, _ value : Bool) {
        isObjectDirty[objectName] = value
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

    public static func update<T>(_ object : Object, _ field: String, _ value: T!, _ allowNil : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            if (value == nil) {
                if (!allowNil) {
                    let stype = "\(type(of: value))"
                    switch(stype) {
                    case "Optional<Double>" : object[field] = 0.0
                    case "Optional<String>" : object[field] = ""
                    case "Optional<Bool>" : object[field] = false
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
    }

    public static func new(_ object: Object) -> Object{
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)

        }
        return object
    }
    
    public static func del(_ object : Object) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
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

