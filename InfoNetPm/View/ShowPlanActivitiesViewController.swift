//
//  ShowPlanActivitiesViewController.swift
//  InfoNetPm
//
//  Created by jyv on 1/2/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import UIKit
import Eureka
import SwiftyBeaver
import RealmSwift

class ShowPlanActivitiesViewController: BaseShowTableViewController, InternalObjectProtocol {
    var plan : Plan? = nil
    
    public func setPlan(_ plan : Plan) {
        self.plan = plan
        self.title = "Activities for plan : \(plan.code)"
    }
    
    override func setInternalObject() {
        self.objectType = Activity.self
    }
    
    override public func loadData() {
        list = DB.allByOrder(self.objectType, "plan.code = %@", (self.plan?.code)!)
    }
    
    @IBAction func startedAtChanged(_ sender: Any) {
        let swStartedAt : UISwitch = sender as! UISwitch
        let indexPath = tableView.indexPath(for: swStartedAt.superview?.superview as! UITableViewCell)

        let activity = list![(indexPath?.row)!] as! Activity
        let tmpAct = Activity()
        
        if (swStartedAt.isOn) {
            // create a history record to keep track of the time
            tmpAct.workFlow = "\(ActivityWorkflow.Started)"
            tmpAct.startDate = Date()
            DB.updateRecord(activity, [#keyPath(Activity.workFlow),
                                       #keyPath(Activity.startDate)], tmpAct)
            
            var ahist = ActivityHistory()
            ahist.startDate = activity.startDate
            ahist.endDate = activity.startDate  // same as start date, because we don't know the end date
            ahist.workFlow = tmpAct.workFlow    // current workflow
            ahist.duration = 0.0                // will be calculate later
            ahist.resourceStart = activity.resource
            ahist = DB.new(ActivityHistory.self, ahist) as! ActivityHistory
            DB.addSubObjectActivityHistory(Activity.self, activity, "activityHistory", ahist)
            
        } else {
            // a started workfow could be put on hold
            tmpAct.workFlow = "\(ActivityWorkflow.OnHold)"
            tmpAct.endDate = Date()
            // total duration since beginning
            tmpAct.totalDuration = activity.totalDuration + (tmpAct.endDate.timeIntervalSince(activity.startDate) / 60)
            DB.updateRecord(activity, [#keyPath(Activity.workFlow),
                                       #keyPath(Activity.endDate),
                                       #keyPath(Activity.totalDuration)
                ],tmpAct)
            
            // put the activity on hold, because it's not completed yet
            // update the history activity, the last one into the list
            let ahist = activity.activityHistory[activity.activityHistory.count - 1]
            let tmpHist = ActivityHistory()
            tmpHist.endDate = tmpAct.endDate
            tmpHist.duration = tmpAct.endDate.timeIntervalSince(activity.startDate) / 60
            tmpHist.workFlow = activity.workFlow
            tmpHist.resourceEnd = activity.resource
            DB.updateRecord(ahist, [#keyPath(ActivityHistory.endDate),
                                    #keyPath(ActivityHistory.duration),
                                    #keyPath(ActivityHistory.workFlow),
                                    #keyPath(ActivityHistory.resourceEnd),
                                    ], tmpHist)
        }
        tableView.reloadData()
    }
    

    @IBAction func endedAtChanged(_ sender: Any) {
    }
    
    @IBAction func successChanged(_ sender: Any) {
    }

    func configureCell(_ cell : UITableViewCell, _ row: Int) {
        let swStartedAt = cell.contentView.viewWithTag(1) as! UISwitch
        let swEndedAt = cell.contentView.viewWithTag(2) as! UISwitch
        let segSuccess = cell.contentView.viewWithTag(3) as! UISegmentedControl
        
        let lblStartedAt = cell.contentView.viewWithTag(4) as! UILabel
        let lblEndedAt = cell.contentView.viewWithTag(5) as! UILabel

        let lblstatus = cell.contentView.viewWithTag(6) as! UILabel
        let lblcode = cell.contentView.viewWithTag(7) as! UILabel
        let lblduration = cell.contentView.viewWithTag(9) as! UILabel
        let lblrole = cell.contentView.viewWithTag(10) as! UILabel

        let lblres = cell.contentView.viewWithTag(11) as! UILabel
        let activity = list![row] as! Activity

        lblstatus.text = activity.workFlow
        lblcode.text = activity.code
        lblduration.text = "\(activity.totalDuration) min."
        lblrole.text = activity.role?.name
        lblres.text = activity.resource?.code
        
        switch activity.workFlow {
        case "NotStarted":
            lblStartedAt.text = "..."
            swStartedAt.isOn = false
            swStartedAt.isEnabled = true
            lblEndedAt.text = "..."
            swEndedAt.isOn = false
            swEndedAt.isEnabled = false
            segSuccess.isEnabled = false
            segSuccess.setEnabled(false, forSegmentAt: 0)
            segSuccess.setEnabled(false, forSegmentAt: 1)
        case "Started":
            lblStartedAt.text = "\(activity.startDate)"
            swStartedAt.isOn = true
            swStartedAt.isEnabled = true
            lblEndedAt.text = "..."
            swEndedAt.isOn = false
            swEndedAt.isEnabled = true
            segSuccess.isEnabled = false
            segSuccess.setEnabled(false, forSegmentAt: 0)
            segSuccess.setEnabled(false, forSegmentAt: 1)
        case "OnHold":
            lblStartedAt.text = ""
            swStartedAt.isOn = false
            swStartedAt.isEnabled = true
            lblEndedAt.text = "\(activity.endDate)"
            swEndedAt.isOn = false
            swEndedAt.isEnabled = false
            segSuccess.isEnabled = false
            segSuccess.setEnabled(false, forSegmentAt: 0)
            segSuccess.setEnabled(false, forSegmentAt: 1)
        case "Completed":
            lblStartedAt.text = "\(activity.startDate)"
            swStartedAt.isOn = true
            swStartedAt.isEnabled = false
            lblEndedAt.text = "\(activity.endDate)"
            swEndedAt.isOn = true
            swEndedAt.isEnabled = false
            segSuccess.isEnabled = false
            segSuccess.setEnabled(false, forSegmentAt: 0)
            segSuccess.setEnabled(false, forSegmentAt: 1)
        default:
            lblStartedAt.text = "..."
            swStartedAt.isOn = false
            swStartedAt.isEnabled = true
            lblEndedAt.text = "..."
            swEndedAt.isOn = false
            swEndedAt.isEnabled = false
            segSuccess.isEnabled = false
            segSuccess.setEnabled(false, forSegmentAt: 0)
            segSuccess.setEnabled(false, forSegmentAt: 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath)
        
        configureCell(cell, indexPath.row)
        //setUnSelectedCell(cell, indexPath.row)
        
        return cell
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.contentSize.height = 130
    }
}

