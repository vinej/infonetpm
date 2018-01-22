//
//  ChoosePopupLaunchPlan.swift
//  InfoNetPm
//
//  Created by jyv on 12/31/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import UIKit
import Eureka
import SwiftyBeaver
import RealmSwift

class ChoosePopupLaunchPlanViewController: BasePopupViewController {
    
    var currentPlan = ""
    var planList : Results<Object>? = nil
    var startDate = Date()
    static var isSecondOnChange = false
    
    override func setInternalObject(_ object : Object) {
        super.setInternalObject(object)
    }
    
    func actionOK() {
        if (currentPlan != "") {
            let plan = DB.getObject(Plan.self, "code = %@", currentPlan) as! Plan
            let fields : [String] = ["scheduleStartDate", "status"]
            let tmpPlan = Plan()
            tmpPlan.status = "Started"
            tmpPlan.scheduleStartDate = startDate
            DB.updateRecord(plan, fields, tmpPlan)
            let alert = UIAlertController(title: "Plan started!", message: "Enter the plan chat room to follow the activities", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                (_)in
                //self.view.removeFromSuperview()
                //self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "unwindToMenuFromLaunchPlan", sender: self)
            })
            
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "unwindToMenuFromLaunchPlan", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planList = DB.all(Plan.self)
        
        form +++ Section("Plan launcher")
            
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Choose a plan to launch"
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
            
            <<< DateTimeInlineRow(){ row in
                row.title = "Schedule Start Date"
                row.value = self.startDate
                }.onChange { row in
                    self.startDate = row.value!
            }
            
            <<< ButtonRow("OK") { (row: ButtonRow) in
                row.title = row.tag
                }
                .onCellSelection({ (cell, row) in
                    self.removeAnimate()
                    self.actionOK()
                })
    }
}

