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
    @objc dynamic var schecdulEndDate = Date()
    @objc dynamic var initialBudget = ""
    @objc dynamic var contingencyBudget = 0.0
    @objc dynamic var expectedMargin = 0
    @objc dynamic var risk = 0
    @objc dynamic var timezone = 0
    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?
    
    let dependantPlans = List<Plan>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public static func getOptions(_ list : Results<Object>) -> [String] {
        var listSelection = RealmHelper.defaultSelection
        var index = 1
        for rec in list {
            let prj = rec as! Project
            listSelection.append( "\(prj.code ) | \(prj.desc )")
            index = index + 1
        }
        return listSelection
    }
    
    public static func getProject( _ value : String) -> Project {
        let index = value.firstIndex(of: "|")
        let code = value.slicing(from: 0, to: index! - 1)
        return RealmHelper.filter(Project.self, "code = %@", code!).first as! Project
    }
}
