//
//  Audit.swift
//  InfoNetPm
//
//  Created by jyv on 12/2/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class Audit: Object {
    @objc dynamic var id = UUID().uuidString

    @objc dynamic var objectId = ""
    @objc dynamic var objectName = ""
    @objc dynamic var auditAction = ""
    @objc dynamic var objectString = ""
    
    @objc dynamic var createdBy = ""
    @objc dynamic var createdDate = Date()
    @objc dynamic var updatedBy = ""
    @objc dynamic var updatedDate = Date()
    
    @objc dynamic var order = 0.0
    
}
