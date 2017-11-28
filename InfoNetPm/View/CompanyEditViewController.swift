//
//  CompanyEditViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-11-27.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//
import UIKit
import RealmSwift
import Eureka
import SwiftyBeaver

class CompanyEditViewController: BaseEditViewController {

    @objc var company : Company? = nil
    var companyName = "company"
    
    override func setInternalObject(_ object : Object) {
        company = object as? Company
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section("Section Company")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Company name"
                row.value = company?.name
                }.onChange { row in
                    RealmHelper.update(self.company!, #keyPath(Company.name), row.value)
                    RealmHelper.setDirty(#keyPath(company), true)
                }
            
            <<< TextRow(){ row in
                row.title = "Type"
                row.value = company?.type
                row.placeholder = "Type of the company"
                }.onChange { row in
                    RealmHelper.update(self.company!, #keyPath(Company.type), row.value)
                    RealmHelper.setDirty(#keyPath(company), true)                }
        
            form +++ Section("Section Address")
                
            <<< TextAreaRow (){ row in
                row.title = "Address"
                row.value = company?.address?.street
                row.placeholder = "Enter your address"
                }.onChange { row in
                    RealmHelper.update(self.company!.address!, #keyPath(Address.street), row.value)
                    RealmHelper.setDirty(#keyPath(company), true)                }
                
            <<< TextRow (){ row in
                row.title = "City"
                row.value = company?.address?.city
                row.placeholder = "Enter your city"
                }.onChange { row in
                    RealmHelper.update(self.company!.address!, #keyPath(Address.city), row.value)
                    RealmHelper.setDirty(#keyPath(company), true)
            }
            
            <<< PopoverSelectorRow<String>() { row in
                row.title = "State/Province/Region"
                row.options = [RealmHelper.empty,RealmHelper.cancel, "Quebec","Chennai","Bangalore", "New-York"]
                row.value = company?.address?.state
                row.selectorTitle = "Choose your State/Province/Region"
                }.onChange { row in
                    if (row.value != "" && row.value != nil && row.value != RealmHelper.cancel && row.value != RealmHelper.empty) {
                        RealmHelper.update((self.company?.address!)!, #keyPath(Address.state), row.value)
                        RealmHelper.setDirty(#keyPath(company), true)
                    } else {
                        // onChange will be called again
                        if (row.value == RealmHelper.empty) {
                            RealmHelper.update((self.company?.address!)!, #keyPath(Address.state) , "")
                        }
                        row.value = self.company?.address?.state
                    }
                }
                
            <<< PopoverSelectorRow<String>() { row in
                row.title = "Country"
                row.options = [RealmHelper.empty,RealmHelper.cancel, "Canada","India","United State"]
                row.value = company?.address?.country
                row.selectorTitle = "Choose your country"
                }.onChange { row in
                    if (row.value != "" && row.value != nil && row.value != RealmHelper.cancel && row.value != RealmHelper.empty) {
                        RealmHelper.update((self.company?.address!)!, #keyPath(Address.country), row.value)
                        RealmHelper.setDirty(#keyPath(company), true)
                    } else {
                        // onChange will be called again
                        if (row.value == RealmHelper.empty) {
                            RealmHelper.update((self.company?.address!)!, #keyPath(Address.country) , "")
                        }
                        row.value = self.company?.address?.country
                    }
                }
            
            /*
            <<< ActionSheetRow<String>() { row in
                row.title = "Country"
                row.selectorTitle = "Choose your country"
                row.options = ["Canada", "India"]
                row.value = company?.address?.country
                }.onChange { row in
                    RealmHelper.update((self.company?.address!)!, #keyPath(Address.country), row.value)
                    RealmHelper.isCompanyDirty = true
            }
            */
                
            <<< TextRow(){ row in
                row.title = "Postal/Zip code"
                row.value = company?.address?.postalcode
                row.placeholder = "Enter your postal/zip code"
                }.onChange { row in
                    RealmHelper.update(self.company!.address!, #keyPath(Address.postalcode), row.value)
                    RealmHelper.setDirty(#keyPath(company), true)                }
 
                <<< PhoneRow(){ row in
                    row.title = "Phone"
                    row.value = company?.address?.phone
                    row.placeholder = "Enter your phone"
                    }.onChange { row in
                        RealmHelper.update(self.company!.address!, #keyPath(Address.phone), row.value)
                        RealmHelper.setDirty(#keyPath(company), true)                   }
        
                <<< PhoneRow(){ row in
                    row.title = "Phone Home"
                    row.value = company?.address?.phoneHome
                    row.placeholder = "Enter your phone at home"
                    }.onChange { row in
                        RealmHelper.update(self.company!.address!, #keyPath(Address.phoneHome), row.value)
                        RealmHelper.setDirty(#keyPath(company), true)
                    }
        
                <<< EmailRow(){ row in
                    row.title = "Email"
                    row.value = company?.address?.email
                    row.placeholder = "Enter your email"
                    }.onChange { row in
                        RealmHelper.update(self.company!.address!, #keyPath(Address.email), row.value)
                        RealmHelper.setDirty(#keyPath(company), true)
                    }
        
                <<< EmailRow(){ row in
                    row.title = "Email Home"
                    row.value = company?.address?.emailHome
                    row.placeholder = "Enter your email at home"
                    }.onChange { row in
                        RealmHelper.update(self.company!.address!, #keyPath(Address.emailHome), row.value)
                        RealmHelper.setDirty(#keyPath(company), true)
                    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

