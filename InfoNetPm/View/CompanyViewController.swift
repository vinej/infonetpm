//
//  CompanyTableViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-11-27.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class CompanyViewController: BaseTableViewController, InternalObjectProtocol {
    
    override func setInternalObject() {
        self.objectType = Company.self
        self.objectName = "company"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath)

        let cie = (list![indexPath.row] as! Company)
        cell.textLabel?.text = "\(cie.name) : \(cie.address?.email ?? "")"
    
        return cell
    }
}
