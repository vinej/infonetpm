//
//  Activity.swift
//  InfoNetPm
//
//  Created by jyv on 11/26/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//
import Foundation
import RealmSwift

public enum ActivitiyStatus {
    case NotSet
    case Failed
    case Success
}

public enum ActivityWorkflow {
    case Started
    case NotStarted
    case Running
    case OnHold
    case OnIce
    case Pending
    case Completed
}

// Define your models like regular Swift classes
public class Activity: BaseRec {
    @objc dynamic var status = "\(ActivitiyStatus.NotSet)"
    @objc dynamic var workFlow = "\(ActivityWorkflow.NotStarted)"
    @objc dynamic var plan : Plan?
    
    let activityHistory = List<ActivityHistory>()

    @objc dynamic var code = ""
    @objc dynamic var name = ""
    
    @objc dynamic var expectedDuration = 0.0
    @objc dynamic var totalDuration = 0.0

    @objc dynamic var fixeStartDate = Date()
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var role : Role?
    @objc dynamic var resource : Resource?
    @objc dynamic var backupResource : Resource?

    public override func encode() -> [String: Any] {
        return super.encode().merge([
            #keyPath(Activity.workFlow) : self.workFlow,
            #keyPath(Activity.plan) : self.plan != nil ? self.plan!.id : "",
            #keyPath(Activity.code) : self.code,
            #keyPath(Activity.name) : self.name,
            #keyPath(Activity.expectedDuration) : self.expectedDuration,
            #keyPath(Activity.totalDuration) : self.totalDuration,
            #keyPath(Activity.fixeStartDate) : self.fixeStartDate.str(),
            #keyPath(Activity.startDate) : self.startDate.str(),
            #keyPath(Activity.role) : self.role != nil ? self.role!.id : "",
            #keyPath(Activity.resource) : self.resource != nil ? resource!.id : "" ,
            #keyPath(Activity.backupResource) : self.backupResource != nil ? self.backupResource!.id : "",
        ])
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.code       = data[#keyPath(Activity.code)] as! String
            self.name       = data[#keyPath(Activity.name)] as! String
            self.workFlow   = data[#keyPath(Activity.workFlow)] as! String
            self.expectedDuration =  data[#keyPath(Activity.expectedDuration)] as! Double
            self.totalDuration =  data[#keyPath(Activity.totalDuration)] as! Double
            self.fixeStartDate =  toDate(data[#keyPath(Activity.fixeStartDate)])
            self.startDate =  toDate(data[#keyPath(Activity.startDate)])
            let dPlanId = data[#keyPath(Activity.plan)] as! String
            self.plan = dPlanId == "" ? nil : DB.get(Plan.self, dPlanId) as? Plan
            let dRoleId = data[#keyPath(Activity.role)] as! String
            self.role = dRoleId == "" ? nil : DB.get(Role.self, dRoleId) as? Role
            let dResourceId = data[#keyPath(Activity.resource)] as! String
            self.resource = dResourceId == "" ? nil : DB.get(Resource.self, dResourceId) as? Resource
            let dBackuoResourceId = data[#keyPath(Activity.backupResource)] as! String
            self.backupResource = dBackuoResourceId == "" ? nil : DB.get(Resource.self, dBackuoResourceId) as? Resource
            if (setIsSync) {
                self.system?.isSync = true
            }
        }
    }
}

