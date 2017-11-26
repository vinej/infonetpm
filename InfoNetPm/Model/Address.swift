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
    @objc dynamic var province = ""
    @objc dynamic var adress = ""
    @objc dynamic var postalCode = ""
    @objc dynamic var telephoneHome = ""
    @objc dynamic var emailHome = ""
    @objc dynamic var telephoneOffice = ""
    @objc dynamic var emailOffice = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}

