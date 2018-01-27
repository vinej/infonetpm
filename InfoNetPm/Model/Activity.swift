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
    
    @objc dynamic var type = ""         // switch, slider, text, segmented
    @objc dynamic var typeInfo = ""
    @objc dynamic var minType = 0.0
    @objc dynamic var maxType = 100.0
    @objc dynamic var incrType = 1.0

    @objc dynamic var expectedDuration = 0.0
    @objc dynamic var totalDuration = 0.0

    @objc dynamic var fixeStartDate = Date()
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var role : Role?
    @objc dynamic var resource : Resource?
    @objc dynamic var backupResource : Resource?

    let dependentActivities = List<Activity>()
    let issues = List<Issue>()
    @objc dynamic var document : Document?
    @objc dynamic var comment : Comment?

    
    public override func encode() -> [String: Any] {
        return super.encode().merge([
            #keyPath(Activity.workFlow) : self.workFlow,
            #keyPath(Activity.plan) : self.plan != nil ? self.plan!.id : "",
            #keyPath(Activity.code) : self.code,
            #keyPath(Activity.name) : self.name,
            #keyPath(Activity.type) : self.type,
            #keyPath(Activity.typeInfo) : self.typeInfo,
            #keyPath(Activity.maxType) : self.maxType,
            #keyPath(Activity.minType) : self.minType,
            #keyPath(Activity.incrType) : self.incrType,
            #keyPath(Activity.expectedDuration) : self.expectedDuration,
            #keyPath(Activity.totalDuration) : self.totalDuration,
            #keyPath(Activity.fixeStartDate) : self.fixeStartDate.str(),
            #keyPath(Activity.startDate) : self.startDate.str(),
            #keyPath(Activity.role) : self.role != nil ? self.role!.id : "",
            #keyPath(Activity.resource) : self.resource != nil ? resource!.id : "" ,
            #keyPath(Activity.backupResource) : self.backupResource != nil ? self.backupResource!.id : "",
            #keyPath(Activity.document) : self.document != nil ? self.document!.id : "",
            #keyPath(Activity.comment) : self.comment != nil ? self.comment!.id : ""
        ])
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.code       = data[#keyPath(Activity.code)] as! String
            self.name       = data[#keyPath(Activity.name)] as! String
            self.workFlow   = data[#keyPath(Activity.workFlow)] as! String

            //self.plan = BaseRec.decodeObject(#keyPath(data[Activity.plan)])
            self.type = data[#keyPath(Activity.type)] as! String
            self.typeInfo =  data[#keyPath(Activity.typeInfo)] as! String
            self.maxType =  data[#keyPath(Activity.maxType)] as! Double
            self.minType = data[#keyPath(Activity.minType)] as! Double
            self.incrType = data[#keyPath(Activity.incrType)] as! Double
            self.expectedDuration =  data[#keyPath(Activity.expectedDuration)] as! Double
            self.totalDuration =  data[#keyPath(Activity.totalDuration)] as! Double
            self.fixeStartDate =  dateToString(data[#keyPath(Activity.fixeStartDate)])
            self.startDate =  dateToString(data[#keyPath(Activity.startDate)])
            //self.role =  BaseRec.decodeObject(data[#keyPath(Activity.role)])
            //self.resource =  BaseRec.decodeObject(data[#keyPath(Activity.resource)])
            //self.backupResource =  BaseRec.decodeObject(data[#keyPath(Activity.backupResource)])
            //self.document = BaseRec.decodeObject(data[#keyPath(Activity.document)])
            //self.comment = BaseRec.decodeObject(data[#keyPath(Activity.comment)])
            if (isSync) {
                self.isSync = true
            }
        }
    }
}

