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
    @objc dynamic var status = "not started" //
    @objc dynamic var Company : Company?
    
    @objc dynamic var isTemplate = false
    @objc dynamic var name = ""
    @objc dynamic var margin = 0
    @objc dynamic var startDate = ""
    @objc dynamic var endDate = ""
    @objc dynamic var budget = ""
    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?
  
    let dependantProjects = List<Project>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
