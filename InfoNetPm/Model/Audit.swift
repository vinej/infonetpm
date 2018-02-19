//
//  Audit.swift
//  InfoNetPm
//
//  Created by jyv on 12/2/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//
import Foundation
import RealmSwift


// Define your models like regular Swift classes
public class Audit: BaseRec {
    @objc dynamic var objectId = ""
    @objc dynamic var objectName = ""
    @objc dynamic var objectDate = Date()
    @objc dynamic var auditAction = ""
    @objc dynamic var objectString = ""
    
    public override func encode() -> [String: Any] {
        return super.encode().merge(
            [
                #keyPath(Audit.objectId) : self.objectId,
                #keyPath(Audit.objectName) : self.objectName,
                #keyPath(Audit.objectDate) : self.objectDate.str(),
                #keyPath(Audit.auditAction) : self.auditAction,
                #keyPath(Audit.objectString) : self.objectString
            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.objectId  = data[#keyPath(Audit.objectId)] as! String
            self.objectName  = data[#keyPath(Audit.objectName)] as! String
            self.objectDate = toDate(data[#keyPath(Audit.objectDate)])
            self.objectString = data[#keyPath(Audit.objectString)] as! String
            
            if (setIsSync) {
                self.system?.isSync = true
            }
        }
    }
}
