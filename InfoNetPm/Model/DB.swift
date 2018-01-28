//
//  RealmHelper.swift
//  D3Plan
//
//  Created by jyv on 11/25/17.
//  Copyright © 2017 infonetjyv. All rights reserved.
//

/*: DB: Static Database Class
 

 */
import Foundation
import RealmSwift

public enum AuditAction {
    case Del
    case New
    case Update
}

public class DB {    
    /* to deal with Audit when the user quit the application */
    public static var objectDirtyArray = [String: Bool]()
    public static var lastObject : Object? = nil
    public static var lastObjectName = "not set"
    public static var lastObjectDate = Date()
    public static let fieldAuditSeperator = "|"
    
    @objc dynamic var order = 0.0
    public static let  CREATE_BY = "createdBy"
    public static let  CREATE_DATE = "createdDate"
    public static let  UPDATE_BY = "updatedBy"
    public static let  UPDATE_DATE = "updatedDate"
    public static let  VERSION = "version"
    public static let  ORDER = "order"
    public static let  IS_SYNC = "isSync"
    public static let  IS_NEW = "isNew"
    public static let  IS_DELETED = "isDeleted"

    public static let orderIncrement = 10.0 // default increment for order field
    /*************/
    
    /* dirty flag for syncho */
    public static var isNeedSynchronization = false

    public static func isDirty( _ objectName : String) -> Bool {
        return objectDirtyArray[objectName] != nil ? objectDirtyArray[objectName]! : false
    }
    
    public static func setDirty( _ objectName : String, _ value : Bool) {
        objectDirtyArray[objectName] = value
        DB.isNeedSynchronization = true
    }
    /*************/
    
    /* PickList options */
    public static let cancel = "<CANCEL>"   // picklist CANCEL option
    public static let empty = "<CLEAR>"     // picllist CLEAR field option
    // list of default selection to add to a pick list
    public static let defaultSelection : [String] = [DB.empty,DB.cancel]
    /*************/

    public static func addSubObjectActivityHistory<T>(_ objectType : T.Type,_ object: Object, _ subObjectName : String, _ subObject : Object, _ isSetDirty: Bool = true) {
        let realm = try! Realm()
        
        try! realm.write {
            let tmp = object[subObjectName] as! List<ActivityHistory>
            tmp.append(subObject as! ActivityHistory)
            if (isSetDirty) {
                DB.setDirty("\(type(of: object))", true)
            }
        }
    }
    
    public static func all<T>(_ object : T.Type) ->  Results<Object> {
        let realm = try! Realm()
        return realm.objects(object.self as! Object.Type)
    }
    
    // get all record order by the order field
    public static func allByOrder<T>(_ object : T.Type) ->  Results<Object> {
        let realm = try! Realm()
        return realm.objects(object.self as! Object.Type).sorted(byKeyPath: "order", ascending: true)
    }
    
    public static func allByOrder<T>(_ object : T.Type, _ field : String, _ filter: String) ->  Results<Object> {
        let realm = try! Realm()
        return realm.objects(object.self as! Object.Type).filter(field, filter ).sorted(byKeyPath: "order", ascending: true)
    }
    
