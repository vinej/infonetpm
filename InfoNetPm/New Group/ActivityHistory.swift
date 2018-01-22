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
public class ActivityHistory: BaseRec {
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var workFlow = "\(ActivityWorkflow.NotStarted)"
    @objc dynamic var duration = 0.0
    @objc dynamic var resourceStart : Resource? = nil
    @objc dynamic var resourceEnd : Resource? = nil
}
