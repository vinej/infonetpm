//
//  PlanViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-12-06.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift

class PlanViewController: BaseTableViewController, InternalObjectProtocol {
    
    override func setInternalObject() {
        self.objectType = Plan.self
    }
    
    override func loadData() {
        list = DB.filter(self.objectType, "system.isDeleted  = %@", false).sorted(byKeyPath: "system.updatedDate", ascending: false)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath)
        
        let plan = (list![indexPath.row] as! Plan)
        cell.textLabel?.text = "\(plan.code) : \(plan.name)"
        
        return cell
    }
}


