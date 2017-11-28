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
    
    override func setInternalObject(_ object : Object) {
        project = object as? Project
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Section Project")
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

