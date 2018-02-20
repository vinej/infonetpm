//
//  Project.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//
import Foundation
import RealmSwift

 
// Define your models like regular Swift classes
public class Project: BaseRec {
    @objc dynamic var status = "NotStarted"
    @objc dynamic var company : Company?
    @objc dynamic var defaultTimezone = 0.0

    @objc dynamic var code = ""
    @objc dynamic var name = ""
    @objc dynamic var desc = ""
    
    // financial info
    @objc dynamic var expectedMargin = 0.0
    @objc dynamic var scheduleStartDate = Date()
    @objc dynamic var scheduleEndDate = Date()
    @objc dynamic var initialBudget = 0.0
    @objc dynamic var contingencyBudget = 0.0
    @objc dynamic var timezone = 0.0

    //@objc dynamic var document : Document?
    //@objc dynamic var comment : Comment?
    //let dependantProjects = List<Project>()
    
    public override func encode() -> [String: Any] {
        return super.encode().merge(
            [

                #keyPath(Project.code) : self.code,
                #keyPath(Project.name) : self.name,
                #keyPath(Project.desc) : self.desc,
                #keyPath(Project.status) : self.status,
                #keyPath(Project.scheduleStartDate) : self.scheduleStartDate.str(),
                #keyPath(Project.scheduleEndDate) : self.scheduleEndDate.str(),
                #keyPath(Project.initialBudget) : self.initialBudget,
                #keyPath(Project.contingencyBudget) : self.contingencyBudget,
                #keyPath(Project.expectedMargin) : self.expectedMargin,
                #keyPath(Project.timezone) : self.timezone,
                #keyPath(Project.defaultTimezone) : self.defaultTimezone,
                #keyPath(Project.company) : self.company == nil ? "" : self.company!._id,
            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.code  = data[#keyPath(Project.code)] as! String
            self.name = data[#keyPath(Project.name)] as! String
            self.desc = data[#keyPath(Project.desc)] as! String
            self.status = data[#keyPath(Project.status)] as! String
            self.scheduleStartDate = toDate(data[#keyPath(Project.scheduleStartDate)])
            self.scheduleEndDate = toDate(data[#keyPath(Project.scheduleEndDate)])
            self.initialBudget = data[#keyPath(Project.initialBudget)] as! Double
            self.contingencyBudget = data[#keyPath(Project.contingencyBudget)] as! Double
            self.expectedMargin = data[#keyPath(Project.expectedMargin)] as! Double
            self.timezone = data[#keyPath(Project.timezone)] as! Double
            self.defaultTimezone = data[#keyPath(Project.defaultTimezone)] as! Double
            let dCompanyId = data[#keyPath(Project.company)] as! String
            self.company = dCompanyId == "" ? nil : DB.get(Company.self, dCompanyId) as? Company
            if (setIsSync) {
                self.system?.isSync = true
            }
        }
    }
}
