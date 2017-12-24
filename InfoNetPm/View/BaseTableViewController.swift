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
            list = DB.all(self.objectType).sorted(byKeyPath: "order", ascending: true)
            //list = DB.all(self.objectType)
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
            if (DB.isDirty(self.objectName)) {
                list = DB.all(self.objectType)
                self.tableView.reloadData()
                DB.setDirty(self.objectName, false)
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
    
        override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            let objS = (list![sourceIndexPath.row] )
            var objDNext : Object? = nil
            if (destinationIndexPath.row == (list?.count)! - 1) {
                objDNext = nil
            } else {
                objDNext = (list![destinationIndexPath.row + 1] )
            }
            let objD = (list![destinationIndexPath.row] )
            DB.changedOrder(objS, objD, objDNext)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let theDestination = (segue.destination as! BaseEditViewController)
            if (segue.identifier?.starts(with: "segueEdit"))! {
                let indexPath = tableView.indexPathForSelectedRow
                theDestination.setInternalObject(self.list![(indexPath?.row)!])
            } else {
                DB.setDirty(objectName, true)
                theDestination.setInternalObject((DB.new(self.objectType.init()) ))
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
                DB.del(list![indexPath.row])
                list = DB.all(objectType)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
}

