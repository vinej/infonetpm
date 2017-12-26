//
//  ChoosePlanViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-12-12.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwiftyBeaver

class ChoosePopupPlanViewController: BasePopupViewController {
    
    var currentPlan = ""
    var planList : Results<Object>? = nil
    static var isSecondOnChange = false
    
    override func setInternalObject(_ object : Object) {
        super.setInternalObject(object)
    }
    
    override func actionOnClose() {
        let storyboard: UIStoryboard = UIStoryboard(name: "DefineActivity", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
        let plan = DB.getObject(Plan.self, "code = %@", currentPlan) as! Plan
        vc.setPlan(plan)
        self.navigationController?.pushViewController(vc)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planList = DB.all(Plan.self)
        
        form +++ Section("Choose a plan to design")
            
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Plan"
                row.options = DB.getOptions(planList!, "code", "desc")
                row.value = ""
                row.selectorTitle = "Choose a plan to add activities"
                }.onChange { row in
                    if (PlanEditViewController.isSecondOnChange) {
                        PlanEditViewController.isSecondOnChange = false
                        return
                    }
                    if (row.value != nil && row.value != "" && row.value != DB.empty && row.value != DB.cancel)  {
                        self.currentPlan = row.value!
                    } else {
                        if (row.value == DB.empty) {
                            self.currentPlan = ""
                        }
                    }
                    row.value = self.currentPlan
            }
        
            <<< ButtonRow("OK") { (row: ButtonRow) in
                row.title = row.tag
                }
                .onCellSelection({ (cell, row) in
                    self.removeAnimate() })
    }
}


