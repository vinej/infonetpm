//
//  Project.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class Project: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var company : Company?
    @objc dynamic var margin = 0
    @objc dynamic var startDate = ""
    @objc dynamic var endDate = ""
    @objc dynamic var budget = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
