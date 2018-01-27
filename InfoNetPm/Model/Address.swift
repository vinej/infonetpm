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
        self.country = data[#keyPath(Address.country)] as! String
        self.state = data[#keyPath(Address.state)] as! String
        self.city = data[#keyPath(Address.city)] as! String
        self.street = data[#keyPath(Address.street)] as! String
        self.postalcode = data[#keyPath(Address.postalcode)] as! String
        self.phone = data[#keyPath(Address.phone)] as! String
        self.email = data[#keyPath(Address.email)] as! String
        self.phoneHome = data[#keyPath(Address.phoneHome)] as! String
        self.emailHome = data[#keyPath(Address.emailHome)] as! String
    }
}

