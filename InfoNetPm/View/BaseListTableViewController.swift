//
//  BaseListTableViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2018-02-08.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//
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


class BaseListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    var list : [Any?] = []

    public func loadData() {
        //list = []
    }
    
    public func addMessage(message: Any?) {
        self.list.append(message)
        self.tableView.reloadData()
    }
    
    public func setInternalObject() throws {
        throw NSError(domain: "my error description", code: 01 )
    }
    
    func internalReloadData(_ forceLoad: Bool) {
        self.loadData()
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.internalReloadData(false)
    }
    
    override func viewDidLoad() {
        self.navigationController?.setToolbarHidden(false, animated: true)
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
}

