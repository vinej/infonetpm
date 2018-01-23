//
//  ResourceEditViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-12-01.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import UIKit
import Eureka
import SwiftyBeaver
import RealmSwift

class ResourceEditViewController: BaseEditViewController {
    
    @objc var resource : Resource? = nil
    var companyList : Results<Object>? = nil
    
    override func setInternalObject(_ object : Object) {
        super.setInternalObject(object)
        resource = object as? Resource
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        companyList = DB.filter(Company.self,"isDeleted = %@", false)
        
        form +++ Section("Section Resoure")
            
        <<< PopoverSelectorRow<String>() { row in
            row.title = "Company"
            row.options = DB.getOptions(companyList!)
            row.value = resource?.company != nil ? resource?.company?.name : ""
            row.selectorTitle = "Choose a company"
            }.onChange { row in
                if (ProjectEditViewController.isSecondOnChange) {
                    ProjectEditViewController.isSecondOnChange = false
                    return
                }
                if (row.value != nil && row.value != DB.empty && row.value != DB.cancel)  {
                    DB.saveChildObject(self.resource, DB.getObject(Company.self, "code = %@", row.value!))
                } else {
                    if (row.value == DB.empty) {
                        DB.saveEmptyChildObject(self.resource!, "company")
                    }
                }
                // set the flag to not do twice the onChange
                ProjectEditViewController.isSecondOnChange = true
                row.value = self.resource?.company != nil ? self.resource?.company?.name : ""
            }
            
        <<< TextRow(){ row in
            row.title = "Code"
            row.placeholder = "Code"
            row.value = resource?.code
            }.onChange { row in
                DB.update(self.resource!, #keyPath(Resource.code), row.value)
            }
            
        <<< TextRow(){ row in
            row.title = "First Name"
            row.placeholder = "First Name"
            row.value = resource?.firstName
            }.onChange { row in
                DB.update(self.resource!, #keyPath(Resource.firstName), row.value)
            }

        <<< TextRow(){ row in
            row.title = "Last Name"
            row.placeholder = "Last Name"
            row.value = resource?.lastName
            }.onChange { row in
                DB.update(self.resource!, #keyPath(Resource.lastName), row.value)
            }
    
        <<< TextRow(){ row in
            row.title = "Initial"
            row.placeholder = "Initial"
            row.value = resource?.initial
            }.onChange { row in
                DB.update(self.resource!, #keyPath(Resource.initial), row.value)
            }
    
        <<< DecimalRow(){ row in
            row.title = "Cost"
            row.placeholder = "Cost"
            row.value = resource?.cost
            }.onChange { row in
                DB.update(self.resource!, #keyPath(Resource.cost), row.value)
        }
    
        <<< DecimalRow(){ row in
            row.title = "Work Hours by Day"
            row.placeholder = "Work Hours by Day"
            row.value = resource?.workHoursByDay == 0 ? nil : resource?.workHoursByDay
            }.onChange { row in
                DB.update(self.resource!, #keyPath(Resource.workHoursByDay), row.value)
            }
    
        <<< DecimalRow(){ row in
            row.title = "Work Hours by Week"
            row.placeholder = "Work Hours by Week"
            row.value = resource?.workHoursByWeek == 0 ? nil : resource?.workHoursByWeek
            }.onChange { row in
                DB.update(self.resource!, #keyPath(Resource.workHoursByWeek), row.value)
            }
        
        
        form +++ Section("Section Address")
            
        <<< TextAreaRow (){ row in
            row.title = "Address"
            row.value = resource?.address?.street
            row.placeholder = "Enter your address"
            }.onChange { row in
                DB.updateSubObject(self.resource!, self.resource!.address!, #keyPath(Address.street), row.value)
            }
        
        <<< TextRow (){ row in
            row.title = "City"
            row.value = resource?.address?.city
            row.placeholder = "Enter your city"
            }.onChange { row in
                DB.updateSubObject(self.resource!, self.resource!.address!, #keyPath(Address.city), row.value)
            }
        
        <<< PopoverSelectorRow<String>() { row in
            row.title = "State/Province/Region"
            row.options = [DB.empty,DB.cancel, "Quebec","Chennai","Bangalore", "New-York"]
            row.value = resource?.address?.state
            row.selectorTitle = "Choose your State/Province/Region"
            }.onChange { row in
                if (row.value != "" && row.value != nil && row.value != DB.cancel && row.value != DB.empty) {
                    DB.updateSubObject(self.resource!,  (self.resource?.address!)!, #keyPath(Address.state), row.value)
                } else {
                    // onChange will be called again
                    if (row.value == DB.empty) {
                        DB.updateSubObject(self.resource!, (self.resource?.address!)!, #keyPath(Address.state) , "")
                    }
                    row.value = self.resource?.address?.state
                }
            }
        
        <<< PopoverSelectorRow<String>() { row in
            row.title = "Country"
            row.options = [DB.empty,DB.cancel, "Canada","India","United State"]
            row.value = resource?.address?.country
            row.selectorTitle = "Choose your country"
            }.onChange { row in
                if (row.value != "" && row.value != nil && row.value != DB.cancel && row.value != DB.empty) {
                    DB.updateSubObject(self.resource!, (self.resource?.address!)!, #keyPath(Address.country), row.value)
                } else {
                    // onChange will be called again
                    if (row.value == DB.empty) {
                        DB.updateSubObject(self.resource!, (self.resource?.address!)!, #keyPath(Address.country) , "")
                    }
                    row.value = self.resource?.address?.country
                }
            }
        
        <<< TextRow(){ row in
            row.title = "Postal/Zip code"
            row.value = resource?.address?.postalcode
            row.placeholder = "Enter your postal/zip code"
            }.onChange { row in
                DB.updateSubObject(self.resource!, self.resource!.address!, #keyPath(Address.postalcode), row.value)
            }
        
        <<< PhoneRow(){ row in
            row.title = "Phone"
            row.value = resource?.address?.phone
            row.placeholder = "Enter your phone"
            }.onChange { row in
                DB.updateSubObject(self.resource!,  self.resource!.address!, #keyPath(Address.phone), row.value)
            }
        
        <<< PhoneRow(){ row in
            row.title = "Phone Home"
            row.value = resource?.address?.phoneHome
            row.placeholder = "Enter your phone at home"
            }.onChange { row in
                DB.updateSubObject(self.resource!, self.resource!.address!, #keyPath(Address.phoneHome), row.value)
            }
        
        <<< EmailRow(){ row in
            row.title = "Email"
            row.value = resource?.address?.email
            row.placeholder = "Enter your email"
            }.onChange { row in
                DB.updateSubObject(self.resource!,  self.resource!.address!, #keyPath(Address.email), row.value)
            }
        
        <<< EmailRow(){ row in
            row.title = "Email Home"
            row.value = resource?.address?.emailHome
            row.placeholder = "Enter your email at home"
            }.onChange { row in
                DB.updateSubObject(self.resource!,  self.resource!.address!, #keyPath(Address.emailHome), row.value)
            }
    }
}
