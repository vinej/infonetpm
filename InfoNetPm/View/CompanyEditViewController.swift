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

class CompanyEditViewController: FormViewController {

    var company : Company? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        form +++ Section("Section Company")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Company name"
                row.value = company?.name
                }.onChange { row in
                    RealmHelper.update(self.company!, "name", row.value)
                    RealmHelper.isCompanyDirty = true
            }
            
            <<< TextRow(){ row in
                row.title = "Type"
                row.value = company?.type
                row.placeholder = "And type here"
                }.onChange { row in
                    RealmHelper.update(self.company!, "type", row.value)
                    RealmHelper.isCompanyDirty = true
            }
        
            <<< TextRow(){ row in
                row.title = "Country"
                row.value = company?.address?.country
                row.placeholder = "And type here"
                }.onChange { row in
                    RealmHelper.update(self.company!.address!, "country", row.value)
                    RealmHelper.isCompanyDirty = true
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

