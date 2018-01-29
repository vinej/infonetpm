//
//  Issue.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

import Foundation
import RealmSwift

public class Issue: BaseRec {
    @objc dynamic var status = "not started" //
    @objc dynamic var task : Task?
    
    @objc dynamic var title = ""
    @objc dynamic var desc = ""
    @objc dynamic var type = ""
    @objc dynamic var severity = ""
    //@objc dynamic var document : Document?
    //@objc dynamic var comment : Comment?
    
    public override func encode() -> [String: Any] {
        return super.encode().merge(
            [
                #keyPath(Issue.title) : self.title,
                #keyPath(Issue.desc) : self.desc,
                #keyPath(Issue.type) : self.type,
                #keyPath(Issue.severity) : self.severity,
            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.title  = data[#keyPath(Issue.title)] as! String
            self.desc = data[#keyPath(Issue.desc)] as! String
            self.type = data[#keyPath(Issue.type)] as! String
            self.severity = data[#keyPath(Issue.severity)] as! String

            if (isSync) {
                self.isSync = true
            }
        }
    }
}
