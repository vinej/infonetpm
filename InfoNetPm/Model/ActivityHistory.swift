//
//  ActivityHistory.swift
//  InfoNetPm
//
//  Created by jyv on 1/6/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//
import Foundation
import RealmSwift


// Define your models like regular Swift classes
public class ActivityHistory: BaseRec {
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var workFlow = "\(ActivityWorkflow.NotStarted)"
    @objc dynamic var duration = 0.0
    @objc dynamic var resourceStart : Resource? = nil
    @objc dynamic var resourceEnd : Resource? = nil
    
    public override func encode() -> [String: Any] {
        return super.encode().merge(
            [
                #keyPath(ActivityHistory.startDate) : self.startDate.str(),
                #keyPath(ActivityHistory.endDate) : self.endDate.str(),
                #keyPath(ActivityHistory.workFlow) : self.workFlow,
                #keyPath(ActivityHistory.duration) : self.duration,
                #keyPath(ActivityHistory.resourceStart) : self.resourceStart != nil ? self.resourceStart!._id : "" ,
                #keyPath(ActivityHistory.resourceEnd) : self.resourceEnd != nil ? self.resourceEnd!._id : ""
            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.startDate  = toDate(data[#keyPath(ActivityHistory.startDate)])
            self.endDate  = toDate(data[#keyPath(ActivityHistory.endDate)])
            self.workFlow  = data[#keyPath(ActivityHistory.workFlow)] as! String
            self.duration  = data[#keyPath(ActivityHistory.duration)] as! Double
            let dResourceId = data[#keyPath(ActivityHistory.resourceStart)] as! String
            self.resourceStart = dResourceId == "" ? nil : DB.get(Resource.self, dResourceId) as? Resource
            let dResource2Id = data[#keyPath(ActivityHistory.resourceEnd)] as! String
            self.resourceEnd = dResource2Id == "" ? nil : DB.get(Resource.self, dResource2Id) as? Resource

            if (setIsSync) {
                self.system?.isSync = true
            }
        }
    }
}
