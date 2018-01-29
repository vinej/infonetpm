//
//  Plan.swift
//  D3Plan
//
//  A plan is a activity list to be done by resource
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class Plan: BaseRec {
    @objc dynamic var status = "NotStarted" //
    @objc dynamic var project : Project?
    @objc dynamic var code = ""
    @objc dynamic var name = ""
    @objc dynamic var desc = ""
    @objc dynamic var scheduleStartDate = Date()
    @objc dynamic var scheduleEndDate = Date()
    @objc dynamic var initialBudget = 0.0
    @objc dynamic var contingencyBudget = 0.0
    @objc dynamic var expectedMargin = 0.0
    @objc dynamic var risk = 0.0
    @objc dynamic var timezone = 0.0
    //@objc dynamic var document : Document?
    //@objc dynamic var comment : Comment?
    
    let dependantPlans = List<Plan>()
    
    public override func encode() -> [String: Any] {
        return super.encode().merge(
            [
                #keyPath(Plan.code) : self.code,
                #keyPath(Plan.name) : self.name,
                #keyPath(Plan.desc) : self.desc,
                #keyPath(Plan.status) : self.status,
                #keyPath(Plan.scheduleStartDate) : self.scheduleStartDate.str(),
                #keyPath(Plan.scheduleEndDate) : self.scheduleEndDate.str(),
                #keyPath(Plan.initialBudget) : self.initialBudget,
                #keyPath(Plan.contingencyBudget) : self.contingencyBudget,
                #keyPath(Plan.expectedMargin) : self.expectedMargin,
                #keyPath(Plan.risk) : self.risk,
                #keyPath(Plan.timezone) : self.timezone,
                #keyPath(Plan.project) : self.project == nil ? "" : self.project!.id,
            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.code  = data[#keyPath(Plan.code)] as! String
            self.name = data[#keyPath(Plan.name)] as! String
            self.desc = data[#keyPath(Plan.desc)] as! String
            self.status = data[#keyPath(Plan.status)] as! String
            self.scheduleStartDate = toDate(data[#keyPath(Plan.scheduleStartDate)])
            self.scheduleEndDate = toDate(data[#keyPath(Plan.scheduleEndDate)])
            self.initialBudget = data[#keyPath(Plan.initialBudget)] as! Double
            self.contingencyBudget = data[#keyPath(Plan.contingencyBudget)] as! Double
            self.expectedMargin = data[#keyPath(Plan.expectedMargin)] as! Double
            self.risk = data[#keyPath(Plan.risk)] as! Double
            self.timezone = data[#keyPath(Plan.timezone)] as! Double
            let dProjectId = data[#keyPath(Plan.project)] as! String
            self.project = dProjectId == "" ? nil : DB.get(Project.self, dProjectId) as? Project
            if (isSync) {
                self.isSync = true
            }
        }
    }
}
