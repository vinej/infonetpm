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
    @objc dynamic var status = "NotStarted" //
    @objc dynamic var project : Project?
    @objc dynamic var isTemplate = false
    @objc dynamic var code = ""
    @objc dynamic var desc = ""
    @objc dynamic var scheduleStartDate = Date()
    @objc dynamic var scheduleEndDate = Date()
    @objc dynamic var initialBudget = 0.0
    @objc dynamic var contingencyBudget = 0.0
    @objc dynamic var expectedMargin = 0.0
    @objc dynamic var risk = 0.0
    @objc dynamic var timezone = 0.0
    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?
    
    let dependantPlans = List<Plan>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    
}
