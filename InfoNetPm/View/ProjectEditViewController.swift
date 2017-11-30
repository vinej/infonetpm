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

class ProjectEditViewController: BaseEditViewController {
    
    @objc var project : Project? = nil
    var projectName = "project"
    var companyList : Results<Object>? = nil
    
    override func setInternalObject(_ object : Object) {
        project = object as? Project
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyList = RealmHelper.all(Company.self)
        
        form +++ Section("Section Project")
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Company"
                row.options = RealmHelper.toSelection(companyList!, "name")
                row.value = project?.Company != nil ? project?.Company?.name : ""
                
                row.selectorTitle = "Choose a company"
                }.onChange { row in
                    if (row.value != "" && row.value != nil && row.value != RealmHelper.cancel && row.value != RealmHelper.empty) {
                        // get the index path (index - 1)
                        let svalue = row.value as! String ?? ""
                        let index = svalue.index(of: ":") ?? svalue.endIndex
                        let idx = Int(svalue[..<index])
                        let company = self.companyList![idx!] as! Company
                        
                        RealmHelper.update((self.project?.Company)!, #keyPath(project.Company), company)
                        RealmHelper.setDirty(#keyPath(project), true)
                    } else {
                        // onChange will be called again
                        if (row.value == RealmHelper.empty) {
                            RealmHelper.update((self.project?.Company)!, #keyPath(project.Company), "#nil#")
                        }
                        //row.value = self.company?.address?.country
                    }
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

