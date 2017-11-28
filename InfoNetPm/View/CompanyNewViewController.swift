//
//  CompanyNewViewController.swift
//  InfoNetPm
//
//  Created by jyv on 11/27/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka
import SwiftyBeaver

class CompanyNewViewController: FormViewController {
    
    var company : Company? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RealmHelper.isCompanyDirty = true
        
        form +++ Section("Section Company")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Company name"
                row.value = company?.name
                }.onChange { row in
                    RealmHelper.update(self.company!, "name", row.value)
            }
            
            <<< TextRow(){ row in
                row.title = "Type"
                row.value = company?.type
                row.placeholder = "And type here"
                }.onChange { row in
                    RealmHelper.update(self.company!, "type", row.value)
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
