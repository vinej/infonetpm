//
//  Issue.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class Issue: IPM {
    @objc dynamic var status = "not started" //
    @objc dynamic var task : Task?
    
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var type = ""
    @objc dynamic var severity = ""
    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?
}
