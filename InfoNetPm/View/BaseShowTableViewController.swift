//
//  BaseShowTableViewController.swift
//  InfoNetPm
//
//  Created by jyv on 1/2/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class BaseShowTableViewController: UITableViewController {
    
    var list : Results<Object>? = nil
    public var currentObject : Object? = nil
    
    var objectType = Object.self                  // dummy, must be overrided
    var objectName = #keyPath(Object.description) // dummy, must be overrided
    
    // must be overriden
    public func setInternalObject() throws {
        throw NSError(domain: "my error description", code: 01 )
    }
    
    public func loadData() {
        list = DB.all(self.objectType).sorted(byKeyPath: "updatedDate", ascending: false)
    }
    
    override func viewDidLoad() {
        do {
            try self.setInternalObject()
        }
        catch let error as NSError {
            log.debug("Caught NSError: \(error.localizedDescription), \(error.domain), \(error.code)")
            exit(01)
        }
        self.objectName = objectType.description().splitted(by : ".")[1]
        self.navigationController?.setToolbarHidden(false, animated: true)
        super.viewDidLoad()
        self.loadData()
        DB.setDirty(self.objectName, false)
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
    
    // use to set additionnal information to the object before editing
    func setDataBeforeEdit(_ object: Object) {
        //currentObject = object
        return
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentObject = self.list![(indexPath.row)]
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
}
