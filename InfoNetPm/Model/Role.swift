//
//  Role.swift
//  InfoNetPm
//
//  Created by jyv on 11/26/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//
import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class Role: BaseRec {
    @objc dynamic var name = ""
    @objc dynamic var desc = ""
    @objc dynamic var rateByHour = 0.0
    @objc dynamic var expectedCostByHour = 0.0
    
    public override func encode() -> [String: Any] {
        return super.encode().merge(
            [
                #keyPath(Role.name) : self.name,
                #keyPath(Role.desc) : self.desc,
                #keyPath(Role.rateByHour) : self.rateByHour,
                #keyPath(Role.expectedCostByHour) : self.expectedCostByHour
            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.name                     = data[#keyPath(Role.name)] as! String
            self.desc                     = data[#keyPath(Role.desc)] as! String
            self.rateByHour               = data[#keyPath(Role.rateByHour)] as! Double
            self.expectedCostByHour       = data[#keyPath(Role.expectedCostByHour)] as! Double

            if (setIsSync) {
                self.system?.isSync = true
            }
        }
    }
}
