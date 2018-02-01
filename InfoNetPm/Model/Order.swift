//
//  Counter.swift
//  InfoNetPm
//
//  Created by jyv on 12/25/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//
import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class Order: BaseRec {
    @objc dynamic var activity = 1000.0
    @objc dynamic var role = 1000.0
    @objc dynamic var addres = 1000.0
    //@objc dynamic var comment = 1000.0
    //@objc dynamic var document = 1000.0
    @objc dynamic var plan = 1000.0
    @objc dynamic var company = 1000.0
    @objc dynamic var issue = 1000.0
    @objc dynamic var project = 1000.0
    //@objc dynamic var task = 1000.0
    @objc dynamic var resource = 1000.0
    @objc dynamic var activityhistory = 1000.0
    @objc dynamic var status = 1000.0

    public override func encode() -> [String: Any] {
        return super.encode().merge(
            [
                #keyPath(Order.activity) : self.activity,
                #keyPath(Order.role) : self.role,
                #keyPath(Order.addres) : self.addres,
                #keyPath(Order.plan) : self.plan,
                #keyPath(Order.company) : self.company,
                #keyPath(Order.issue) : self.issue,
                #keyPath(Order.project) : self.project,
                #keyPath(Order.resource) : self.resource,
                #keyPath(Order.activityhistory) : self.activityhistory,
                #keyPath(Order.status) : self.status
            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.activity  = data[#keyPath(Order.activity)] as! Double
            self.role  = data[#keyPath(Order.role)] as! Double
            self.addres  = data[#keyPath(Order.addres)] as! Double
            self.plan  = data[#keyPath(Order.plan)] as! Double
            self.company  = data[#keyPath(Order.company)] as! Double
            self.issue  = data[#keyPath(Order.issue)] as! Double
            self.project  = data[#keyPath(Order.project)] as! Double
            self.activityhistory  = data[#keyPath(Order.activityhistory)] as! Double
            self.status  = data[#keyPath(Order.status)] as! Double

            if (isSync) {
                self.isSync = true
            }
        }
    }
}
