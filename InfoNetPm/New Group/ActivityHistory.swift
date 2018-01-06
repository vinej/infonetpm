//
//  ActivityHistory.swift
//  InfoNetPm
//
//  Created by jyv on 1/6/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class ActivityHistory: Object {
    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var workFlow = "\(ActivityWorkflow.NotStarted)"
    @objc dynamic var duration = 0.0
    @objc dynamic var resourceStart : Resource? = nil
    @objc dynamic var resourceEnd : Resource? = nil
    
    // system field
    @objc dynamic var order = 0.0
    @objc dynamic var createdBy = ""
    @objc dynamic var createdDate = Date()
    @objc dynamic var updatedBy = ""
    @objc dynamic var updatedDate = Date()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
