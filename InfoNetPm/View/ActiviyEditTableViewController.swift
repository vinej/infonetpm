//
//  ActiviyEditTableViewController.swift
//  InfoNetPm
//
//  Created by jyv on 12/22/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//
import UIKit
import Eureka
import SwiftyBeaver
import RealmSwift


class ActivityEditViewController: BaseEditViewController {
    @objc var activity : Activity? = nil
    var roleList : Results<Object>? = nil
    var ressourceList : Results<Object>? = nil
    
    override func setInternalObject(_ object : Object) {
        super.setInternalObject(object)
        activity = object as? Activity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roleList = DB.all(Role.self)
        ressourceList = DB.filter(Resource.self, "system.isDeleted = %@", false)
        
        form +++ Section("Section Activity")
            <<< TextRow(){ row in
                row.title = "Code"
                row.placeholder = "Activity Code"
                row.value = activity?.code
                }.onChange { row in
                    DB.update(self.activity!, #keyPath(Activity.code), row.value)
            }
            
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Activity Name"
                row.value = activity?.name
                }.onChange { row in
                    DB.update(self.activity!, #keyPath(Activity.name), row.value)
            }
        
            <<< DecimalRow(){ row in
                row.title = "Duration in minute"
                row.value = activity?.expectedDuration
                row.placeholder = "Expected Duration of the activity"
                }.onChange { row in
                    DB.update(self.activity!, #keyPath(Activity.expectedDuration), row.value)
            }
        
            form +++ Section("Ressources")
        
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Role"
                row.options = DB.getOptions(roleList!, "name", "desc")
                row.value = activity?.role != nil ? activity?.role?.name : ""
                row.selectorTitle = "Choose a role"
                }.onChange { row in
                    if (ProjectEditViewController.isSecondOnChange) {
                        ProjectEditViewController.isSecondOnChange = false
                        return
                    }
                    if (row.value != nil && row.value != DB.empty && row.value != DB.cancel)  {
                        DB.saveChildObject(self.activity, DB.getObject(Role.self, "name = %@", row.value!))
                    } else {
                        if (row.value == DB.empty) {
                            DB.saveEmptyChildObject(self.activity!, "role")
                        }
                    }
                    // set the flag to not do twice the onChange
                    ProjectEditViewController.isSecondOnChange = true
                    row.value = self.activity?.role != nil ? self.activity?.role?.name : ""
            }
        
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Resource"
                row.options = DB.getOptions(ressourceList!, "code", "lastName", "firstName")
                row.value = activity?.resource != nil ? activity?.resource?.code : ""
                row.selectorTitle = "Choose a resource"
                }.onChange { row in
                    if (ProjectEditViewController.isSecondOnChange) {
                        ProjectEditViewController.isSecondOnChange = false
                        return
                    }
                    if (row.value != nil && row.value != DB.empty && row.value != DB.cancel)  {
                        DB.saveChildObject(self.activity, DB.getObject(Resource.self, "code = %@", row.value!))
                    } else {
                        if (row.value == DB.empty) {
                            DB.saveEmptyChildObject(self.activity!, "resource")
                        }
                    }
                    // set the flag to not do twice the onChange
                    ProjectEditViewController.isSecondOnChange = true
                    row.value = self.activity?.resource != nil ? self.activity?.resource?.code : ""
                }
        
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Backup Resource"
                row.options = DB.getOptions(ressourceList!, "code", "lastName", "firstName")
                row.value = activity?.backupResource != nil ? activity?.backupResource?.code : ""
                row.selectorTitle = "Choose a resource"
                }.onChange { row in
                    if (ProjectEditViewController.isSecondOnChange) {
                        ProjectEditViewController.isSecondOnChange = false
                        return
                    }
                    if (row.value != nil && row.value != DB.empty && row.value != DB.cancel)  {
                        DB.saveChildObject("backupResource", self.activity, DB.getObject(Resource.self, "code = %@", row.value!))
                    } else {
                        if (row.value == DB.empty) {
                            DB.saveEmptyChildObject(self.activity!, "backupResource")
                        }
                    }
                    // set the flag to not do twice the onChange
                    ProjectEditViewController.isSecondOnChange = true
                    row.value = self.activity?.backupResource != nil ? self.activity?.backupResource?.code : ""
        }
    }
}



