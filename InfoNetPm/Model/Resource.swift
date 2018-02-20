//
//  Resource.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//  
import Foundation
import RealmSwift

public class Resource: BaseRec {
    @objc dynamic var code = ""
    @objc dynamic var lastName = ""
    @objc dynamic var firstName = ""
    @objc dynamic var initial = ""
    @objc dynamic var timeZone = 0.0
    @objc dynamic var cost = 0.0
    @objc dynamic var workHoursByWeek = 0.0
    @objc dynamic var workHoursByDay = 0.0
    @objc dynamic var email = ""
    @objc dynamic var telephone = ""
    @objc dynamic var address: Address? = Address()
    @objc dynamic var company: Company?
    
    public override func encode() -> [String: Any] {
        let address = self.address?.encode()
        return super.encode().merge([
            #keyPath(Resource.code) : self.code,
            #keyPath(Resource.lastName) : self.lastName,
            #keyPath(Resource.firstName) : self.firstName,
            #keyPath(Resource.initial) : self.initial,
            #keyPath(Resource.cost) : self.cost,
            #keyPath(Resource.workHoursByWeek) : self.workHoursByWeek,
            #keyPath(Resource.workHoursByDay) : self.workHoursByDay,
            #keyPath(Resource.email) : self.email,
            #keyPath(Resource.telephone) : self.telephone,
            #keyPath(Resource.address) : address!,
            #keyPath(Resource.company) : self.company == nil ? "" : self.company!._id,
        ])
    }
    
    public override func decode(_ data: [String: Any], _ setIsSync : Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            super.decode(data)
            self.address?.decode(data[#keyPath(Resource.address)] as! [String : Any] )
            self.code = data[#keyPath(Resource.code)] as! String
            self.lastName = data[#keyPath(Resource.lastName)] as! String
            self.firstName = data[#keyPath(Resource.firstName)] as! String
            self.initial = data[#keyPath(Resource.initial)] as! String
            self.cost = data[#keyPath(Resource.cost)] as! Double
            self.workHoursByWeek = data[#keyPath(Resource.workHoursByWeek)] as! Double
            self.workHoursByDay = data[#keyPath(Resource.workHoursByDay)] as! Double
            self.email = data[#keyPath(Resource.email)] as! String
            self.telephone = data[#keyPath(Resource.telephone)] as! String
            let dCompanyId = data[#keyPath(Resource.company)] as! String
            self.company = dCompanyId == "" ? nil : DB.get(Company.self, dCompanyId) as? Company

            if (setIsSync) {
                self.system?.isSync = true
            }
        }
    }
}
