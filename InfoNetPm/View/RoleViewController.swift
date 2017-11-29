//
//  RoleViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-11-29.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift

class RoleViewController: BaseTableViewController, InternalObjectProtocol {
    
    override func setInternalObject() {
        self.objectType = Role.self
        self.objectName = "role"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath)
        
        let role = (list![indexPath.row] as! Role)
        cell.textLabel?.text = "\(role.name) : \(role.rateByHour)"
        
        return cell
    }
}

