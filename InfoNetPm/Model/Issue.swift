//
//  Issue.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class Issue: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var type = ""
    @objc dynamic var severity = ""
    @objc dynamic var task : Task?
    @objc dynamic var comment : Comment?

    override public static func primaryKey() -> String? {
        return "id"
    }
}
