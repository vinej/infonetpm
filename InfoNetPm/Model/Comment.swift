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
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}

