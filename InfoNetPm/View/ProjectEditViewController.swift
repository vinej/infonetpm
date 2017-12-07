//
//  ProjectEditViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-11-28.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Eureka
import SwifterSwift

class ProjectEditViewController: BaseEditViewController {
    
    @objc var project : Project? = nil
    var companyList : Results<Object>? = nil
    static var isSecondOnChange = false
    
    override func setInternalObject(_ object : Object) {
        super.setInternalObject(object)
        project = object as? Project
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyList = RealmHelper.all(Company.self)
        
        form +++ Section("Section Project")
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Status"
                row.options = [RealmHelper.empty,RealmHelper.cancel, "NotStarted","Started","OnHold", "Completed"]
                row.value = project?.status
                row.selectorTitle = "Select the status"
                }.onChange { row in
                    if (row.value != "" && row.value != nil && row.value != RealmHelper.cancel && row.value != RealmHelper.empty) {
                        RealmHelper.update(self.project!, #keyPath(Project.status), row.value)
                        RealmHelper.setDirty(self.objectName, true)
                    } else {
                        // onChange will be called again
                        if (row.value == RealmHelper.empty) {
                            RealmHelper.update(self.project!, #keyPath(Project.status) , "")
                            RealmHelper.setDirty(self.objectName, true)
                        }
                        row.value = self.project?.status
                    }
            }
            
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Company"
                row.options = Company.getOptions(companyList!)
                row.value = project?.company != nil ? project?.company?.name : ""
                row.selectorTitle = "Choose a company"
                }.onChange { row in
                    if (ProjectEditViewController.isSecondOnChange) {
                        ProjectEditViewController.isSecondOnChange = false
                        return
                    }
                    if (row.value != nil && row.value != RealmHelper.empty && row.value != RealmHelper.cancel)  {
                        RealmHelper.saveChildObject(self.project, Company.getCompany(row.value!))
                        RealmHelper.setDirty(self.objectName, true)
                     } else {
                        if (row.value == RealmHelper.empty) {
                            RealmHelper.saveEmptyChildObject(self.project!, "company")
                            RealmHelper.setDirty(self.objectName, true)
                        }
                    }
                    // set the flag to not do twice the onChange
                    ProjectEditViewController.isSecondOnChange = true
                    row.value = self.project?.company != nil ? self.project?.company?.name : ""
                }
            
            
            <<< TextRow(){ row in
                row.title = "Code"
                row.placeholder = "Project code"
                row.value = project?.code
                }.onChange { row in
                    RealmHelper.update(self.project!, #keyPath(Project.code), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
        
            <<< TextAreaRow(){ row in
                row.title = "Description"
                row.placeholder = "Project description"
                row.value = project?.desc
                }.onChange { row in
                    RealmHelper.update(self.project!, #keyPath(Project.desc), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
        
            <<< DecimalRow(){ row in
                row.title = "Time Zone"
                row.placeholder = "Time Zone"
                row.value = project?.timezone == 0 ? nil : project?.timezone
                }.onChange { row in
                    RealmHelper.update(self.project!, #keyPath(Project.timezone), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
        
            form +++ Section("Section Financial")
            
            <<< DecimalRow(){ row in
                row.title = "Initial Budget"
                row.placeholder = "Initial Budget"
                row.value = project?.initialBudget == 0 ? nil : project?.initialBudget
                }.onChange { row in
                    RealmHelper.update(self.project!, #keyPath(Project.initialBudget), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
            
            <<< DecimalRow(){ row in
                row.title = "Contingency Budget"
                row.placeholder = "Contingency Budget"
                row.value = project?.contingencyBudget == 0 ? nil : project?.contingencyBudget
                }.onChange { row in
                    RealmHelper.update(self.project!, #keyPath(Project.contingencyBudget), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
            
            <<< DecimalRow(){ row in
                row.title = "Expected Margin"
                row.placeholder = "Expected margin"
                row.value = project?.expectedMargin == 0 ? nil : project?.expectedMargin
                }.onChange { row in
                    RealmHelper.update(self.project!, #keyPath(Project.expectedMargin), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
            
            <<< DateTimeInlineRow(){ row in
                row.title = "Schedule Start Date"
                row.value = project?.scheduleStartDate
                }.onChange { row in
                    RealmHelper.update(self.project!, #keyPath(Project.scheduleStartDate), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
        
            <<< DateTimeInlineRow(){ row in
                row.title = "Schedule End Date"
                row.value = project?.scheduleEndDate
                }.onChange { row in
                    RealmHelper.update(self.project!, #keyPath(Project.scheduleEndDate), row.value)
                    RealmHelper.setDirty(self.objectName, true)
                }
    }
}

