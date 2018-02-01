//
//  Comment.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//
import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class Comment: BaseRec {
    @objc dynamic var name = ""
    
    public override func encode() -> [String: Any] {
        return super.encode().merge(
            [
                #keyPath(Comment.name) : self.name,

            ]
        )
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.name                     = data[#keyPath(Comment.name)] as! String
            
            if (isSync) {
                self.isSync = true
            }
        }
    }
}

