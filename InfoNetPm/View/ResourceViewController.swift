//
//  ResourceViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-12-01.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ResourceViewController: BaseTableViewController, InternalObjectProtocol {

    override func setInternalObject() {
        self.objectType = Resource.self
        self.objectName = "resource"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "edit", for: indexPath)
        
        let resource = (list![indexPath.row] as! Resource)
        cell.textLabel?.text = "\(resource.lastName), \(resource.firstName )"
        
        return cell
    }

}
