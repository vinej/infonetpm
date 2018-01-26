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
        var currentObject : Object? = nil
    
        var objectType = Object.self                  // dummy, must be overrided
        var objectName = #keyPath(Object.description) // dummy, must be overrided
    
        // must be overriden
        public func setInternalObject() throws {
            throw NSError(domain: "my error description", code: 01 )
        }
    
        public func loadData() {
            list = DB.filter(self.objectType, "isDeleted = %@", false).sorted(byKeyPath: "updatedDate", ascending: false)
        }
    
        func internalReloadData(_ forceLoad: Bool) {
            if (DB.isDirty(self.objectName) || forceLoad) {
                self.loadData()
                self.tableView.reloadData()
                DB.setDirty(self.objectName, false)
            }
        }
    
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            self.internalReloadData(false)
        }
    
        override func viewDidLoad() {
            do {
                try self.setInternalObject()
            }
            catch let error as NSError {
                log.debug("Caught NSError: \(error.localizedDescription), \(error.domain), \(error.code)")
                exit(01)
            }
            self.objectName = BaseRec.objectName(objectType)
            self.navigationController?.setToolbarHidden(false, animated: true)
            super.viewDidLoad()
            self.internalReloadData(true)
        }
        
        // return from a view, the load is not launch, so reload on dirty
        
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
            var objD : Object?
            var objDNext: Object?
            
            // if order of src < order of dest, we must put the row after the destination
            if (sourceIndexPath.row < destinationIndexPath.row) {
                // the src is moved after the last row, so the next is nil
                objD = (list![destinationIndexPath.row])
                if (destinationIndexPath.row == list!.count - 1) {
                    objDNext = nil
                } else {
                    objDNext = (list![destinationIndexPath.row + 1] )
                }
            }
            // if the order of > order of dest, we must put the roe before the destination
            else {
                objDNext = (list![destinationIndexPath.row] )
                if (destinationIndexPath.row == 0) {
                    objD = nil
                } else {
                    objD = (list![destinationIndexPath.row - 1] )
                }
            }
            DB.changedOrder(Activity.self, objS, objD, objDNext)
            // relad the list, because the order changed
            self.internalReloadData(true)
        }
    
        // use to set additionnal information to the object before editing
        func setDataBeforeEdit(_ object: Object) {
            currentObject = object
            return
        }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let theDestination = (segue.destination as! BaseEditViewController)
            if (segue.identifier?.starts(with: "segueEdit"))! {
                let indexPath = tableView.indexPathForSelectedRow
                let currentObj = self.list![(indexPath?.row)!]
                self.setDataBeforeEdit(currentObj);
                theDestination.setInternalObject(currentObj)
            } else {
                DB.setDirty(objectName, true)
                let currentObj = DB.new(self.objectType, self.objectType.init())
                self.setDataBeforeEdit(currentObj)
                theDestination.setInternalObject(currentObj)
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
                self.loadData()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
}

