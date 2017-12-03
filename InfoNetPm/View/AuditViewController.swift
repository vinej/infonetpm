//
//  AuditViewController.swift
//  InfoNetPm
//
//  Created by jyv on 12/2/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AuditViewController: BaseTableViewController, InternalObjectProtocol {
    
    override func setInternalObject() {
        self.objectType = Audit.self
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath)
        
        let audit = (list![indexPath.row] as! Audit)
        if let theLabel0 = cell.viewWithTag(99) as? UILabel {
            theLabel0.text = "\(audit.auditAction) : \(audit.objectName) : \(audit.dateCreated) : : \(audit.userCreated)"
        }
        
        //cell.textLabel?.text = "\(audit.auditAction) : \(audit.objectName) : \(audit.dateCreated) : : \(audit.userCreated)"
        if let theLabel = cell.viewWithTag(100) as? UILabel {
            theLabel.text = audit.objectString
        }


        return cell
    }
}

