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
    @objc dynamic var name = ""
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

    @objc dynamic var createdBy = ""
    @objc dynamic var createdDate = Date()
    @objc dynamic var updatedBy = ""
    @objc dynamic var updatedDate = Date()
    
    @objc dynamic var order = 0.0
    
    let dependantPlans = List<Plan>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    /*
    public static func getOptions(_ list : Results<Object>) -> [String] {
        var listSelection = DB.defaultSelection
        var index = 1
        for rec in list {
            let pln = rec as! Plan
            listSelection.append( "\(pln.code ) | \(pln.desc )")
            index = index + 1
        }
        return listSelection
    }
    */
    
}
