//
//  Task.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class Task: BaseRec {
    @objc dynamic var status = "not started" //
    @objc dynamic var activity : Activity?

    @objc dynamic var isTemplate = false
    @objc dynamic var name = ""
    @objc dynamic var type = "" // boolean, string, temperature, etc..
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var duration = 0
    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?
    
    let dependantTasks = List<Task>()
}
