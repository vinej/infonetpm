//
//  DefineDataViewController.swift
//  InfoNetPm
//
//  Created by jyv on 12/26/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import UIKit

class DefineDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

     @IBAction func choosePlan(_ sender: Any) {
         let popOverVC = UIStoryboard(name: "DefineActivity", bundle: nil).instantiateViewController(withIdentifier: "sbChoosePlanID") as! ChoosePopupPlanViewController
         //popOverVC.modalPresentationStyle = .pageSheet
         //self.present(popOverVC, animated: false, completion: nil)
         self.addChildViewController(popOverVC)
         popOverVC.view.frame = self.view.frame
         self.view.addSubview(popOverVC.view)
         popOverVC.didMove(toParentViewController: self)
     }
}
