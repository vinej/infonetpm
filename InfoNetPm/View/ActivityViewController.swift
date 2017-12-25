//
//  ActivityViewController.swift
//  InfoNetPm
//
//  Created by jyv on 12/22/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ActivityViewController: BaseTableViewController, InternalObjectProtocol {
    
    @IBOutlet var btnDone: UIBarButtonItem!
    @IBOutlet var btnEdit: UIBarButtonItem!
    
    @IBAction func setEditMode(_ sender: Any) {
        self.tableView.isEditing =  true
        btnEdit.isEnabled = false
        btnDone.isEnabled = true
    }
    @IBAction func SetStandardMode(_ sender: Any) {
        self.tableView.isEditing = false
        btnEdit.isEnabled = true
        btnDone.isEnabled = false
    }
    
    override public func loadData() {
        list = DB.allByOrder(self.objectType)
    }

    override func setInternalObject() {
        self.objectType = Activity.self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath)
        
        let act = (list![indexPath.row] as! Activity)
        cell.textLabel?.text = "\(act.code) : \(act.order) : \(act.duration)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

