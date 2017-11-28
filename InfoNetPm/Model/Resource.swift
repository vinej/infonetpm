//
//  Resource.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class Resource: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var lastName = ""
    @objc dynamic var firstName = ""
    @objc dynamic var initial = ""
    @objc dynamic var cost = 0
    @objc dynamic var hoursByWeek = 0
    @objc dynamic var hoursByDay = 0
    @objc dynamic var email = ""
    @objc dynamic var telephone = ""
    @objc dynamic var address: Address? = Address()
    @objc dynamic var company: Company?
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
