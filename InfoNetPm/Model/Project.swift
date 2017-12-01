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
    @objc dynamic var status = "NotStarted"
    @objc dynamic var company : Company?
    
    @objc dynamic var isTemplate = false
    @objc dynamic var code = ""
    @objc dynamic var desc = ""
    
    // financial info
    @objc dynamic var expectedMargin = 0.0
    @objc dynamic var scheduleStartDate = Date()
    @objc dynamic var scheduleEndDate = Date()
    @objc dynamic var initialBudget = 0.0
    @objc dynamic var contingencyBudget = 0.0
    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?
  
    let dependantProjects = List<Project>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    public static func saveCompany(_ project  : Project, _ company : Company) {
        let realm = try! Realm()
        try! realm.write {
            project.company = company
        }
    }
    
    public static func saveEmptyCompany(_ project  : Project) {
        let realm = try! Realm()
        try! realm.write {
            project.company = nil
        }
    }
}
