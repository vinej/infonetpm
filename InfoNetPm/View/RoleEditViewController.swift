//
//  RoleEditViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-11-29.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwiftyBeaver

class RoleEditViewController: BaseEditViewController {
    
    @objc var role : Role? = nil
    var roleName = "role"
    
    override func setInternalObject(_ object : Object) {
        role = object as? Role
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Section Role")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Role name"
                row.value = role?.name
                }.onChange { row in
                    RealmHelper.update(self.role!, #keyPath(Role.name), row.value)
                    RealmHelper.setDirty(#keyPath(role), true)
                }
            
            <<< TextRow(){ row in
                row.title = "Description"
                row.placeholder = "Role description"
                row.value = role?.desc
                }.onChange { row in
                    RealmHelper.update(self.role!, #keyPath(Role.desc), row.value)
                    RealmHelper.setDirty(#keyPath(role), true)
                }
        
            <<< DecimalRow(){ row in
                row.title = "Rate by hour"
                row.placeholder = "Rate by hour"
                row.value = role?.rateByHour == 0 ? nil : role?.rateByHour
                }.onChange { row in
                    RealmHelper.update(self.role!, #keyPath(Role.rateByHour), row.value)
                    RealmHelper.setDirty(#keyPath(role), true)
                }
        
            <<< DecimalRow(){ row in
                row.title = "Expected cost by hour"
                row.placeholder = "Expected cost by hour"
                row.value = role?.expectedCostByHour == 0 ? nil : role?.expectedCostByHour
                }.onChange { row in
                    RealmHelper.update(self.role!, #keyPath(Role.expectedCostByHour), row.value)
                    RealmHelper.setDirty(#keyPath(role), true)
                }
    }
}


