//
//  Address.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class Address: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var country = ""
    @objc dynamic var state = ""        // state, region, province
    @objc dynamic var city = ""
    @objc dynamic var street = ""
    @objc dynamic var postalcode = ""   // Postal , zip code
    @objc dynamic var phone = ""
    @objc dynamic var email = ""
    @objc dynamic var phoneHome = ""
    @objc dynamic var emailHome = ""
    
    @objc dynamic var createdBy = ""
    @objc dynamic var createdDate = Date()
    @objc dynamic var updatedBy = ""
    @objc dynamic var updatedDate = Date()
    
    @objc dynamic var order = 0.0
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}

