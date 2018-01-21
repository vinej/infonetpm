//
//  ipm.swift
//  InfoNetPm
//
//  Created by jyv on 1/21/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import Foundation
import RealmSwift

public class IPM: Object {
    @objc dynamic var id = UUID().uuidString
    
    // system fields
    @objc dynamic var order = 0.0
    @objc dynamic var createdBy = ""
    @objc dynamic var createdDate = Date()
    @objc dynamic var updatedBy = ""
    @objc dynamic var updatedDate = Date()
    
    /* the version field is used to resolve conflits */
    @objc dynamic var version = 0
    /* the isSync is used to determine if a synchronization is needed for the record */
    @objc dynamic var isSync = false

    override public static func primaryKey() -> String? {
        return "id"
    }
}

