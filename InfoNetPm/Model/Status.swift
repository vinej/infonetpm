//
//  DbStat.swift
//  InfoNetPm
//
//  Created by jyv on 1/21/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//
import Foundation
import RealmSwift

public class Status: BaseRec {
    @objc dynamic var databaseVersion = 1
    @objc dynamic var lastSyncDate = dateMin()
    
    
    public override func encode() -> [String: Any] {
        return super.encode().merge(
            [
                #keyPath(Status.databaseVersion) : self.databaseVersion,
                #keyPath(Status.lastSyncDate) : self.lastSyncDate.str()
            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.databaseVersion = data[#keyPath(Status.databaseVersion)] as! Int
            self.lastSyncDate = toDate(data[#keyPath(Status.lastSyncDate)])
            
            if (setIsSync) {
                self.system?.isSync = true
            }
        }
    }
}
