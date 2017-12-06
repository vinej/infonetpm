//
//  PlanEditViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-12-06.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//
import UIKit
import RealmSwift
import Eureka
import SwiftyBeaver

class PlanEditViewController: BaseEditViewController {
    
    @objc var plan : Plan? = nil
    var projectList : Results<Object>? = nil
    static var isSecondOnChange = false
    
    override func setInternalObject(_ object : Object) {
        super.setInternalObject(object)
        plan = object as? Plan
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        projectList = RealmHelper.all(Project.self)
        
        form +++ Section("Section Resoure")
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Status"
                row.options = [RealmHelper.empty,RealmHelper.cancel, "NotStarted","Started","OnHold", "Completed"]
                row.value = plan?.status
                row.selectorTitle = "Select the status"
                }.onChange { row in
                    if (row.value != "" && row.value != nil && row.value != RealmHelper.cancel && row.value != RealmHelper.empty) {
                        RealmHelper.update(self.plan!, #keyPath(Plan.status), row.value)
                        RealmHelper.setDirty(self.objectName, true)
                    } else {
                        // onChange will be called again
                        if (row.value == RealmHelper.empty) {
                            RealmHelper.update(self.plan!, #keyPath(Plan.status) , "")
                            RealmHelper.setDirty(self.objectName, true)
                        }
                        row.value = self.plan?.status
                    }
                }
            
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Plan"
                row.options = Project.getOptions(projectList!)
                row.value = plan?.project != nil ? plan?.project?.code : ""
                row.selectorTitle = "Choose a project"
                }.onChange { row in
                    if (PlanEditViewController.isSecondOnChange) {
                        PlanEditViewController.isSecondOnChange = false
                        return
                    }
                    if (row.value != nil && row.value != RealmHelper.empty && row.value != RealmHelper.cancel)  {
                        RealmHelper.saveProject(self.plan,Project.getProject(row.value!))
                        RealmHelper.setDirty(self.objectName, true)
                    } else {
                        if (row.value == RealmHelper.empty) {
                            RealmHelper.saveEmptyProject(self.plan!)
                            RealmHelper.setDirty(self.objectName, true)
                        }
                    }
                    // set the flag to not do twice the onChange
                    PlanEditViewController.isSecondOnChange = true
                    row.value = self.plan?.project != nil ? self.plan?.project?.code : ""
                }
            
            <<< TextRow(){ row in
                row.title = "Code"
                row.placeholder = "Code"
                row.value = plan?.code
                }.onChange { row in
                    RealmHelper.update(self.plan!, #keyPath(plan.code), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
            
            <<< TextRow(){ row in
                row.title = "Description"
                row.placeholder = "Description"
                row.value = plan?.desc
                }.onChange { row in
                    RealmHelper.update(self.plan!, #keyPath(Plan.desc), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
        
            <<< DecimalRow(){ row in
                row.title = "Time Zone"
                row.placeholder = "Time Zone"
                row.value = plan?.timezone == 0.0 ? nil : plan?.timezone
                }.onChange { row in
                    RealmHelper.update(self.plan!, #keyPath(Plan.timezone), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
            
            form +++ Section("Section Financial")
            
            <<< DecimalRow(){ row in
                row.title = "Initial Budget"
                row.placeholder = "Initial Budget"
                row.value = plan?.initialBudget == 0.0 ? nil : plan?.initialBudget
                }.onChange { row in
                    RealmHelper.update(self.plan!, #keyPath(Plan.initialBudget), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
            
            <<< DecimalRow(){ row in
                row.title = "Contingency Budget"
                row.placeholder = "Contingency Budget"
                row.value = plan?.contingencyBudget == 0.0 ? nil : plan?.contingencyBudget
                }.onChange { row in
                    RealmHelper.update(self.plan!, #keyPath(Plan.contingencyBudget), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
            
            <<< DecimalRow(){ row in
                row.title = "Expected Margin"
                row.placeholder = "Expected margin"
                row.value = plan?.expectedMargin == 0.0 ? nil : plan?.expectedMargin
                }.onChange { row in
                    RealmHelper.update(self.plan!, #keyPath(Plan.expectedMargin), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
            
            
            <<< DateTimeInlineRow(){ row in
                row.title = "Schedule Start Date"
                row.value = plan?.scheduleStartDate
                }.onChange { row in
                    RealmHelper.update(self.plan!, #keyPath(Plan.scheduleStartDate), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
            
            <<< DateTimeInlineRow(){ row in
                row.title = "Schedule End Date"
                row.value = plan?.scheduleEndDate
                }.onChange { row in
                    RealmHelper.update(self.plan!, #keyPath(Plan.scheduleEndDate), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
    }
}

