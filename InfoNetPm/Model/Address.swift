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
    @objc dynamic var country = ""
    @objc dynamic var state = ""        // state, region, province
    @objc dynamic var city = ""
    @objc dynamic var street = ""
    @objc dynamic var postalcode = ""   // Postal , zip code
    @objc dynamic var phone = ""
    @objc dynamic var email = ""
    @objc dynamic var phoneHome = ""
    @objc dynamic var emailHome = ""
    
    public func encode() -> [String: Any] {
        return [
            #keyPath(Address.country) : self.country,
            #keyPath(Address.state) : self.state,
            #keyPath(Address.city) : self.city,
            #keyPath(Address.street) : self.street,
            #keyPath(Address.postalcode) : self.postalcode,
            #keyPath(Address.phone) : self.phone,
            #keyPath(Address.email) : self.email,
            #keyPath(Address.phoneHome) : self.phoneHome,
            #keyPath(Address.emailHome) : self.emailHome
        ]
    }
    
    public func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        self.country = BaseRec.decodeString(data[#keyPath(Address.country)])
        self.state = BaseRec.decodeString(data[#keyPath(Address.state)])
        self.city = BaseRec.decodeString(data[#keyPath(Address.city)])
        self.street = BaseRec.decodeString(data[#keyPath(Address.street)])
        self.postalcode = BaseRec.decodeString(data[#keyPath(Address.postalcode)])
        self.phone = BaseRec.decodeString(data[#keyPath(Address.phone)])
        self.email = BaseRec.decodeString(data[#keyPath(Address.email)])
        self.phoneHome = BaseRec.decodeString(data[#keyPath(Address.phoneHome)])
        self.emailHome = BaseRec.decodeString(data[#keyPath(Address.emailHome)])
    }
}

