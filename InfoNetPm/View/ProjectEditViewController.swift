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
    var projectName = "project"
    var companyList : Results<Object>? = nil
    static var isSecondOnChange = false
    
    override func setInternalObject(_ object : Object) {
        project = object as? Project
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyList = RealmHelper.all(Company.self)
        
        form +++ Section("Section Project")
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
                        Project.saveCompany(self.project!, Company.getCompany(row.value!))
                        RealmHelper.setDirty(#keyPath(project), true)
                     } else {
                        if (row.value == RealmHelper.empty) {
                            Project.saveEmptyCompany(self.project!)
                            RealmHelper.setDirty(#keyPath(project), true)
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
                    RealmHelper.setDirty(#keyPath(project), true)
                }
        
            <<< TextAreaRow(){ row in
                row.title = "Description"
                row.placeholder = "Project description"
                row.value = project?.desc
                }.onChange { row in
                    RealmHelper.update(self.project!, #keyPath(Project.desc), row.value)
                    RealmHelper.setDirty(#keyPath(project), true)
                }

    }
}

