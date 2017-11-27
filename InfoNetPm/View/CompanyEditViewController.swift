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

        form +++ Section("Section1")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Company name"
                row.value = cie.name
                }.onChange { row in
                    RealmHelper.update(cie, "name", row.value)
            }
            
            <<< PhoneRow(){
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
            +++ Section("Section2")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
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
