//
//  Task.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class Task: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var type = "" // boolean, string, temperature, etc..
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var duration = 0
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
