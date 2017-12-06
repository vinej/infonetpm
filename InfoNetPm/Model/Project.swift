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
public class Project: Object, BaseCompany{
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var status = "NotStarted"
    @objc dynamic var company : Company?
    @objc dynamic var defaultTimeZone = 0.0

    @objc dynamic var isTemplate = false
    @objc dynamic var code = ""
    @objc dynamic var desc = ""
    
    // financial info
    @objc dynamic var expectedMargin = 0.0
    @objc dynamic var scheduleStartDate = Date()
    @objc dynamic var scheduleEndDate = Date()
    @objc dynamic var initialBudget = 0.0
    @objc dynamic var contingencyBudget = 0.0
    @objc dynamic var timezone = 0.0

    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?
  
    let dependantProjects = List<Project>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
