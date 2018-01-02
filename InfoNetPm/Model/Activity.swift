//
//  Activity.swift
//  InfoNetPm
//
//  Created by jyv on 11/26/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class Activity: Object {

    @objc dynamic var id = UUID().uuidString
    @objc dynamic var status = "NotStarted" // "NotStarted", "Success", "Failed"
    @objc dynamic var workFlow = "NotStarted" // NotStarted, Started, "Completed", "OnHold"
    @objc dynamic var plan : Plan?

    @objc dynamic var code = ""
    @objc dynamic var name = ""
    
    @objc dynamic var type = ""         // switch, slider, text, segmented
    @objc dynamic var typeInfo = ""
    @objc dynamic var minType = 0.0
    @objc dynamic var maxType = 100.0
    @objc dynamic var incrType = 1.0

    @objc dynamic var duration = 0.0
    @objc dynamic var fixeStartDate = Date()
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var role : Role?
    @objc dynamic var resource : Resource?
    @objc dynamic var backupResource : Resource?

    @objc dynamic var order = 0.0

    let dependentActivities = List<Activity>()
    let issues = List<Issue>()
    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?
    

    @objc dynamic var createdBy = ""
    @objc dynamic var createdDate = Date()
    @objc dynamic var updatedBy = ""
    @objc dynamic var updatedDate = Date()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}

