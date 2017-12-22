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
        let storyboard: UIStoryboard = UIStoryboard(name: "DesignPlan", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ActivityViewController") as! ActivityViewController
        vc.title = "Design Plan: \(currentPlan)"
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
                row.selectorTitle = "Choose a plan to design"
                }.onChange { row in
                    if (PlanEditViewController.isSecondOnChange) {
                        PlanEditViewController.isSecondOnChange = false
                        return
                    }
                    if (row.value != nil && row.value != DB.empty && row.value != DB.cancel)  {
                        self.currentPlan = row.value!
                    } else {
                        if (row.value == DB.empty) {
                            self.currentPlan = ""
                        }
                    }
                    // set the flag to not do twice the onChange
                    PlanEditViewController.isSecondOnChange = true
                    row.value = self.currentPlan
            }
        
            <<< ButtonRow("Design/Review a plan") { (row: ButtonRow) in
                row.title = row.tag
                }
                .onCellSelection({ (cell, row) in
                    self.removeAnimate() })
    }
}


