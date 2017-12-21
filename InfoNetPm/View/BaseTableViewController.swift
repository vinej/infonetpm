//
//  BaseTableViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-11-28.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol InternalObjectProtocol {
    func setInternalObject()
}

class BaseTableViewController: UITableViewController {

        var list : Results<Object>? = nil
        var objectType = Object.self                  // dummy, must be overrided
        var objectName = #keyPath(Object.description) // dummy, must be overrided
    
        // must be overriden
        public func setInternalObject() throws {
            throw NSError(domain: "my error description", code: 01 )
        }
    
        public func loadData() {
            list = RealmHelper.all(self.objectType)
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            do {
                try self.setInternalObject()
            }
            catch let error as NSError {
                log.debug("Caught NSError: \(error.localizedDescription), \(error.domain), \(error.code)")
                exit(01)
            }
            self.objectName = objectType.description().splitted(by : ".")[1]
            self.navigationController?.setToolbarHidden(false, animated: true)
            self.loadData()
        }
        
        // return from a view, the load is not launch, so reload on dirty
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if (RealmHelper.isDirty(self.objectName)) {
                list = RealmHelper.all(self.objectType)
                self.tableView.reloadData()
                RealmHelper.setDirty(self.objectName, false)
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return list!.count
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let theDestination = (segue.destination as! BaseEditViewController)
            if (segue.identifier?.starts(with: "segueEdit"))! {
                let indexPath = tableView.indexPathForSelectedRow
                theDestination.setInternalObject(self.list![(indexPath?.row)!])
            } else {
                RealmHelper.setDirty(objectName, true)
                theDestination.setInternalObject((RealmHelper.new(self.objectType.init()) ))
            }
        }
        
        // Override to support conditional editing of the table view.
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
        
        // Override to support editing the table view.
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // Delete the row from the data source
                RealmHelper.del(list![indexPath.row])
                list = RealmHelper.all(objectType)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
}

