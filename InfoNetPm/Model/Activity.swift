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
    @objc dynamic var status = "not started" //
    @objc dynamic var plan : Plan?

    @objc dynamic var isTemplate = false
    @objc dynamic var name = ""
    @objc dynamic var duration = 0
    @objc dynamic var role : Role?
    @objc dynamic var resource : Resource?
    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?
    
    let dependantActivities = List<Activity>()
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}

