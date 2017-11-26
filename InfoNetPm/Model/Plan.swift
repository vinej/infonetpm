//
//  Plan.swift
//  D3Plan
//
//  A plan is a activity list to be done by resource
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class Plan: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var isTemplate = false
    @objc dynamic var name = ""
    @objc dynamic var startDate = ""
    @objc dynamic var budget = ""
    @objc dynamic var margin = 0
    @objc dynamic var risk = 0
    @objc dynamic var timezone = 0
    @objc dynamic var project : Project?
    @objc dynamic var dependantPlan : Plan?
    @objc dynamic var comment : Comment?
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
