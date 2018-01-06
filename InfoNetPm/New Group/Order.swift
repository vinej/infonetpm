//
//  Counter.swift
//  InfoNetPm
//
//  Created by jyv on 12/25/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class Order: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var activity = 1000.0
    @objc dynamic var role = 1000.0
    @objc dynamic var addres = 1000.0
    @objc dynamic var comment = 1000.0
    @objc dynamic var document = 1000.0
    @objc dynamic var plan = 1000.0
    @objc dynamic var company = 1000.0
    @objc dynamic var issue = 1000.0
    @objc dynamic var project = 1000.0
    @objc dynamic var task = 1000.0
    @objc dynamic var resource = 1000.0
    @objc dynamic var activityhistory = 1000.0

    
    @objc dynamic var createdBy = ""
    @objc dynamic var createdDate = Date()
    @objc dynamic var updatedBy = ""
    @objc dynamic var updatedDate = Date()
    
    @objc dynamic var order = 0.0
}
