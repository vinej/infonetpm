//
//  ShowPlanActivitiesViewController.swift
//  InfoNetPm
//
//  Created by jyv on 1/2/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwiftyBeaver

import Foundation
import UIKit
import RealmSwift

class ShowPlanActivitiesViewController: BaseShowTableViewController, InternalObjectProtocol {
    
    @IBAction func startedAtChanged(_ sender: Any) {
        let swStartedAt : UISwitch = sender as! UISwitch
        let indexPath = tableView.indexPathForSelectedRow
        let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath!)
        let swEndedAt = cell.contentView.viewWithTag(2) as! UISwitch
        
        if (swStartedAt.isOn) {
            if (self.currentObject != nil) {
                let activity = currentObject as! Activity
                let tmpAct = Activity()
                tmpAct.workFlow = "Started"
                tmpAct.status = "Running"
                tmpAct.startDate = Date()
                swEndedAt.isOn = true
                swEndedAt.isEnabled = true
                DB.updateRecord(activity, ["workFlow","startDate","status"], tmpAct)
            }
        }
        
        tableView.reloadData()
    }
    
    @IBAction func endedAtChanged(_ sender: Any) {
    }
    
    @IBAction func successChanged(_ sender: Any) {
    }
    
    override func setInternalObject() {
        self.objectType = Activity.self
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

        lblstatus.text = activity.status
        lblcode.text = activity.code
        lblduration.text = "\(activity.duration) min."
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
            swStartedAt.isEnabled = false
            lblEndedAt.text = "..."
            swEndedAt.isOn = false
            swEndedAt.isEnabled = true
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
        //let act = (list![indexPath.row] as! Activity)
        //cell.textLabel?.text = "\(act.code) : \(act.name )"
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.contentSize.height = 130
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
    }
}

