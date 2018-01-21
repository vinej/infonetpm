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
public class Audit: IPM {
    @objc dynamic var objectId = ""
    @objc dynamic var objectName = ""
    @objc dynamic var objectDate = Date()
    @objc dynamic var auditAction = ""
    @objc dynamic var objectString = ""
}
