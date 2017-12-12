//
//  ViewController.swift
//  InfoNetPm
//
//  Created by jyv on 11/26/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import UIKit
import Eureka
import SwiftyBeaver

let log = SwiftyBeaver.self

class ViewController: UIViewController {

    /*
    @IBAction func defineData(_ sender: UIButton) {
        log.info("Define Data")
    }
    
    
    @IBAction func designPlan(_ sender: UIButton) {
        log.info("Design Plan")
    }
    
    @IBAction func drivePlan(_ sender: UIButton) {
        log.info("Drive Plan")
    }
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

       /*
        // Do any additional setup after loading the view, typically from a nib.
        var cie : Company
        let myCieList = RealmHelper.filter(Company.self, "id != \"t\"")
        if (myCieList.count == 0) {
            cie = RealmHelper.new(Company()) as! Company
            RealmHelper.update(cie, "name", "Empty")
        } else {
            cie = myCieList.first! as! Company
        }
        
        form +++ Section("Section1")
            <<< TextRow(){ row in
                row.title = "Name"
                row.placeholder = "Enter text here"
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
 */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func choosePlan(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "DesignPlan", bundle: nil).instantiateViewController(withIdentifier: "sbChoosePlanID") as! ChoosePopupPlanViewController
        //popOverVC.modalPresentationStyle = .pageSheet
        //self.present(popOverVC, animated: false, completion: nil)
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
}