    public static func audit(_ object : Object, _ date: Date) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(DB.getAudit(object, AuditAction.Update, date))
        }
    }
    
    public static func changedOrder<T>(_ objectType : T.Type, _ src : Object, _ dest : Object?, _ destNext : Object?, _ isSetDirty : Bool = true) {
        let realm = try! Realm()
        var orderDest = 0.0
        var orderDestNext = 0.0
        
        if (dest == nil) {
            // the src is moved befor the first row
            orderDest = 0.0
            orderDestNext = (destNext![ORDER] as! Double)
        } else if (destNext == nil) {
            // the src is moved after the last row
            orderDest = (dest![ORDER] as! Double)
            orderDestNext = DB.getNextOrder(objectType)
        } else {
            // the src is moved between 2 existing rows
            orderDest = (dest![ORDER] as! Double)
            orderDestNext = (destNext![ORDER] as! Double)
        }
        
        try! realm.write {
            // find the middle between the previous row and the next row,
            src[ORDER] = (orderDestNext - orderDest) / 2.0 + orderDest
            if (isSetDirty) {
                DB.setDirty("\(type(of: src))", true)
            }
        }
        
        if (isSetDirty) {
            DB.setDirty("\(type(of: src))", true)
        }
        DB.audit(src, Date())
        DB.lastObject = nil
    }

    
    public static func count<T>(_ object : T.Type) ->  Int {
        let realm = try! Realm()
        return realm.objects(object.self as! Object.Type).count
    }
    
    public static func del(_ object : Object, _ isSetDirty : Bool = true) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(DB.getAudit(object, AuditAction.Del, Date()))
            if (object[IS_NEW] as! Bool == true) {
                // the object has been created by the current user, so physical delete is possible
                realm.delete(object)
            } else {
                // soft delete needed to synchronize with the server
                DB.setField(object, "isDeleted", true)
                updateInternalFields(object)
            }
            if (isSetDirty) {
                DB.setDirty("\(type(of: object))", true)
            }
        }
    }
    
    public static func filter<T>(_ object : T.Type, _ field : String, _ filter: Any) ->  Results<Object> {
        let realm = try! Realm()
        return realm.objects(object.self as! Object.Type).filter(field, filter )
    }
    
    public static func get<T>(_ objectType : T.Type, _ id : String) -> BaseRec? {
        let records = DB.filter(objectType, "id = %@", id)
        if (records.count == 0) {
            return nil
        } else {
            return records.first as? BaseRec
        }
    }
    
    public static func getAudit(_ object : Object, _ auditAction: AuditAction, _ date : Date) -> Audit
    {
        // transaction must be created by the caller
        let audit = Audit()
        audit.createdDate = Date.init(timeIntervalSinceNow: 0)
        audit.createdBy = NSUserName()
        audit.auditAction = "\(auditAction)"
        audit.objectName = "\(type(of: object))"
        audit.objectId = object["id"] as! String
        audit.objectString = object.description.replacingOccurrences(of: "\n\t", with: fieldAuditSeperator)
        return audit
    }
    
    public static func getNextOrder<T>(_ objectType : T.Type) -> Double {
        let realm = try! Realm()
        var nextOrder = 0.0
        let order : Order
        if (DB.count(Order.self) == 0) {
            order = DB.new(Order.self, Order()) as! Order
        } else {
            order = DB.all(Order.self).first as! Order
        }
        
        try! realm.write {
            let objectName = "\(objectType)".lowercased()
            nextOrder = order[objectName] as! Double
            order[objectName] = nextOrder + DB.orderIncrement
        }
        return nextOrder
    }
    
    public static func getOptions(_ list : Results<Object>, _ code:  String = "code", _ name : String = "name", _ name2 : String = "") -> [String] {
        var listSelection = DB.defaultSelection
        var index = 1
        for rec in list {
            if (name2 == "") {
                listSelection.append( "\(rec[code]  ?? "") | \(rec[name]  ?? "")")
            } else{
                listSelection.append( "\(rec[code]  ?? "") | \(rec[name]  ?? "") | \(rec[name2]  ?? "")")
            }
            index = index + 1
        }
        return listSelection
    }
    
    public static func getObject<T>(_ obj : T.Type, _ field:  String, _ value : String) -> Object {
        let index = value.firstIndex(of: "|")
        let code = value.slicing(from: 0, to: index! - 1)
        return (DB.filter(obj.self, "\(field)", code!).first)!
    }
    
    public static func getSelectionIndex(_ value : String)  -> Int {
        if (value == self.empty) { return 0 }
        if (value == self.cancel) { return 1 }
        let index = value.index(of: ":") ?? value.endIndex
        return Int(value[..<index])! + 1
    }
    
    public static func new(_ objectName : String) -> BaseRec {
        switch objectName {
            case "Activity" :
                return Activity()
            case "Document" :
                return Document()
            case "Role" :
                return Role()
            case "Comment" :
                return Comment()
            case "Company" :
                return Company()
            case "Issue" :
                return Issue()
            case "Plan" :
                return Plan()
            case "Project" :
                return Project()
            case "Resource" :
                return Resource()
            case "Tssk" :
                return Task()
            case "Audit" :
                return Audit()
            case "Order" :
                return Order()
            case "ActivityHistory" :
                return ActivityHistory()
            case "Status" :
                return Status()
            default :
                return BaseRec()
        }
    }
    
    public static func new<T>(_ objectType : T.Type,_ object: Object, _ isSetDirty: Bool = true) -> Object{
        let realm = try! Realm()
        var nextOrder = 0.0
        if (objectType == Order.self) {
            nextOrder = 0
        } else {
            nextOrder = DB.getNextOrder(objectType)
        }
        try! realm.write {
            object[CREATE_DATE] = Date.init(timeIntervalSinceNow: 0)
            object[CREATE_BY] = NSUserName()
            object[ORDER] = nextOrder
            object[IS_NEW] = true
            updateInternalFields(object)
            realm.add(object)
            realm.add(DB.getAudit(object, AuditAction.New, Date()))
            if (isSetDirty) {
                DB.setDirty("\(type(of: object))", true)
            }
        }
        return object
    }
    
    public static func saveChildObject( _ parentObject : Object?,  _ object : Object, _ isSetDirty: Bool = true) {
        let objectName = "\(type(of: object))".lowercased()
        DB.saveChildObject(objectName, parentObject, object)
    }
    
    public static func saveChildObject(_ objectName : String, _ parentObject : Object?,  _ object : Object, _ isSetDirty: Bool = true) {
        let realm = try! Realm()
        try! realm.write {
            parentObject![objectName] = object
            updateInternalFields(object)
            if (isSetDirty) {
                DB.setDirty("\(type(of: parentObject))", true)
            }
        }
    }
    
    public static func saveEmptyChildObject( _ parentObject : Object, _ objectName : String, _ isSetDirty: Bool = true) {
        let realm = try! Realm()
        try! realm.write {
            parentObject[objectName] = nil
            updateInternalFields(parentObject)
            if (isSetDirty) {
                DB.setDirty("\(type(of: parentObject))", true)
            }
        }
    }
    
    public static func setField<T>(_ object : Object, _ field: String, _ value: T!, _ isAllowNil : Bool = false) {
        let stype = "\(type(of: value))"
        if (value == nil) {
            if (!isAllowNil) {
                switch(stype) {
                case "Optional<Double>" : object[field] = 0.0
                case "Optional<String>" : object[field] = ""
                case "Optional<Bool>" :  object[field] = false
                case "Optional<Int>" : object[field] = 0
                case "Optional<Float>" : object[field] = 0.0
                case "OPtional<Date>" : object[field] = Date()
                default : object[field] = value
                }
            }
        } else {
            if ( String(describing: value) == "Optional<#nil#>"  ) {
                object[field] = nil
            }
            object[field] = value
        }
    }
    
    public static func setLastObject(_ object : Object) {
        // need that to add a audit before leaving the app
        DB.lastObject = object
        DB.lastObjectName = "\(type(of: object))"
        DB.lastObjectDate = Date()
    }
    
    public static func toSelection(_ list : Results<Object>, _ field : String) -> [String] {
        var listSelection = self.defaultSelection
        var index = 1
        for rec in list {
            listSelection.append( "\(String(format: "%03d",index)): \(rec[field] ?? "")")
            index = index + 1
        }
        return listSelection
    }
    
    public static func update<T>(_ object : Object, _ field: String, _ value: T!, _ isAllowNil : Bool = false, _ isSetDirty : Bool = true) {
        let realm = try! Realm()
        try! realm.write {
            DB.setField(object, field, value, isAllowNil)
            DB.setField(object, field, value, isAllowNil)
            updateInternalFields(object)
            if (isSetDirty) {
                DB.setDirty("\(type(of: object))", true)
            }
        }
    }
    
    public static func updateInternalFields(_ object : Object) {
        object[UPDATE_DATE] = Date.init(timeIntervalSinceNow: 0)
        object[UPDATE_BY] = NSUserName()
        object[VERSION] = (object[VERSION] as! Int) + 1
        object[IS_SYNC] = false
        
        DB.setLastObject(object)
    }
    
    public static func updateRecord(_ object : Object, _ fieldArray : [String], _ record : Object, _ isAllowNil : Bool = false, _ isSetDirty : Bool = true)
    {
        let realm = try! Realm()
        try! realm.write {
            for field in fieldArray {
                DB.setField(object, field, record[field], isAllowNil)
            }
            updateInternalFields(object)
            if (isSetDirty) {
                DB.setDirty("\(type(of: object))", true)
            }
        }
    }
    
    public static func updateSubObject<T>(_ object : Object, _ subObject : Object, _ field: String, _ value: T!, _ isAllowNil : Bool = false, _ isSetDirty : Bool = true)
    {
        update(subObject, field, value, isAllowNil, isSetDirty)
        let realm = try! Realm()
        try! realm.write {
            updateInternalFields(object)
            if (isSetDirty) {
                DB.setDirty("\(type(of: object))", true)
            }
        }
    }
    
    
    /* test data */
    public static func addTestData() {
        if (DB.count(Status.self) > 0) {
            return
        }
        
        var status = Status()
        status = DB.new(Status.self, status) as! Status
        
        var company = Company()
        company.code = "CGI"
        company.name = "CGI"
        company.type = "Service"
        company = DB.new(Company.self, company) as! Company
        
        var company2 = Company()
        company2.code = "SNC"
        company2.name = "SNC Lavalin inc."
        company2.type = "Client"
        company2 = DB.new(Company.self, company2) as! Company

        var project = Project()
        project.code = "prj1"
        project.company = company
        project.desc = "Migration"
        project = DB.new(Project.self, project) as! Project
        
        var resource = Resource()
        resource.code = "vinej"
        resource.lastName = "Vinet"
        resource.firstName = "Jean-Yves"
        resource.company = company
        resource.email = "jyvinet@hotmail.ca"
        resource = DB.new(Resource.self, resource) as! Resource

        var resource2 = Resource()
        resource2.code = "beaud"
        resource2.lastName = "Beaulieu"
        resource2.firstName = "Daniel"
        resource2.company = company2
        resource2.email = "daniel@hotmail.ca"
        resource2 = DB.new(Resource.self, resource2) as! Resource
        
        var role = Role()
        role.name = "Analyst"
        role.desc = "analyst"
        role.rateByHour = 50.0
        role = DB.new(Role.self, role) as! Role
        
        var plan = Plan()
        plan.project = project
        plan.isTemplate = true;
        plan.code = "Plan01"
        plan.desc = "Plan01"
        plan = DB.new(Plan.self, plan) as! Plan
        
        var act1 = Activity()
        act1.plan = plan
        act1.code = "Test BA"
        act1.expectedDuration = 30.0
        act1.status = "\(ActivitiyStatus.NotSet)"
        act1.workFlow = "\(ActivityWorkflow.NotStarted)"
        act1.role = role
        act1.resource = resource
        act1.order = 1000
        act1 = DB.new(Activity.self, act1) as! Activity
        
        var act2 = Activity()
        act2.plan = plan
        act2.code = "Test migration"
        act2.expectedDuration = 10.0
        act2.status = "\(ActivitiyStatus.NotSet)"
        act2.workFlow = "\(ActivityWorkflow.NotStarted)"
        act2.role = role
        act2.resource = resource2
        act2.order = 1100
        act2 = DB.new(Activity.self, act2) as! Activity
    }
}

