//
//  Comment.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class Comment: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""

    
    @objc dynamic var createdBy = ""
    @objc dynamic var createdDate = Date()
    @objc dynamic var updatedBy = ""
    @objc dynamic var updatedDate = Date()
    
    @objc dynamic var order = 0.0
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}

