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
    public static func update<T>(_ object : Object, _ field: String, _ value: T!, _ allowNil : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            if (value == nil) {
                if (!allowNil) {
                    switch(value) {
                    case is String 	: object[field] = ""
                    case is Bool : object[field] = false
                    case is Int : object[field] = 0
                    case is Float : object[field] = 0.0
                    case is Double : object[field] = 0.0
                    case is Date : object[field] = Date()
                    default : object[field] = ""
                    }
                }
            } else {
                object[field]=value
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
    
    public static func filter<T>(_ object : T.Type, _ filter: String) ->  Results<Object> {
        let realm = try! Realm()
        return realm.objects(object.self as! Object.Type).filter(filter)
    }
}

