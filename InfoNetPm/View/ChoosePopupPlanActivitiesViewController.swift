//
//  ChoosePopupPlanActivities.swift
//  InfoNetPm
//
//  Created by jyv on 1/21/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwiftyBeaver

class ChoosePopupPlanActivitesViewController: ChoosePopupBasePlanViewController {
    
    override func actionOnClose() {
        
        if (currentPlan != "") {
            let plan = DB.getObject(Plan.self, "code = %@", currentPlan) as! Plan
            let storyboard: UIStoryboard = UIStoryboard(name: "DrivePlan", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ShowPlanActivitiesViewController") as! ShowPlanActivitiesViewController
            vc.setPlan(plan)
            self.navigationController?.pushViewController(vc)
        }
    }
}

