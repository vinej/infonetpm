//
//  ResourceEditViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-12-01.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwiftyBeaver

class ResourceEditViewController: BaseEditViewController {
    
    @objc var resource : Resource? = nil
    var companyList : Results<Object>? = nil
    var resourceame = "resource"
    
    override func setInternalObject(_ object : Object) {
        resource = object as? Resource
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        companyList = RealmHelper.all(Company.self)
        
        form +++ Section("Section Resoure")
            
        <<< PopoverSelectorRow<String>() { row in
            row.title = "Company"
            row.options = Company.getOptions(companyList!)
            row.value = resource?.company != nil ? resource?.company?.name : ""
            row.selectorTitle = "Choose a company"
            }.onChange { row in
                if (ProjectEditViewController.isSecondOnChange) {
                    ProjectEditViewController.isSecondOnChange = false
                    return
                }
                if (row.value != nil && row.value != RealmHelper.empty && row.value != RealmHelper.cancel)  {
                    self.resource?.saveCompany(Company.getCompany(row.value!))
                    RealmHelper.setDirty(#keyPath(resource), true)
                } else {
                    if (row.value == RealmHelper.empty) {
                        self.resource?.saveEmptyCompany()
                        RealmHelper.setDirty(#keyPath(resource), true)
                    }
                }
                // set the flag to not do twice the onChange
                ProjectEditViewController.isSecondOnChange = true
                row.value = self.resource?.company != nil ? self.resource?.company?.name : ""
        }
            
        <<< TextRow(){ row in
            row.title = "First Name"
            row.placeholder = "First Name"
            row.value = resource?.firstName
            }.onChange { row in
                RealmHelper.update(self.resource!, #keyPath(Resource.firstName), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }

        <<< TextRow(){ row in
            row.title = "Last Name"
            row.placeholder = "Last Name"
            row.value = resource?.lastName
            }.onChange { row in
                RealmHelper.update(self.resource!, #keyPath(Resource.lastName), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
    
        <<< TextRow(){ row in
            row.title = "Initial"
            row.placeholder = "Initial"
            row.value = resource?.initial
            }.onChange { row in
                RealmHelper.update(self.resource!, #keyPath(Resource.initial), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
    
        <<< DecimalRow(){ row in
            row.title = "Cost"
            row.placeholder = "Cost"
            row.value = resource?.cost
            }.onChange { row in
                RealmHelper.update(self.resource!, #keyPath(Resource.cost), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
        }
    
        <<< DecimalRow(){ row in
            row.title = "Work Hours by Day"
            row.placeholder = "Work Hours by Day"
            row.value = resource?.workHoursByDay == 0 ? nil : resource?.workHoursByDay
            }.onChange { row in
                RealmHelper.update(self.resource!, #keyPath(Resource.workHoursByDay), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
    
        <<< DecimalRow(){ row in
            row.title = "Work Hours by Week"
            row.placeholder = "Work Hours by Week"
            row.value = resource?.workHoursByWeek == 0 ? nil : resource?.workHoursByWeek
            }.onChange { row in
                RealmHelper.update(self.resource!, #keyPath(Resource.workHoursByWeek), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
        
        
        form +++ Section("Section Address")
            
        <<< TextAreaRow (){ row in
            row.title = "Address"
            row.value = resource?.address?.street
            row.placeholder = "Enter your address"
            }.onChange { row in
                RealmHelper.update(self.resource!.address!, #keyPath(Address.street), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
        
        <<< TextRow (){ row in
            row.title = "City"
            row.value = resource?.address?.city
            row.placeholder = "Enter your city"
            }.onChange { row in
                RealmHelper.update(self.resource!.address!, #keyPath(Address.city), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
        
        <<< PopoverSelectorRow<String>() { row in
            row.title = "State/Province/Region"
            row.options = [RealmHelper.empty,RealmHelper.cancel, "Quebec","Chennai","Bangalore", "New-York"]
            row.value = resource?.address?.state
            row.selectorTitle = "Choose your State/Province/Region"
            }.onChange { row in
                if (row.value != "" && row.value != nil && row.value != RealmHelper.cancel && row.value != RealmHelper.empty) {
                    RealmHelper.update((self.resource?.address!)!, #keyPath(Address.state), row.value)
                    RealmHelper.setDirty(#keyPath(resource), true)
                } else {
                    // onChange will be called again
                    if (row.value == RealmHelper.empty) {
                        RealmHelper.update((self.resource?.address!)!, #keyPath(Address.state) , "")
                    }
                    row.value = self.resource?.address?.state
                }
            }
        
        <<< PopoverSelectorRow<String>() { row in
            row.title = "Country"
            row.options = [RealmHelper.empty,RealmHelper.cancel, "Canada","India","United State"]
            row.value = resource?.address?.country
            row.selectorTitle = "Choose your country"
            }.onChange { row in
                if (row.value != "" && row.value != nil && row.value != RealmHelper.cancel && row.value != RealmHelper.empty) {
                    RealmHelper.update((self.resource?.address!)!, #keyPath(Address.country), row.value)
                    RealmHelper.setDirty(#keyPath(resource), true)
                } else {
                    // onChange will be called again
                    if (row.value == RealmHelper.empty) {
                        RealmHelper.update((self.resource?.address!)!, #keyPath(Address.country) , "")
                    }
                    row.value = self.resource?.address?.country
                }
            }
        
        <<< TextRow(){ row in
            row.title = "Postal/Zip code"
            row.value = resource?.address?.postalcode
            row.placeholder = "Enter your postal/zip code"
            }.onChange { row in
                RealmHelper.update(self.resource!.address!, #keyPath(Address.postalcode), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
        
        <<< PhoneRow(){ row in
            row.title = "Phone"
            row.value = resource?.address?.phone
            row.placeholder = "Enter your phone"
            }.onChange { row in
                RealmHelper.update(self.resource!.address!, #keyPath(Address.phone), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
        
        <<< PhoneRow(){ row in
            row.title = "Phone Home"
            row.value = resource?.address?.phoneHome
            row.placeholder = "Enter your phone at home"
            }.onChange { row in
                RealmHelper.update(self.resource!.address!, #keyPath(Address.phoneHome), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
        
        <<< EmailRow(){ row in
            row.title = "Email"
            row.value = resource?.address?.email
            row.placeholder = "Enter your email"
            }.onChange { row in
                RealmHelper.update(self.resource!.address!, #keyPath(Address.email), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
        
        <<< EmailRow(){ row in
            row.title = "Email Home"
            row.value = resource?.address?.emailHome
            row.placeholder = "Enter your email at home"
            }.onChange { row in
                RealmHelper.update(self.resource!.address!, #keyPath(Address.emailHome), row.value)
                RealmHelper.setDirty(#keyPath(resource), true)
            }
    }
}
